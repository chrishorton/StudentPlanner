//
//  ClassTableViewCell.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 2/24/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var className: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
