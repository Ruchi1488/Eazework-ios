//
//  TeamListCustomCell.swift
//  EazeWork
//
//  Created by User1 on 5/22/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class TeamListCustomCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblDaysStatus: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imageVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblDaysStatus.textColor = BUTTON_RED_BG_COLOR
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
