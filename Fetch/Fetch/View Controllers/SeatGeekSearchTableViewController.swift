//
//  SeatGeekSearchTableViewController.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 8/1/21.
//

import UIKit

class SeatGeekSearchTableViewController: UITableViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    let eventController = EventController()
    let sectionHeaders = ["Favorites", "Search Results"]

    // MARK: - View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if eventController.events[0].count == 0 && eventController.events[1].count == 0 {
            eventController.performEventSearch(with: "") { error in
                if error != nil {
                    return
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return eventController.events.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventController.events[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeatGeekSearchCell", for: indexPath) as? SeatGeekTableViewCell else { return UITableViewCell() }

        cell.event = eventController.events[indexPath.section][indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewSegue" {
            if let seatGeekDetailVC = segue.destination as? SeatGeekDetailViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                seatGeekDetailVC.eventController = eventController
                seatGeekDetailVC.indexPath = indexPath
                seatGeekDetailVC.event = eventController.events[indexPath.section][indexPath.row]
            }
        }
    }
    

}

// MARK: - Extension

extension SeatGeekSearchTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
        eventController.performEventSearch(with: searchTerm) { error in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        eventController.performEventSearch(with: searchText) { error in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
