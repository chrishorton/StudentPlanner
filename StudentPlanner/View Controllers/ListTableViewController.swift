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
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // If nothing to do, meme them
        print(assignmentArray)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ((Auth.auth().currentUser) == nil){
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
            self.present(vc, animated: true, completion: nil)
        }
        
        databaseRef = Database.database().reference().child("allAssignments")
        
        databaseRef.observe(.value, with: { (snapshot) in
            
            var newItems = [Assignment]()
            
            for item in snapshot.children {
                
                let newAssignment = Assignment(snapshot: item as! DataSnapshot)
                newItems.insert(newAssignment, at: 0)
                
            }
            self.assignmentArray = newItems
            if self.assignmentArray.count == 0 {
                let image = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y:0), size: CGSize(width: 200, height:200)))
                image.image = UIImage(named: "nothing_to_do.png")
                self.view.addSubview(image)
            }
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AssignmentTableViewCell
        cell.title.text = assignmentArray[indexPath.row].title
        cell.className.text = assignmentArray[indexPath.row].className
        cell.dueDate.text = assignmentArray[indexPath.row].dueDate
        return cell
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
        return assignmentArray.count
    }

}
