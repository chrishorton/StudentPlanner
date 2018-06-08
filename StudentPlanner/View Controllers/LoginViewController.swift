//
//  LoginViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 12/30/17.
//  Copyright © 2017 Christopher Horton. All rights reserved.
//

import UIKit
import TKSubmitTransition
import FirebaseAuth

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let networkingService = NetworkingService()
    
    @IBOutlet var btn: TKTransitionSubmitButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(Auth.auth().currentUser == nil) {
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let helper = Helpers(btn: btn)
        helper.didStartYourLoading()
        networkingService.signIn(email: emailField.text!, password: passwordField.text!)
    }
    
    func didFinishLoading(){
        btn?.startFinishAnimation(0) {
            let secondVC = ListTableViewController()
            secondVC.transitioningDelegate = self
            self.present(secondVC, animated: true, completion: nil)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
