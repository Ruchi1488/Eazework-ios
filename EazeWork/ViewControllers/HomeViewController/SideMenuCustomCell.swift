//
//  SideMenuCustomCell.swift
//  EazeWork
//
//  Created by User1 on 5/4/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class SideMenuCustomCell: UITableViewCell {

    @IBOutlet weak var imgVwForIcon: UIImageView!
    @IBOutlet weak var lblForText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
