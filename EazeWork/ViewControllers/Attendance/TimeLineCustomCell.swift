//
//  TimeLineCustomCell.swift
//  EazeWork
//
//  Created by User1 on 5/16/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class TimeLineCustomCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var topVerticalLine: UIImageView!
    @IBOutlet weak var bottomVerticalLine: UIImageView!
    @IBOutlet weak var separatorLine: UIImageView!
    @IBOutlet weak var statusIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
