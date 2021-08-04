//
//  EventController.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 7/29/21.
//

import Foundation

class EventController {
    
    var events: [[Event]] = [[Event](), [Event]()]
    var unFavEvents: [Event] = []
    var favEvents: [Event] = []
    var favorites: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.setValue(favorites, forKey: "favorites")
            print("UserDefaults set")
        }
    }
    
    // http://platform.seatgeek.com/#ios-hooks
    let baseURL = URL(string: "https://api.seatgeek.com/2")!
    let clientID = "MjI2Njg5OTV8MTYyNzI2NTMwOC42NjIxODI"
    
    init() {
        // get favorited event id's
        if let favoritesDefault = UserDefaults.standard.dictionary(forKey: "favorites") as? [String: Int] {
            favorites = favoritesDefault
        }
        
        updateEvents()
    }
    
    private func updateEvents() {
        events[0] = favEvents
        events[1] = unFavEvents
    }
    
    func updateFavoriteEvent(indexPath: IndexPath) {
        if indexPath.section == 0 {
            // remove from favEvents and add to unFavEvents
            var unFavEvent = events[0].remove(at: indexPath.row)
            unFavEvent.favorited = false
            events[1].insert(unFavEvent, at: 0)
            
            // update favorites dictionary
            favorites.removeValue(forKey: "\(unFavEvent.id)")
        } else {
            // remove from unFavEvents and add to favEvents
            var favEvent = events[1].remove(at: indexPath.row)
            favEvent.favorited = true
            events[0].append(favEvent)
            
            // update favorites dictionary
            favorites["\(favEvent.id)"] = favEvent.id
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
                var searchResult = try decoder.decode(Events.self, from: data)
                for index in 0..<searchResult.events.count {
                    let event = searchResult.events[index]
                    if self.favorites["\(event.id)"] != nil {
                        searchResult.events[index].favorited = true
                    }
                }
                self.unFavEvents = searchResult.events.filter { $0.favorited == false }
                self.favEvents = searchResult.events.filter {$0.favorited == true }
                self.updateEvents()
                completion(nil)
            } catch {
                NSLog("EventController::performEventSearch: Error decoding \(searchQuery) search: \(error)")
                completion(error)
            }
        }
        dataTask.resume()
    }
}
