//
//  EventController.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 7/29/21.
//

import Foundation

class EventController {
    
    var events: [Event] = []
    
    // http://platform.seatgeek.com/#ios-hooks
    let baseURL = URL(string: "https://api.seatgeek.com/2")!
    let clientID = "MjI2Njg5OTV8MTYyNzI2NTMwOC42NjIxODI"
    
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
            
            // TODO: Decode the data
            
        }
        dataTask.resume()
    }
}
