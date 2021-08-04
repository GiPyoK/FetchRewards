//
//  SeatGeekTableViewCell.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 8/1/21.
//

import UIKit

class SeatGeekTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    
    // MARK: - Variables
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Class functions
    
    private func updateViews() {
        guard let event = event else { return }
        
        if let imageURL = URL(string: event.performers[0].image) {
            thumbnail.load(url: imageURL)
            thumbnail.contentMode = .scaleAspectFill
            thumbnail.layer.cornerRadius = 16
            thumbnail.clipsToBounds = true
        }
        
        title.text = event.shortTitle
        type.text = formatEventType(text: event.type)
        location.text = event.venue.displayLocation
        time.text = Helper.formatDate(date: event.datetimeLocal) ?? event.datetimeLocal
    }
    
    private func formatEventType(text: String) -> String {
        // replace underscores with spaces and capitalize the first characters
        var output = text.replacingOccurrences(of: "_", with: " ").capitalized
        
        // if the output string is a single word, capitalize the whole word. ex) MLB
        if !output.contains(" ") && output.count <= 3 {
            output = output.uppercased()
        }
        
        return output
    }

}


