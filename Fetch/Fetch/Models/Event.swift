//
//  Event.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 7/27/21.
//

import Foundation

struct Events: Codable {
    let events: [Event]
}

struct Event: Codable {
    let type: String
    let id: Int
    let datetimeLocal: String
    let shortTitle: String
    let url: String
    
    let venue: Venue
    let performers: [Performer]
    let stats: Stats
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case datetimeLocal = "datetime_local"
        case shortTitle = "short_title"
        case url = "url"
        
        case venue = "venue"
        case performers = "performers"
        case stats = "stats"
    }
}

struct Venue: Codable {
    let id: String
    let name: String
    let address: String
    let city: String
    let state: String
    let postalCode: String
    let displayLocation: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case address = "address"
        case city = "city"
        case state = "state"
        case postalCode = "postal_code"
        case displayLocation = "display_location"
    }
}

struct Performer: Codable {
    let id: Int
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image = "image"
    }
}

struct Stats: Codable {
    let lowestPrice: Int
    let highestPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case lowestPrice = "lowest_price"
        case highestPrice = "highest_price"
    }
}
