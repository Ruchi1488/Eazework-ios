//
//  PendingLeaveCustomCell.swift
//  EazeWork
//
//  Created by User1 on 5/5/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class PendingLeaveCustomCell: UITableViewCell {

    @IBOutlet weak var contentBackView: UIView!
    @IBOutlet weak var lblForLeaveType: UILabel!
    @IBOutlet weak var lblForLeaveRequestID: UILabel!
    @IBOutlet weak var lblForLeaveDate: UILabel!
    @IBOutlet weak var lblForDayCount: UILabel!
    @IBOutlet weak var btnForWithdraw: UIButton!
    @IBOutlet weak var lblForRemarks: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentBackView.layer.borderColor = UIColor.lightGray.cgColor
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            contentBackView.layer.borderWidth = 2.0
        }else{
            contentBackView.layer.borderWidth = 0.5
        }
        

        btnForWithdraw.layer.cornerRadius = 5
        
       btnForWithdraw.backgroundColor = BUTTON_RED_BG_COLOR
        lblForLeaveType.textColor = BUTTON_RED_BG_COLOR
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
