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
    
    
    init(name: String, students: [String], assignments: [String]) {
        self.students = students
        self.assignments = assignments
    }
    
    init(snapshot: DataSnapshot) {
//        students = ((snapshot.value as? NSDictionary)?["students"] as? [String])!
//        assignments = ((snapshot.value as? NSDictionary)?["assignmentUIDs"] as? [String])!
        name = ((snapshot.value as? NSDictionary)?["name"] as? String)!
        professor = ((snapshot.value as? NSDictionary)?["professor"] as? String)!
    }
}
