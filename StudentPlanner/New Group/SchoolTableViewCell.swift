//
//  SchoolTableViewCell.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 8/4/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
