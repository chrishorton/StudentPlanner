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
    var description: String!
    var completed: Bool!

    var ref: DatabaseReference?
    var key: String!
    
    
    init(title: String, className: String, dueDate: String, description: String, key: String = "",completed: Bool){
        
        self.title = title
        self.className = className
        self.dueDate = dueDate
        self.completed = completed
        if description != "" {
            self.description = description
        }
        self.key = key
        self.ref = Database.database().reference()
    }
    
    
    init(snapshot: DataSnapshot, withDesc: Bool){
        if withDesc {
            print("With description")
            self.title = (snapshot.value as? NSDictionary)?["title"] as? String ?? ""
            self.className = (snapshot.value as? NSDictionary)?["className"] as? String ?? ""
            self.dueDate = (snapshot.value as? NSDictionary)?["dueDate"] as? String ?? ""
            self.description = (snapshot.value as? NSDictionary)?["description"] as? String ?? ""
            self.completed = (snapshot.value as? NSDictionary)?["completed"] as? Bool ?? false
            self.key = snapshot.key
            self.ref = snapshot.ref
        } else {
            print("Adding without desc")
            self.title = (snapshot.value as? NSDictionary)?["title"] as? String ?? ""
            self.className = (snapshot.value as? NSDictionary)?["className"] as? String ?? ""
            self.dueDate = (snapshot.value as? NSDictionary)?["dueDate"] as? String ?? ""
            self.completed = (snapshot.value as? NSDictionary)?["completed"] as? Bool ?? false
            self.key = snapshot.key
            self.ref = snapshot.ref
        }
    }

    
    func toAnyObject() -> [String: AnyObject] {
        return ["title": title as AnyObject, "className": className as AnyObject,"dueDate": dueDate as AnyObject, "completed": completed as AnyObject]
    }





}
