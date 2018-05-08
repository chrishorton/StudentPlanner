//
//  AddClassViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/9/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SearchTextField

class AddClassViewController: UIViewController {
    
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var nameField: SearchTextField!
    @IBOutlet weak var teacherField: SearchTextField!
    @IBOutlet weak var dayField: UITextField!
    
    var ref = Database.database().reference()
    var classNames = [String]()
    var teacherNames = [String]()
    var user:UserStruct?
    
    var userRef = globalRef.child("users").child(Auth.auth().currentUser!.uid).child("classIDs")
    var classRef = globalRef.child("Classes")
    
    
//    func getCurrentUserInfo() -> UserStruct {
//        let userID = Auth.auth().currentUser?.uid
//        let ref = Database.database().reference().child("users").child(userID!)
//        
//        ref.observe(.value, with: { (snapshot) in
//            var retrievedUser: UserStruct?
//            retrievedUser = UserStruct(snapshot: snapshot)
//            self.user = retrievedUser
//        })
//    }
//    
    var school: String = ""
    var retrievedUser: UserStruct?
    
    func setData(){
        let schoolRef = globalRef.child("Schools").child(self.school)
        classRef = classRef.childByAutoId()
        let key = classRef.key
        userRef = userRef.child(key)

        let student_class = StudentClass(name: self.nameField.text!, professor: self.teacherField.text!, UID: key, timeOrPeriod: timeField.text!, dayOfWeek: dayField.text!)
        let any_student_class = student_class.toAnyObject()
        classRef.setValue(any_student_class)
        userRef.setValue(any_student_class)
        ref.child("Teachers").child(self.teacherField.text!).child("classes").child(self.nameField.text!).setValue(self.nameField.text!)
        
        let newRef = schoolRef.child("classes").child(key)
        newRef.child("UID").setValue(key)
        newRef.child("name").setValue(self.nameField.text)
        newRef.child("professor").setValue(self.teacherField.text)
        newRef.child("timeOrPeriod").setValue(self.timeField.text)
    }

    @IBAction func addClass(_ sender: Any) {

        ref.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.retrievedUser = UserStruct(snapshot: snapshot)
            self.school = (self.retrievedUser?.school)!
            self.setData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        let alertController = UIAlertController(title: "Class Added", message: "You have added this class, you can add more now or go back", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
//    func setUpTextField(){
//        print(Auth.auth().currentUser!.uid)
//        let userRef = globalRef.child("users").child(Auth.auth().currentUser!.uid)
//        print(userRef)
//        // First we need the users school, then we can get the classes from that school
//        userRef.observeSingleEvent(of: .value) { (ogsnapshot) in
//            let user = UserStruct(snapshot: ogsnapshot)
//            let schoolRef = globalRef.child("Schools").child(user.school).child("classIDs")
//            schoolRef.observeSingleEvent(of: .value, with: { (snapshot2) in
//                var classUIDs = [String]()
//                let enumerator = snapshot2.children
//                while let rest = enumerator.nextObject() as? DataSnapshot {
//                    print("Rest: \(rest.value!)")
//                    classUIDs.append(rest.value as! String)
//                }
//                print(classUIDs)
//                // Have UID's of classes, now need to fetch class names
//                var classNames = [String]()
//                let classRef = globalRef.child("Classes")
//                print("ClassUIDs: \(classUIDs)")
//                for individualClass in classUIDs {
//                    classRef.child(individualClass).observeSingleEvent(of: .value, with: { (snapshot3) in
//                        let studentclass = StudentClass(snapshot: snapshot3)
//                        print("Student Class Name: \(studentclass.name)")
//                        classNames.append(studentclass.name)
//                        self.nameField.filterStrings(classNames)
//
//                    })
//                }
//                print("Class Names to Filter: \(classNames)")
//            })
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up filtering
        nameField.maxResultsListHeight = 300
        teacherField.maxResultsListHeight = 300
        nameField.minCharactersNumberToStartFiltering = 3
        teacherField.minCharactersNumberToStartFiltering = 3
        
        // Fetch classes and professors to autocomplete
        // setUpTextField()
    }
}
