//
//  FetchTests.swift
//  FetchTests
//
//  Created by Gi Pyo Kim on 8/4/21.
//

import XCTest

@testable import Fetch

class FetchTests: XCTestCase {
    
    func testQuerySearchSoccer() {
        let eventController = Fetch.EventController()
        
        let resultsExpectation = expectation(description: "Wait for the search results")
        
        eventController.performEventSearch(with: "soccer") { error in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
            resultsExpectation.fulfill()
        }
        
        wait(for: [resultsExpectation], timeout: 5)
        
        // Should have search results in events array
        XCTAssertTrue(eventController.events[0].count > 0 || eventController.events[1].count > 0)
    }
    
    func testFavoritingEvent() {
        // Reset any saved favorite events
        UserDefaults.resetStandardUserDefaults()
        
        // setup EventController
        let eventController = Fetch.EventController()
        
        let resultsExpectation = expectation(description: "Wait for the search results")
        eventController.performEventSearch(with: "") { error in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
            resultsExpectation.fulfill()
        }
        
        wait(for: [resultsExpectation], timeout: 5)
        let event: Event = eventController.events[1][0]
        
        // setup SeatGeekDetailViewController
        let detailViewController = SeatGeekDetailViewController()
        detailViewController.indexPath =  IndexPath(row: 0, section: 1)
        detailViewController.event = event
        detailViewController.eventController = eventController
        
        eventController.favorites["\(event.id)"] = event.id
        eventController.events[1][0].favorited.toggle()
        detailViewController.didFavoriteChange.toggle()
        
        detailViewController.viewWillDisappear(true)
        
        // Should have favorited event ID in eventController's favorites dictionary
        XCTAssertTrue(eventController.favorites["\(event.id)"] == event.id)
        
        // UserDefaults should have saved the event ID
        let favoritesDefault = UserDefaults.standard.dictionary(forKey: "favorites") as? [String: Int]
        XCTAssertNotNil(favoritesDefault)
        XCTAssertTrue(favoritesDefault!["\(event.id)"] == event.id)
        
        // Favorited event should be in the first section of events array
        XCTAssertTrue(eventController.events[0].count > 0)
        let testEvent = eventController.events[0].filter { $0.id == event.id }
        XCTAssertTrue(testEvent.count == 1)
    }

}
