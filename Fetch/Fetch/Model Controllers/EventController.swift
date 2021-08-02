//
//  EventController.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 7/29/21.
//

import Foundation

class EventController {
    
    var events: [Event] = []
    var favEvents: [Event] = []
    var favorites: [String: Int] = [:]
    
    // http://platform.seatgeek.com/#ios-hooks
    let baseURL = URL(string: "https://api.seatgeek.com/2")!
    let clientID = "MjI2Njg5OTV8MTYyNzI2NTMwOC42NjIxODI"
    
    init() {
        // get favorited event id's
        if let favoritesDefault = UserDefaults.standard.dictionary(forKey: "favorites") as? [String: Int] {
            favorites = favoritesDefault
            getFavoriteEvents(with: favorites) { error in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
            }
        }
    }
    
    /// Perform event search with query argument
    func performEventSearch (with searchQuery: String, completion: @escaping(Error?) -> Void) {
        
        // Build the URL
        let searchURL = baseURL.appendingPathComponent("events")
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let parameters: [String: String] = ["client_id": clientID, "q": searchQuery]
        let queryItems = parameters.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
        components?.queryItems = queryItems
        
        // Create the URL Request
        guard let requestURL = components?.url else {
            NSLog("EventController::performEventSearch: Could not build request URL")
            completion(NSError())
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        // Perform the request
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle any errors
            if let error = error {
                NSLog("EventController::performEventSearch: Error searching \(searchQuery)")
                completion(error)
                return
            }
            
            // Should get 200 for a good search
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    NSLog("EventController::performEventSearch: Error searching \(searchQuery), code: \(httpResponse.statusCode)")
                    completion(NSError())
                    return
                }
            }
            
            // Decode the data
            guard let data = data else {
                NSLog("EventController::performEventSearch: No data returned from \(searchQuery)")
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let searchResult = try decoder.decode(Events.self, from: data)
                self.events = searchResult.events
                completion(nil)
            } catch {
                NSLog("EventController::performEventSearch: Error decoding \(searchQuery) search: \(error)")
                completion(error)
            }
        }
        dataTask.resume()
    }
    
    /// Perform event search with favorite event id's
    func getFavoriteEvents (with idDict: [String: Int], completion: @escaping(Error?) -> Void) {
        
        let idString = idDict.map { $0.key }.joined(separator: ",")
        
        // Build the URL
        let searchURL = baseURL.appendingPathComponent("events")
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let parameters: [String: String] = ["client_id": clientID, "id": idString]
        let queryItems = parameters.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
        components?.queryItems = queryItems
        
        // Create the URL Request
        guard let requestURL = components?.url else {
            NSLog("EventController::getFavoriteEvents: Could not build request URL")
            completion(NSError())
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        // Perform the request
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle any errors
            if let error = error {
                NSLog("EventController::getFavoriteEvents: Error getting favorite events")
                completion(error)
                return
            }
            
            // Should get 200 for a good search
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    NSLog("EventController::getFavoriteEvents: Error getting favorite events, code: \(httpResponse.statusCode)")
                    completion(NSError())
                    return
                }
            }
            
            // Decode the data
            guard let data = data else {
                NSLog("EventController::getFavoriteEvents: No data returned from favorite id's")
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let searchResult = try decoder.decode(Events.self, from: data)
                self.favEvents = searchResult.events
                completion(nil)
            } catch {
                NSLog("EventController::getFavoriteEvents: Error decoding favorite events, \(error)")
                completion(error)
            }
        }
        dataTask.resume()
    }
}
