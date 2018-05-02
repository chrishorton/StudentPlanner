//
//  StudentClass.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/8/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct StudentClass {
    // list of UID's
    var students = [String]()
    // assignments belonging to each class
    var assignments = [String]()
    var name: String = ""
    var professor: String = ""
    var time: String = ""
    var UID: String = ""
    
    
    init(name: String, students: [String], assignments: [String]) {
        self.students = students
        self.assignments = assignments
    }
    
    init(name:String, key:String) {
        self.name = name
    }
    
    init(snapshot: DataSnapshot) {
        self.name = ((snapshot.value as? NSDictionary)?["name"] as? String)!
        self.professor = ((snapshot.value as? NSDictionary)?["professor"] as? String)!
        self.time = ((snapshot.value as? NSDictionary)?["timeOrPeriod"] as? String)!
        self.UID = ((snapshot.value as? NSDictionary)?["UID"] as? String)!
    }
}
