//
//  SeatGeekDetailViewController.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 8/1/21.
//

import UIKit
import ImageSlideshow
import AlamofireImage

class SeatGeekDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var imageSlideShowView: ImageSlideshow!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    
    // MARK: - Variables
    
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
    
    // MARK: - View functions
    
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
    
    // MARK: - Class functions
    
    private func updateViews() {
        guard let event = event,
              let eventController = eventController,
              let indexPath = indexPath,
              isViewLoaded else { return }
        
        // image slide show
        var imageSources = [InputSource]()
        for performer in event.performers {
            if let imageURL = URL(string: performer.image) {
                imageSources.append(AlamofireSource(url: imageURL))
            }
        }
        
        imageSlideShowView.slideshowInterval = 2.5
        imageSlideShowView.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        imageSlideShowView.contentScaleMode = UIViewContentMode.scaleAspectFill

        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        imageSlideShowView.pageIndicator = pageIndicator

        imageSlideShowView.activityIndicator = DefaultActivityIndicator()
        imageSlideShowView.setImageInputs(imageSources)
        
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
    
    private func toggleFavoriteButton() {
        guard let eventController = eventController,
              let indexPath = indexPath  else { return }
        
        eventController.events[indexPath.section][indexPath.row].favorited.toggle()
        favoriteBarButton.image = eventController.events[indexPath.section][indexPath.row].favorited ? UIImage(named: "star_fill.png") : UIImage(named: "star.png")
        didFavoriteChange.toggle()
    }
    
    // MARK: - IBActions
    
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
}
