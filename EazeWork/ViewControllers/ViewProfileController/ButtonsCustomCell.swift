//
//  ButtonsCustomCell.swift
//  EazeWork
//
//  Created by User1 on 5/11/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class ButtonsCustomCell: UICollectionViewCell {
    
    var nameLabel: UILabel!
    var profileImageButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = UIImage(named: "camera")! as UIImage
        profileImageButton = UIButton(frame: CGRect(x: frame.size.width/2 - 25, y: 0, width: 50, height: 50))
        profileImageButton.contentMode = UIViewContentMode.scaleAspectFit
        profileImageButton.setBackgroundImage(image, for: UIControlState.normal)
        contentView.addSubview(profileImageButton)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: profileImageButton.frame.size.height, width: frame.size.width, height: frame.size.height/3))
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
