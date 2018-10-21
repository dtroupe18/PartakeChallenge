//
//  RequestManager.swift
//  PartakeChallenge
//
//  Created by Dave on 10/21/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

// Generic callbacks
typealias ErrorCallback = (Error) -> Void
typealias DataCallback = (Data) -> Void

// Specific type callbacks
typealias VenueCallback = ([Venue]) -> Void

enum RequestError: String, Error {
    case badURL = "Error URL is not working!"
    case noData = "No Data!"
    case decodeFailed = "Failed to decode!"
    
    func getError(withCode code: Int) -> Error {
        return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey : self.rawValue]) as Error
    }
}

class RequestManager {
    
    // https://api.demo.partaketechnologies.com/api/venue?q=Club&page=2
    
    // - page: starts at 1, used for pagination on conjunction to limit
    // - limit: number of results to return, defaults to 20
    // - q: string to search for a venue by name
    
    private init() {
        // Prevents another instance from being created
    }
    
    static let shared = RequestManager()
    
    private final let baseURL: String =  "https://api.demo.partaketechnologies.com/api/venue"
    
    func makeGetRequest(urlAddition: String?, onSuccess: DataCallback?, onError: ErrorCallback?) {
        // This function can handle all GET requests. It returns data which can then be decoded or an error
        var urlString = baseURL
        
        if let extraUrl = urlAddition {
            urlString += extraUrl
        }
        
        guard let url: URL = URL(string: urlString) else {
            onError?(RequestError.badURL.getError(withCode: 370))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                DispatchQueue.main.async {
                    onError?(err)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    onError?(RequestError.noData.getError(withCode: 371))
                }
                return
            }
            DispatchQueue.main.async {
                onSuccess?(data)
            }
        }
        task.resume()
    }
    
    func getVenues(page: Int, venueCallback: VenueCallback?, onError: ErrorCallback?) {
        makeGetRequest(urlAddition: "?page=\(page)", onSuccess: { data in
            // Decode this data into our desired struct
            do {
                let venueArray = try JSONDecoder().decode([Venue].self, from: data)
                // Here I remove any venues that are missing "required" information before it's passed to the view.
                let filteredVenues = venueArray.filter { $0.longitude != 0.0 && $0.latitude != 0.0 && $0.name != ""
                    && $0.address.city != "" && $0.address.state != "" && $0.imageURL != ""}
                
                var uniqueVenues = [Venue]()
                // Remove duplicates
                for venue in filteredVenues {
                    if !uniqueVenues.contains(venue) {
                        // Removes Venues with the same name + GPS
                        uniqueVenues.append(venue)
                    }
                }
                venueCallback?(uniqueVenues)
            } catch {
                 onError?(RequestError.decodeFailed.getError(withCode: 370))
            }
        }, onError: { error in
             onError?(error)
        })
    }
}
