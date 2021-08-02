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
    
    var eventController: EventController?
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
        guard let event = event, isViewLoaded else { return }
        
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
    }
    
    @IBAction func favoriteBarButtonTabbed(_ sender: Any) {
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
