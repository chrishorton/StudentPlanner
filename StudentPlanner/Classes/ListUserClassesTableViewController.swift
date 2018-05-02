//
//  ListClassesTableViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 4/23/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ListClassesTableViewController: UITableViewController {

    var classes = [StudentClass]()
    let ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("classIDs")

    func setObserver(){
        ref.observe(.value, with: { (snapshot) in
            var tempClasses = [StudentClass]()
            if snapshot.exists() {
                for individual_class in snapshot.children {
                    let student_class_snap = individual_class as? DataSnapshot
                    let student_class = StudentClass(snapshot: student_class_snap!)
                    tempClasses.append(student_class)
                }
                self.classes = tempClasses.reversed()
                print(self.classes)
                self.tableView.reloadData()
            } else {
                print("nothing done, snap was nil")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "JoinClassCell", bundle: nil), forCellReuseIdentifier: "joinClassCell")
        setObserver()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinClassCell", for: indexPath) as! JoinTableViewCell
        cell.className.text = self.classes[indexPath.row].name
        cell.instructorName.text = self.classes[indexPath.row].professor
        cell.periodOrTime.text = self.classes[indexPath.row].time
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier  == "toAllClasses" {
//            let newVC = AllClassesForSchoolTableViewController()
//            print("Segue")
//            newVC.getCurrentUserInfo()
//        }
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        globalRef.removeAllObservers()
        ref.removeAllObservers()
    }
    
    
}
