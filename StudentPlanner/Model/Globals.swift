//
//  Globals.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/9/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

let globalRef = Database.database().reference()
let userRef = globalRef.child("users").child((Auth.auth().currentUser?.uid)!)

//
//extension Array {
//    func contains<T>(obj: T) -> Bool where T : Equatable {
//        return self.filter({$0 as? T == obj}).count > 0
//    }
//}
