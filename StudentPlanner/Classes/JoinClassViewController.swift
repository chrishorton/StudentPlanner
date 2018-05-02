//
//  JoinClassViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/10/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit
import SearchTextField
import FirebaseAuth
import FirebaseDatabase

class JoinClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var searchInstructorName: SearchTextField!
    @IBOutlet weak var classPicker: UIPickerView!
    var pickerData = [String]()
    
    
    
    @IBAction func instructorEntered(_ sender: Any) {
        populatePicker(with: searchInstructorName.text!)
    }
    
    func fillSearchInstructorName() {
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let user = UserStruct(snapshot: snapshot)
            let school = user.school
            print(school!)
            let schoolRef = globalRef.child("Schools").child(school!).child("Teachers")
            var teachers = [String]()
            
            
            schoolRef.observe(.value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    teachers.append(rest.key)
                    print(rest.key)
                }
                print(teachers)
                self.searchInstructorName.filterStrings(teachers)
            })
        }
    }
    
    func populatePicker(with teacher: String) {
        if teacher == "" {
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                let user = UserStruct(snapshot: snapshot)
                let school = user.school
                let schoolRef = globalRef.child("Schools").child(school!).child("classIDs")
                schoolRef.observeSingleEvent(of: .value, with: { (snapshot2) in
                    let enumerator = snapshot2.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        self.pickerData.append(rest.key)
                        print(rest.key)
                    }
                    self.classPicker.reloadAllComponents()
                })
            }
        } else {
            print("populating with instructor")
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                let user = UserStruct(snapshot: snapshot)
                let school = user.school
                let schoolRef = globalRef.child("Schools").child(school!).child("Teachers")
                
                schoolRef.observeSingleEvent(of: .value, with: { (snapshot2) in
                    if snapshot2.hasChild(teacher) {
                        schoolRef.child(teacher).observe(.value, with: { (snapshot3) in
                            let enumerator = snapshot2.children
                            while let rest = enumerator.nextObject() as? DataSnapshot {
                                self.pickerData.append(rest.key)
                                print(rest.key)
                            }
                            self.classPicker.reloadAllComponents()
                        })
                        
                    }
                })
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classPicker.dataSource = self
        classPicker.delegate = self
        // Do any additional setup after loading the view.
        fillSearchInstructorName()
        populatePicker(with: "")
        print(self.pickerData)
        self.classPicker.reloadAllComponents()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
}
