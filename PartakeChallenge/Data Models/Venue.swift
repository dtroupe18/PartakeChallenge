//
//  Venue.swift
//  PartakeChallenge
//
//  Created by Dave on 10/21/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

struct Venue: Decodable {
    // I removed these because I couldn't find an example where they exist. Assuming they are JSON objects I can't decode them without knowing the structure
    // let stores, restaurants
    
    let id, name, location: String
    let longitude, latitude: Double
    let created: String
    let isPublic: Bool
    let courses: [String]?
    let address: Address?
    let imageURL: String?
    let type: String
    let countryCode: String?
    let website: String?
    let isPreview, shareTabs, trackEmployees: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, location, longitude, latitude, created, isPublic, courses, address
        case imageURL = "imageUrl"
        case type, countryCode, website, isPreview, shareTabs, trackEmployees
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        self.created = try container.decodeIfPresent(String.self, forKey: .created) ?? ""
        self.isPublic = try container.decodeIfPresent(Bool.self, forKey: .isPublic) ?? false
        self.courses = try container.decodeIfPresent([String].self, forKey: .courses) // no default because it's optional
        self.address = try container.decodeIfPresent(Address.self, forKey: .address)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        self.website = try container.decodeIfPresent(String.self, forKey: .website)
        self.isPreview = try container.decodeIfPresent(Bool.self, forKey: .isPreview)
        self.shareTabs = try container.decodeIfPresent(Bool.self, forKey: .shareTabs)
        self.trackEmployees = try container.decodeIfPresent(Bool.self, forKey: .trackEmployees)
    }
}

struct Address: Codable {
    let state: String
    let line1, city: String
    let zip: Int
    let line2, formatted: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        self.line1 = try container.decodeIfPresent(String.self, forKey: .line1) ?? ""
        self.city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.zip = try container.decodeIfPresent(Int.self, forKey: .zip) ?? 0
        self.line2 = try container.decodeIfPresent(String.self, forKey: .line2)
        self.formatted = try container.decodeIfPresent(String.self, forKey: .formatted)
    }
}










