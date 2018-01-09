//
//  AddViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 12/30/17.
//  Copyright © 2017 Christopher Horton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var assignmentTitle: UITextField!
    @IBOutlet weak var assignmentDescription: UITextField!
    @IBOutlet weak var classPicker: UIPickerView!
    var databaseRef = Database.database().reference().child("users")
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.classPicker.delegate = self
        self.classPicker.dataSource = self
        
        let classRef = databaseRef.child((Auth.auth().currentUser?.uid)!).child("classes")
        classRef.observe(.value) { (snapshot) in
            var items = [StudentClass]()
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        let databaseRef = Database.database().reference()
        let assignmentRef = databaseRef.child("allAssignments").childByAutoId()
        let currentUser =  Auth.auth().currentUser?.displayName
        print(currentUser!)
        let assignment = Assignment(title: assignmentTitle.text!, className: assignmentDescription.text!, dueDate: currentUser!)
        
        assignmentRef.setValue(assignment.toAnyObject())
        print("Added")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
