//
//  JoinTableViewCell.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 4/23/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import UIKit

class JoinTableViewCell: UITableViewCell {

    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var instructorName: UILabel!
    @IBOutlet weak var periodOrTime: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var dayLabel: UILabel!
    
    weak var delegate: CellDelegate?

    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.didTap(self)
        print("tapped")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
