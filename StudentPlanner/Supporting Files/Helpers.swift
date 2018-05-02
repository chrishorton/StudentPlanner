//
//  Helpers.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/8/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import Foundation
import TKSubmitTransition
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

struct Helpers {
    let btn: TKTransitionSubmitButton!
    
    func didStartYourLoading(){
        btn?.startLoadingAnimation()
    }
    

    func sendImageToStorage(image: UIImage, with assignmentID: String) {
        print("Sending image to Firebase Storage")
        var storageRef: StorageReference {
            return Storage.storage().reference()
        }
        
        let imagePath = "\(assignmentID)"
        
        // Create image Reference
        
        let imageRef = storageRef.child(imagePath)
        
        // Create Metadata for the image
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        print("Sent")
    }
    

}
