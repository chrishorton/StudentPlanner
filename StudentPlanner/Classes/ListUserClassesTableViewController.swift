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

class ListClassesTableViewController: UITableViewController, CellDelegate {

    @IBOutlet weak var segControl: UISegmentedControl!
    
    var classes = [StudentClass]()
    let ref = userRef.child("classIDs")

    @IBAction func indexChanged(_ sender: Any) {
        setUpTableView()
    }
    
    func setObserver(for ID: String){
        if (ID == "userClasses") {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
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
        } else{
            ref.observeSingleEvent(of: .value) { (snapshot) in
                var temp = [StudentClass]()
                for child in snapshot.children {
                    let childSnap = child as! DataSnapshot
                    let student_class = StudentClass(snapshot: childSnap)
                    temp.append(student_class)
                }
                self.classes = temp
                print(self.classes)
                self.tableView.reloadData()
            }
        }
        
    }
    
    func setUpTableView(){
        self.classes.removeAll()
        if segControl.selectedSegmentIndex == 0{
            setObserver(for: "userClasses")
        } else {
            setObserver(for: "allClasses")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "JoinClassCell", bundle: nil), forCellReuseIdentifier: "joinClassCell")
        setUpTableView()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classes.count
    }

    func didTap(_ cell: JoinTableViewCell){
        let indexPath = self.tableView.indexPath(for: cell)
        userRef.child("classIDs").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(self.classes[indexPath!.row].UID) {
                print(snapshot.children)
                let alert = UIAlertController(title: "My Alert", message: "Oops, you've already joined this class!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The ok alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let _class = self.classes[(indexPath?.row)!].toAnyObject()
                userRef.child("classIDs").child(self.classes[indexPath!.row].UID).setValue(_class)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinClassCell", for: indexPath) as! JoinTableViewCell
        cell.delegate = self
        cell.className.text = self.classes[indexPath.row].name
        cell.instructorName.text = self.classes[indexPath.row].professor
        cell.periodOrTime.text = self.classes[indexPath.row].time
        cell.dayLabel.text = self.classes[indexPath.row].day
        if segControl.selectedSegmentIndex == 0 {
            cell.joinButton.setTitle("", for: .normal)
        } else {
            cell.joinButton.setTitle("Join this Class", for: .normal)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
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

protocol CellDelegate: class {
    func didTap(_ cell: JoinTableViewCell)
}
