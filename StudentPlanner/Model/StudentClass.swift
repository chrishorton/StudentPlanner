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
    var assignments = [Assignment]()
    
    init(snapshot: DataSnapshot) {
//        students = snapshot.value!["students"] as! [String]
//        assignments = snapshot.value!["assignments"] as! [String]
    }
}
