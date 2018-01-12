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

    // We will add the name to the students properties, the name field will be autocompleted for the user, if it is autocompleted, and the teacher is as well, add the users UID to the current Class, otherwise create a new class name
    
    @IBOutlet weak var nameField: SearchTextField!
    @IBOutlet weak var teacherField: SearchTextField!
    var ref = Database.database().reference()
    var classNames = [String]()
    var teacherNames = [String]()
    
    func fillClassNamesAndTeachersNames() {
    }
    
    @IBAction func addClass(_ sender: Any) {
        let userRef = globalRef.child("users").child(Auth.auth().currentUser!.uid)
        let classRef = globalRef.child("Classes").childByAutoId()
        let key = classRef.key
        
        classRef.child("name").setValue(self.nameField.text)
        classRef.child("professor").setValue(self.teacherField.text)
        classRef.child("UID").setValue(key)
        
        userRef.child("classIDs").child(self.nameField.text!).setValue(key)

        
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let user = UserStruct(snapshot:snapshot)
            let schoolRef = globalRef.child("Schools").child(user.school)
            schoolRef.child("classIDs").child(self.nameField.text!).setValue(key)
            schoolRef.child("Teachers").child(self.teacherField.text!).child("classes").child(self.nameField.text!).setValue(self.nameField.text!)
        }
        let alertController = UIAlertController(title: "Class Added", message: "You have added this class, you can add more now or go back", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        setUpTextField()
    }
    
    func setUpTextField(){
        print(Auth.auth().currentUser!.uid)
        let userRef = globalRef.child("users").child(Auth.auth().currentUser!.uid)
        print(userRef)
        // First we need the users school, then we can get the classes from that school
        userRef.observeSingleEvent(of: .value) { (ogsnapshot) in
            let user = UserStruct(snapshot: ogsnapshot)
            let schoolRef = globalRef.child("Schools").child(user.school).child("classIDs")
            schoolRef.observeSingleEvent(of: .value, with: { (snapshot2) in
                var classUIDs = [String]()
                let enumerator = snapshot2.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    print("Rest: \(rest.value!)")
                    classUIDs.append(rest.value as! String)
                }
                print(classUIDs)
                // Have UID's of classes, now need to fetch class names
                var classNames = [String]()
                let classRef = globalRef.child("Classes")
                print("ClassUIDs: \(classUIDs)")
                for individualClass in classUIDs {
                    classRef.child(individualClass).observeSingleEvent(of: .value, with: { (snapshot3) in
                        let studentclass = StudentClass(snapshot: snapshot3)
                        print("Student Class Name: \(studentclass.name)")
                        classNames.append(studentclass.name)
                        self.nameField.filterStrings(classNames)

                    })
                }
                print("Class Names to Filter: \(classNames)")
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up filtering
        nameField.maxResultsListHeight = 300
        teacherField.maxResultsListHeight = 300
        nameField.minCharactersNumberToStartFiltering = 3
        teacherField.minCharactersNumberToStartFiltering = 3
        
        // Fetch classes and professors to autocomplete
        setUpTextField()
        print("called setuptextfield")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
