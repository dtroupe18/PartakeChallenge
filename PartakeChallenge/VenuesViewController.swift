//
//  LocationsViewController.swift
//  PartakeChallenge
//
//  Created by Dave on 10/21/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import Kingfisher // image downloading & caching
import Anchorage // constraints
import CoreLocation

class VenuesViewController: UIViewController {

    private let header = Header()
    private let tableView = UITableView()
    private final let cellIdentifier: String = "venueCell"
    
    private var venues = [Venue]()
    
    private var cellHeights: [IndexPath: CGFloat] = [:]
    private var loading: Bool = false
    private var currentPage: Int = 1
    private var searchTerm: String?
    
    private let tapGesture = UITapGestureRecognizer()
    private var userLocation = CLLocation()
    let locationManager = CLLocationManager()
    var authStatus = CLLocationManager.authorizationStatus()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        // Fetch initial venues
        loading = true
        RequestManager.shared.getVenues(page: currentPage, searchTerm: searchTerm, venueCallback: { [weak self] venues in
            self?.venues = venues
            self?.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self?.loading = false
            }
        }, onError: { [weak self] error in
            self?.showAlert(title: "Error", actionText: "OK", message: error.localizedDescription)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self?.loading = false
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ask user for permission
        if !canAccessLocation() {
            if authStatus != .denied {
                locationManager.requestWhenInUseAuthorization()
            } else {
                showLocationError()
            }
        }
    }
    
    private func showLocationError() {
        let message = "Without access to your location Partake cannot provide the distance to a venue. You can update location access in settings."
        showAlert(title: "Location Access Denied", actionText: "OK", message: message)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 238
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.prefetchDataSource = self
        
        view.backgroundColor = UIColor.backgroundBlack
        view.addSubview(header)
        view.addSubview(tableView)
        
        header.topAnchor == view.safeTopAnchor + 20
        header.horizontalAnchors == view.horizontalAnchors
        header.bottomAnchor == tableView.topAnchor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.topAnchor == header.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.bottomAnchor == view.bottomAnchor
        tableView.backgroundColor = UIColor.backgroundBlack
        tableView.separatorStyle = .none
        tableView.register(VenueCell.self, forCellReuseIdentifier: cellIdentifier)

        tapGesture.addTarget(self, action: #selector(self.handleTap(recognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        header.searchBar.delegate = self
        locationManager.delegate = self
        // loadVenuesDataFromJson(fileName: "default")
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        if header.searchBar.isFirstResponder {
            header.searchBar.resignFirstResponder()
        }
    }

    private func loadMoreVenues() {
        RequestManager.shared.getVenues(page: currentPage, searchTerm: searchTerm, venueCallback: { [weak self] newVenues in
            
            if !newVenues.isEmpty {
                self?.venues += newVenues
                
                // Add a slight delay here to slow the users overly fast scroll down
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                    UIView.performWithoutAnimation {
                        self?.tableView.reloadData()
                        self?.tableView.beginUpdates()
                        self?.tableView.endUpdates()
                    }
                    self?.loading = false
                }
                
            } else {
                self?.loading = true // nothing else to get stop calling the API
            }
            
            }, onError: { [weak self] error in
                self?.showAlert(title: "Error", actionText: "OK", message: error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self?.loading = false
                }
        })
    }
    
    private func loadVenuesDataFromJson(fileName: String) {
        // I use this function to test the decoding on real JSON. Later it could be used in a more formal test
        let bundle: Bundle = Bundle(for: type(of: self))
        if let path: String = bundle.path(forResource: fileName, ofType: "json") {
            let url: URL = URL(fileURLWithPath: path)
            
            do {
                let simulatedJsonData: Data = try Data(contentsOf: url)
                let venueArray = try JSONDecoder().decode([Venue].self, from: simulatedJsonData)
                self.venues = venueArray
                self.tableView.reloadData()
                
                print("venues: \(venueArray)")
                
            } catch {
                print("\n\nError thrown loading data from JSON: \(error)")
            }
        } else {
            print("Error: Could not load JSON data")
        }
    }
}

// Marker: Location
extension VenuesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if authStatus == .denied {
            showLocationError()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {            
            if let location = locationManager.location {
                userLocation = location
                UIView.performWithoutAnimation {
                    // reload so distances can be displayed
                    tableView.reloadData()
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            } else {
                print("no location!")
            }
        }
    }
    
    private func canAccessLocation() -> Bool {
        switch authStatus {
            
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        case .denied:
            return false
        case .restricted:
            return false
        case .notDetermined:
            return false
        }
    }
}

// Marker: Search
extension VenuesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var shouldLoadVenues: Bool = false
        textField.resignFirstResponder()
        
        if textField.text != "", var term = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            term = term.replacingOccurrences(of: "\\s+|\\s$", with: " ", options: .regularExpression) // makes all spaces single so the url will work
            guard let escapedTerm = term.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return false }

            shouldLoadVenues = true
            searchTerm = escapedTerm
            currentPage = 1
            print("search term: \(escapedTerm)")
            loading = true
        } else if searchTerm != nil && textField.text == "" {
            // user cleared the textField so remove the search
            shouldLoadVenues = true
            searchTerm = nil
            currentPage = 1
            loading = true
        }
        
        if shouldLoadVenues {
            RequestManager.shared.getVenues(page: 1, searchTerm: searchTerm, venueCallback: { [weak self] newVenues in
                self?.venues = newVenues
                self?.tableView.reloadData()
                
                if !newVenues.isEmpty {
                    self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                } else {
                    self?.showAlert(title: "No Results", actionText: "OK", message: "We couldn't find any venues that matches your request!")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self?.loading = false
                }
                }, onError: { [weak self] error in
                    self?.showAlert(title: "Error", actionText: "OK", message: error.localizedDescription)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self?.loading = false
                    }
            })
        }
        return false
    }
}

// Marker: TableView
extension VenuesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! VenueCell
        cell.configure(withVenue: venues[indexPath.row], userLocation: userLocation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        
        if !loading && indexPath.row + 5 >= venues.count {
            print("loading more!")
            loading = true
            currentPage += 1
            loadMoreVenues()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 230.0
    }
}

extension VenuesViewController: UITableViewDelegate {
    // unused as of now
}

// Marker: Prefetching
extension VenuesViewController: UITableViewDataSourcePrefetching {
    // Starts loading images ahead of the users current scroll position
    
    private func getImageUrls(for indexPaths: [IndexPath]) -> [URL] {
        var urls = [URL]()
        for indexPath in indexPaths {
            if indexPath.row < venues.count {
                if let url = URL(string: venues[indexPath.row].imageURL) {
                    urls.append(url)
                }
            }
        }
        return urls
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = getImageUrls(for: indexPaths)
        ImagePrefetcher(urls: urls).start()
    }
}

