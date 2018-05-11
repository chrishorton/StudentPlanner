//
//  ListTableViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 12/30/17.
//  Copyright © 2017 Christopher Horton. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage
import FirebaseAuth

class ListTableViewController: UITableViewController {

    var assignmentArray = [Assignment]()
    var userClasses = [StudentClass]()
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    var valueToPass: String = ""
    let networkingServices = NetworkingService()

    
    @objc func refresh(refreshControl: UIRefreshControl) {
        tableView.reloadData()
        refreshControl.endRefreshing()
        print("Dero")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.refreshControl = rc
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let viewController = segue.destination as! AssignmentDetailViewController
            viewController.assignment = sender as? Assignment
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignment = assignmentArray[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: assignment)
    }
    
    
    func setObservers(){
        if networkingServices.isconnectedToNetwork() {
            // Beware: this gets messy fast lol
            databaseRef = Database.database().reference().child("Classes")
            databaseRef.observe(.value, with: { (snapshot) in
                var newItems = [Assignment]()
                
                for item in snapshot.children {
                    
                    let snap = item as! DataSnapshot
                    
                    // Tells us that the class UID was found in Classes
                    let found = self.userClasses.filter{$0.UID == snap.key}.count > 0
        
                    if found {
                        // step into assignments in the class and get all assignments for this class
                        self.databaseRef.child(snap.key).child("assignments").observeSingleEvent(of: .value, with: { (snapshot) in
                            for child in snapshot.children {
                                // Iterates all assignments
                                let newchild = child as! DataSnapshot
                                
                                var newAssignment = Assignment(snapshot: newchild, withDesc: false)
                                
                                for child in newchild.children {
                                    // Iterates all completed users of assignment
                                    let newChild = child as! DataSnapshot
                                    print(newChild.children)
                                    if newChild.hasChild((Auth.auth().currentUser?.uid)!) {
                                        let val = newChild.childSnapshot(forPath: (Auth.auth().currentUser?.uid)!).value as! String
                                        if val == "true" {
                                            print("Setting True")
                                            newAssignment.completed = true
                                        } else {
                                            print("Setting false")
                                            newAssignment.completed = false
                                        }

                                    }
                                }
                                
                                newItems.insert(newAssignment, at: 0)
                                self.assignmentArray = newItems
                                self.tableView.reloadData()
                                if self.assignmentArray.count == 0 {
                                    let image = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y:0), size: CGSize(width: 200, height:200)))
                                    image.image = UIImage(named: "nothing_to_do.png")
                                    self.view.addSubview(image)
                                } else if self.assignmentArray.count > 0 {
                                    self.view.subviews.forEach({ $0.removeFromSuperview() })
                                }
                            }
                        })
                    }
                }
        
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Not connected to the internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if ((Auth.auth().currentUser) == nil){
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
            self.present(vc, animated: true, completion: nil)
        }
        self.getUserClasses()
    }
    
    
    func getUserClasses() {
        userRef.child("classIDs").observeSingleEvent(of: .value, with: { (snapshot) in
            var items = [StudentClass]()
            for item in snapshot.children {
                let _class = StudentClass(snapshot: item as! DataSnapshot)
                items.append(_class)
            }
            self.userClasses = items
            self.setObservers()
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Only delete if the poster is the current user
            
            let ref = assignmentArray[indexPath.row].ref
            ref!.removeValue()
            assignmentArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AssignmentTableViewCell
        cell.title.text = assignmentArray[indexPath.row].title
        cell.className.text = assignmentArray[indexPath.row].className
        cell.dueDate.text = assignmentArray[indexPath.row].dueDate
        
        if assignmentArray[indexPath.row].completed {
            print("Completed")
            cell.checkBox.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            if let uncheckedImage = UIImage(named: "unchecked") {
                cell.checkBox.setImage(uncheckedImage, for: .normal)
            } else {
                print("Image not found")
            }
        
        }
        
        return cell
    }
    
    
    
    @IBAction func didClickCheck(_ sender: Any) {
        
        guard let cell = (sender as AnyObject).superview??.superview as? AssignmentTableViewCell else {
            return // or fatalError() or whatever
        }
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        let assignment = assignmentArray[indexPath!.row]
        
        if assignment.completed {
            assignment.ref?.child("completedBy").child((Auth.auth().currentUser?.uid)!).setValue("false")
            self.assignmentArray[(indexPath?.row)!].completed = false
            print("uncompleted")
        } else {
            assignment.ref?.child("completedBy").child((Auth.auth().currentUser?.uid)!).setValue("true")
            self.assignmentArray[(indexPath?.row)!].completed = true
            print("Completed")
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return assignmentArray.count
    }

}
