//
//  SearchEmpListTableViewCell.swift
//  EazeWork
//
//  Created by Mohit Sharma on 16/12/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class SearchEmpListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var empName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectBtn.layer.cornerRadius = 5.0
        self.addShadow(cardView: cardView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addShadow(cardView: UIView)  {
        cardView.layer.cornerRadius = 3.0
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize.zero
        cardView.layer.shadowRadius = 5
        cardView.clipsToBounds = false
        cardView.layer.masksToBounds = false
    }
    
    func populateData(name: String?)  {
        if let name = name {
        self.empName.text = name
        }
    }
}
