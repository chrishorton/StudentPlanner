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


class NetworkingService {
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference()
    }
    
    func saveUserInfo(user: User!, username:String, password:String,school:String) {
        let userInfo = ["email:": user.email, "username":username, "password":password,"school": school, "uid": user.uid, ]
     
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
                        print(Auth.auth().currentUser?.displayName!)
                        
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

    
    /**
     - Returns:
     Boolean true if school exists, false if not
     */
    func checkSchool(schoolName:String){
        // If school doesn't exist, add it to db
        let schoolRef = Database.database().reference().child("Schools")
        schoolRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(schoolName){
                print(snapshot.children)
                print("true rooms exist")
            }else{
                print(snapshot.children)
                print("false room doesn't exist")
                schoolRef.childByAutoId().setValue(["Name": schoolName as AnyObject])
            }
        })
    }
 
    func signUp(email: String, username: String, password: String, school: String, data: NSData!){
        checkSchool(schoolName: school)
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error == nil {
                
                self.setUserInfo(user: user, username: username, password: password, school: school, data: data)
                print("info set")
                
            }else {
                let alert = UIAlertController(title: "Error signing up", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
//                    alert.dismiss(animated: true, completion: nil)
                }))
            }
        })
        
        
    }
    
    func addAssignment(title: String, description: String, class:String){
        
    }
    
}
