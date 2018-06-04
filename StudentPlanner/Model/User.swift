//
//  User.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/2/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct UserStruct {
    
    
    var username: String!
    var email: String!
    var photoUrl: String!
    var school: String!
    var ref: DatabaseReference?
    var key: String
    
    init(snapshot: DataSnapshot){
        
        key = snapshot.key
        
        username = (snapshot.value as? NSDictionary)?["username"] as? String ?? ""
        email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
        photoUrl = (snapshot.value as? NSDictionary)?["photoUrl"] as? String ?? ""
        school = (snapshot.value as? NSDictionary)?["school"] as? String ?? ""
        ref = snapshot.ref
        
    }
    
    
    
}
