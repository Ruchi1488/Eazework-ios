//
//  StoreLocationCustomCell.swift
//  EazeWork
//
//  Created by User1 on 5/22/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class StoreLocationCustomCell: UITableViewCell {

    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblLocationCode: UILabel!
    @IBOutlet weak var lblEmployees: UILabel!
    @IBOutlet weak var lblEmployeeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblEmployees.textColor = BUTTON_RED_BG_COLOR
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
