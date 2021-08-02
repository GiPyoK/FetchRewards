//
//  SeatGeekTableViewCell.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 8/1/21.
//

import UIKit

class SeatGeekTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let event = event else { return }
        
        if let imageURL = URL(string: event.performers[0].image) {
            thumbnail.load(url: imageURL)
            thumbnail.contentMode = .scaleAspectFill
            thumbnail.layer.cornerRadius = 16
            thumbnail.clipsToBounds = true
        }
        
        title.text = event.shortTitle
        type.text = event.type
        location.text = event.venue.displayLocation
        time.text = Helper.formatDate(date: event.datetimeLocal) ?? event.datetimeLocal
    }

}


