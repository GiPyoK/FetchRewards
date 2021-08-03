//
//  SeatGeekDetailViewController.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 8/1/21.
//

import UIKit

class SeatGeekDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    
    var eventController: EventController? {
        didSet {
            updateViews()
        }
    }
    var indexPath: IndexPath? {
        didSet {
            updateViews()
        }
    }
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    var didFavoriteChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if didFavoriteChange {
            guard let eventController = eventController,
                  let indexPath = indexPath else { return }
            
            eventController.updateFavoriteEvent(indexPath: indexPath)
        }
    }
    
    private func updateViews() {
        guard let event = event,
              let eventController = eventController,
              let indexPath = indexPath,
              isViewLoaded else { return }
        
        // image slide show
        
        // navigation bar title
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.text = event.shortTitle
        self.navigationItem.titleView = titleLabel
        
        // date time
        timeLabel.text = Helper.formatDate(date: event.datetimeLocal) ?? event.datetimeLocal
        
        // venue name
        venueNameLabel.text = event.venue.name
        
        // address
        let address = event.venue.address + "\n" + event.venue.extendedAddress
        addressLabel.text = address
        
        // favorite button
        favoriteBarButton.image = eventController.events[indexPath.section][indexPath.row].favorited ? UIImage(named: "star_fill.png") : UIImage(named: "star.png")
    }
    
    @IBAction func favoriteBarButtonTabbed(_ sender: Any) {
        guard let event = event,
              let eventController = eventController else { return }
        
        if event.favorited {
            // Remove the favorited id from the dictionary
            eventController.favorites.removeValue(forKey: "\(event.id)")
            toggleFavoriteButton()
        } else {
            // Add the favorited id to the dictionary
            eventController.favorites["\(event.id)"] = event.id
            toggleFavoriteButton()
        }
    }
    
    private func toggleFavoriteButton() {
        guard let eventController = eventController,
              let indexPath = indexPath  else { return }
        
        eventController.events[indexPath.section][indexPath.row].favorited.toggle()
        favoriteBarButton.image = eventController.events[indexPath.section][indexPath.row].favorited ? UIImage(named: "star_fill.png") : UIImage(named: "star.png")
        didFavoriteChange.toggle()
    }

}
