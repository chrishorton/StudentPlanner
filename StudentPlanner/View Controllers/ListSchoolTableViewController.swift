//
//  ListSchoolTableViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 8/4/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import FirebaseDatabase
import UIKit

class ListSchoolTableViewController: UITableViewController {
    
    
    var schools = [String]()
    var filteredSchools = [String]()
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SchoolTableViewCell", bundle: nil), forCellReuseIdentifier: "schoolCell")
        let ref = Database.database().reference().child("Schools")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for item in snapshot.children {
                let snap = item as! DataSnapshot
                self.schools.append(snap.key)
            }
            self.tableView.reloadData()
        }
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Schools"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath) as! SchoolTableViewCell
        
        if isFiltering() {
            cell.label.text = filteredSchools[indexPath.row]
        } else {
            cell.label.text = schools[indexPath.row]
        }

        return cell
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSchools = schools.filter({( school : String) -> Bool in
            return school.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredSchools.count
        }
        
        return schools.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFinal", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
extension ListSchoolTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
