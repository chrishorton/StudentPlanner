//
//  JoinClassTableViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 4/23/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit
import FirebaseDatabase

class JoinClassTableViewController: UITableViewController {

    var classes = [StudentClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchClasses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinClassCell", for: indexPath) as! JoinTableViewCell
        cell.className.text = classes[indexPath.row].name
        cell.instructorName.text = classes[indexPath.row].professor
        cell.periodOrTime.text = classes[indexPath.row].time
        return cell
    }

    func fetchClasses(){
        let ref = userRef.child("classIDs")
        print("Fetching")
        print(classes)
        ref.observe(.value, with: { (snapshot) in
            let student_class = StudentClass(snapshot: snapshot)
            self.classes.append(student_class)
        })
    }
}
