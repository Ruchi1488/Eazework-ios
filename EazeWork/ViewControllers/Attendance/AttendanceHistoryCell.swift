//
//  AttendanceHistoryCell.swift
//  EazeWork
//
//  Created by User1 on 5/16/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class AttendanceHistoryCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblInTime: UILabel!
    @IBOutlet weak var lblOutTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
