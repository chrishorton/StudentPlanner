//
//  Assignment.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/2/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Assignment {
    
    var title: String!
    var className: String!
    var dueDate: String!

    var ref: DatabaseReference?
    var key: String!
    
    
    init(title: String, className: String, dueDate: String, key: String = ""){
        
        self.title = title
        self.className = className
        self.dueDate = dueDate

        self.key = key
        self.ref = Database.database().reference()
        
        
    }
    
    init(snapshot: DataSnapshot){
        self.title = (snapshot.value as? NSDictionary)?["title"] as? String ?? ""
        self.className = (snapshot.value as? NSDictionary)?["className"] as? String ?? ""
        self.dueDate = (snapshot.value as? NSDictionary)?["dueDate"] as? String ?? ""
        self.key = snapshot.key
        self.ref = snapshot.ref
        
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["title": title as AnyObject, "className": className as AnyObject,"dueDate": dueDate as AnyObject]
    }





}
