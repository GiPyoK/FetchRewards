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
        }
        
        title.text = event.shortTitle
        type.text = event.type
        location.text = event.venue.displayLocation
        time.text = event.datetimeLocal
    }

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
