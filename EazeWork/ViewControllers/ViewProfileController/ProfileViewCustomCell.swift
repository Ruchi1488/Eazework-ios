//
//  ProfileViewCustomCell.swift
//  EazeWork
//
//  Created by User1 on 6/15/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class ProfileViewCustomCell: UITableViewCell {

   
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var valueType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
