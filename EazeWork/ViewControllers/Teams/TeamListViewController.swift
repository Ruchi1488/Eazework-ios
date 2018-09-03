//
//  TeamListViewController.swift
//  EazeWork
//
//  Created by User1 on 5/22/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
import SDWebImage
class TeamListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var menuButton: JTHamburgerButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var countForTeam = Int()
    var arrayForTeamList = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        countForTeam = 1;
        
        if SharedManager.shareData().arrayForEmpID.count <= 1{
            lblForTitle.text = "Team Members"
        }else{
            lblForTitle.text = "Sub Team"
        }
        
        self.getTeamList(subLevel: String(countForTeam))
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForTeamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TeamListCustomCell = tableView.dequeueReusableCell(withIdentifier: "TeamListCustomCell") as! TeamListCustomCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = .disclosureIndicator
        cell.lblName.text =  (arrayForTeamList[indexPath.row] as! NSDictionary).value(forKey: "Name") as! String?
        cell.lblStatus.text = (arrayForTeamList[indexPath.row] as! NSDictionary).value(forKey: "DayStatus") as! String?
        cell.lblDesignation.text = (arrayForTeamList[indexPath.row] as! NSDictionary).value(forKey: "Designation") as! String?
        
        var logoURL: NSString = (arrayForTeamList[indexPath.row] as! NSDictionary).value(forKey: "EmpImageUrl") as! NSString
        
        if !(logoURL is NSNull){
            cell.imageVw.sd_setImage(with: URL(string: String(format:"%@%@",SharedManager.shareData().base_URL,logoURL)), placeholderImage: UIImage(named: "profile_image"))
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        SharedManager.shareData().popupFor = "TeamList"
        SharedManager.shareData().isSelfAttendanceHistory = 2
        
        SharedManager.shareData().employeeIDForAttendance = (arrayForTeamList[indexPath.row] as! NSDictionary).value(forKey: "EmpID") as! String?
        
        
        
        countForTeam = Int(((arrayForTeamList[indexPath.row] as! NSDictionary).value(forKey: "TeamCount") as! String?)!)!
        
        if countForTeam > 0 {
            SharedManager.shareData().validForTeamMembers = 1
        }else{
            SharedManager.shareData().validForTeamMembers = 0
        }
        
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
}
    
    func getTeamList(subLevel: String){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_TEAM_MEMBER_LIST
        let constant = Constants()
        
        var empID = ""
        
        if SharedManager.shareData().teamCount <= 1{
            empID = String(SharedManager.shareData().employeeID)
        }else{
            empID = String(SharedManager.shareData().employeeIDForAttendance)
        }
        
        empID = String(format: "%@",SharedManager.shareData().arrayForEmpID.lastObject as! CVarArg)
        
        let parameters = constant.getTeamCountJsonData(subLevel: subLevel, empID:empID)
        
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getTeamMemberListResult = json["GetTeamMemberListResult"] as? [String: Any]
                let errorCode: Int = (getTeamMemberListResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getTeamMemberListResult?["list"] as? NSArray)!
                    let arrayData: NSArray = (resultData as NSArray) as! [Any] as NSArray
                    self.arrayForTeamList = arrayData
                    self.tableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    @IBAction func onClickPlus(_ sender: UIButton) {
        
        SharedManager.shareData().popupFor = ""
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
    }
    
    @IBAction func onClickBackBtn(_ sender: JTHamburgerButton) {
        
        if SharedManager.shareData().arrayForEmpID.count <= 1{
            SharedManager.shareData().validForSelfViewProfile = 1
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
        }else{
            SharedManager.shareData().arrayForEmpID.removeLastObject()
            
            if SharedManager.shareData().arrayForEmpID.count <= 1{
                lblForTitle.text = "Team Members"
            }else{
                lblForTitle.text = "Sub Team"
            }

            self.getTeamList(subLevel: "1")
        }
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
