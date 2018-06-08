//
//  AllClassesForSchoolTableViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 4/23/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AllClassesForSchoolTableViewController: UITableViewController {

    var classes = [StudentClass]()
    var user: UserStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "JoinClassCell", bundle: nil), forCellReuseIdentifier: "joinClassCell")
        getCurrentUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    // Left off here, maybe try storing user in a CoreData store, so we don't have to fetch from Firebase, or just load the users data in once the application loads
    func getCurrentUserInfo() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var retrievedUser: UserStruct?
            retrievedUser = UserStruct(snapshot: snapshot)
            if let tempUser = retrievedUser {
                self.user = tempUser
            }
            self.fetchClasses()
        })
    }

    func fetchClasses(){
        print("Fetching")
        let classRef = Database.database().reference().child("Schools").child((self.user?.school)!).child("classes")
        var newClasses = [StudentClass]()
        classRef.observe(.value, with: { (snapshot) in
            for individual_class in snapshot.children {
                let student_class_snap = individual_class as? DataSnapshot
                let student_class = StudentClass(snapshot: student_class_snap!)
                newClasses.append(student_class)
            }
            self.classes = newClasses
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinClassCell", for: indexPath) as! JoinTableViewCell
        cell.className.text = classes[indexPath.row].name
        cell.instructorName.text = classes[indexPath.row].professor
        cell.periodOrTime.text = classes[indexPath.row].time
        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Database.database().reference().child("Schools").child((self.user?.school)!).child("classes").removeAllObservers()
    }

}
