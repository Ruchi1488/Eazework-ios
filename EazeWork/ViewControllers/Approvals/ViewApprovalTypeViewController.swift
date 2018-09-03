//
//  ViewApprovalTypeViewController.swift
//  EazeWork
//
//  Created by User1 on 5/25/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView

class ViewApprovalTypeViewController: UIViewController {

    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var menuButton: JTHamburgerButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayForApprovals = NSArray()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
