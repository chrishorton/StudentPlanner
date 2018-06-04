//
//  SettingsTableViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/8/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit
import FirebaseAuth


class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LogOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
            present(vc, animated: true, completion: nil)
        } catch let error as NSError {
                print(error.localizedDescription)
            }
    }

}
