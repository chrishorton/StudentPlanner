//
//  NetworkingService.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 12/30/17.
//  Copyright © 2017 Christopher Horton. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SystemConfiguration

struct NetworkingService {
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference()
    }
    
    func saveUserInfo(user: User!, username:String, password:String,school:String) {
        let userInfo = ["email": user.email, "username":username, "password":password,"school": school, "uid": user.uid, ]
     
        let userRef = databaseRef.child("users").child(user.uid)
        
        userRef.setValue(userInfo)
        
        signIn(email: user.email!,password: password)
        print(Auth.auth().currentUser?.displayName!)
        
    }
    
    func signIn(email: String,password:String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil{
                if let user = user {
                    print("\(user.uid) has signed in successfully")
                    
                    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDel.logUser()
                    let loginvc = LoginViewController()
                    loginvc.didFinishLoading()
                    print("Finished loading new vc")
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        })
    }

    func setUserInfo(user: User!, username: String, password: String, school: String, data: NSData!){
        
        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        
        // Create image Reference
        
        let imageRef = storageRef.child(imagePath)
        
        // Create Metadata for the image
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        imageRef.putData(data as Data, metadata: metaData) { (metaData, error) in
            if error == nil {
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.photoURL = metaData!.downloadURL()
                changeRequest.commitChanges(completion: { (error) in
                    
                    if error == nil {
                        
                        self.saveUserInfo(user: user, username: username, password: password, school: school)
                        
                    }else{
                        print(error!.localizedDescription)
                        
                    }
                })
                
                
            }else {
                print(error!.localizedDescription)

            }
        }
        
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil{
                print("An email has been sent. Thank you!")
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func signUp(email: String, username: String, password: String, school: String, data: NSData!){
        
        print("creating user")
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                
                let schoolRef = globalRef.child("Schools")
                schoolRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.hasChild(school) {
                        // Add the student into the school
                        self.setUserInfo(user: user, username: username, password: password, school: school, data: data)
                        print("Snapshot Children: \(snapshot.children)")
                    } else{
                        // No school exists, create a new one and add student to it
                        schoolRef.child(school).childByAutoId().setValue(school)
                        
                        print("Snapshot Children 2 : \(snapshot.children)")
                        self.setUserInfo(user: user, username: username, password: password, school: school, data: data)
                    }
                })
            
            } else {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: "Error signing up", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    //                    alert.dismiss(animated: true, completion: nil)
                }))
            }
        }
    }
    
    
    func isconnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    
    
    func addAssignment(title: String, description: String, class:String){
        
    }
    
}
