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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
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
        // loadVenuesDataFromJson(fileName: "default")
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        if header.searchBar.isFirstResponder {
            header.searchBar.resignFirstResponder()
        }
    }

    private func loadMoreVenues() {
        print("loading more")
        RequestManager.shared.getVenues(page: currentPage, searchTerm: searchTerm, venueCallback: { [weak self] newVenues in
            self?.venues += newVenues
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

extension VenuesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var shouldLoadVenues: Bool = false
        textField.resignFirstResponder()
        
        if textField.text != "", let term = textField.text {
            shouldLoadVenues = true
            searchTerm = term
            loading = true
        } else if searchTerm != nil && textField.text == "" {
            // user cleared the textField so remove the search
            shouldLoadVenues = true
            searchTerm = nil
            loading = true
        }
        
        if shouldLoadVenues {
            RequestManager.shared.getVenues(page: 1, searchTerm: searchTerm, venueCallback: { [weak self] newVenues in
                self?.venues = newVenues
                self?.tableView.reloadData()
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
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

extension VenuesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! VenueCell
        cell.configure(withVenue: venues[indexPath.row])
        cell.hide()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let venueCell = cell as? VenueCell {
            cellHeights[indexPath] = cell.frame.size.height
            venueCell.show()
        }
        
        if !loading && indexPath.row == venues.count - 10 {
            loading = true
            currentPage += 1
            loadMoreVenues()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 200.0
    }
}

extension VenuesViewController: UITableViewDelegate {
    // unused as of now
}

extension VenuesViewController: UITableViewDataSourcePrefetching {
    // Starts loading images ahead of the users current scroll position
    
    func getImageUrls(for indexPaths: [IndexPath]) -> [URL] {
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

