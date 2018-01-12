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
import SwiftyChrono

class AddViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var assignmentName: UITextField!
    @IBOutlet weak var assignmentDueDate: UITextField!
    @IBOutlet weak var classPicker: UIPickerView!
    
    var databaseRef = Database.database().reference().child("users")
    var pickerData = [String]()
    

    func processDate() -> String{
        let chrono = Chrono()
        let date = chrono.parseDate(text: assignmentDueDate.text!)
        let newdate = date?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        return newdate!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.classPicker.delegate = self
        self.classPicker.dataSource = self
        
        
        // Add users classes to picker
        let classRef = databaseRef.child((Auth.auth().currentUser?.uid)!).child("classIDs")
        classRef.observe(.value) { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.pickerData.append(rest.key)
            }
        }
    }
    
    func handlePickerData() -> String {
        let row = classPicker.selectedRow(inComponent: 0)
        return pickerData[row]
    }
    
    @IBAction func addAction(_ sender: Any) {
        let databaseRef = Database.database().reference()
        let assignmentRef = databaseRef.child("allAssignments").childByAutoId()
        let currentUser =  Auth.auth().currentUser?.displayName
        print(currentUser!)
        
        let assignment = Assignment(title: assignmentName.text!, className: handlePickerData(), dueDate: processDate())
        
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
