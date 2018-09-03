//
//  EmployeeApprovalCustomCell.swift
//  EazeWork
//
//  Created by User1 on 5/25/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class EmployeeApprovalCustomCell: UITableViewCell {

    @IBOutlet weak var contentBackView: UIView!
    @IBOutlet weak var lblForEmpName: UILabel!
    @IBOutlet weak var lblForRequestedOn: UILabel!
    @IBOutlet weak var lblForRequestID: UILabel!
    @IBOutlet weak var lblForRequestBy: UILabel!

    @IBOutlet weak var btnForReject: UIButton!
    @IBOutlet weak var btnForApprove: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentBackView.layer.borderColor = UIColor.lightGray.cgColor
        contentBackView.layer.borderWidth = 0.5
        btnForReject.layer.cornerRadius = 5
        btnForApprove.layer.cornerRadius = 5
        
        btnForReject.backgroundColor = BUTTON_RED_BG_COLOR
        btnForApprove.backgroundColor = BUTTON_GREEN_BG_COLOR
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
