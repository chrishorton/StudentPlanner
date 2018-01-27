//
//  AssignmentDetailViewController.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/24/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit

class AssignmentDetailViewController: UIViewController {

    var assignment: Assignment?
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var assignmentTitle: UILabel!
    @IBOutlet weak var assignmentDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignmentTitle.text = assignment?.title
        dueDate.text = assignment?.dueDate
        className.text = assignment?.className
        if !(assignment?.description == nil) {
            // If description has value, set it
            assignmentDescription.text = assignment?.description
        }
        
        // TODO: Add a posted by field (AUTHOR)
    }
}
