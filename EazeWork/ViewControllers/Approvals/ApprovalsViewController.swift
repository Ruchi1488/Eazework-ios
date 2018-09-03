//
//  ApprovalsViewController.swift
//  EazeWork
//
//  Created by User1 on 5/22/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
class ApprovalsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var menuButton: JTHamburgerButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayForApprovals = NSArray()
    var arrayLeaveApprovals = NSArray()
    var arrayEmployeeApprovals = NSArray()
    
    var countForApprovalType = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        countForApprovalType = 0
        
        self.getApprovalsData()
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight = 100.0
        if countForApprovalType == 0 {
            cellHeight = 100.0
        }else if countForApprovalType == 1{
            cellHeight = 158.0
        }else if countForApprovalType == 2{
            cellHeight = 140.0
        }
        return CGFloat(cellHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        
        if countForApprovalType == 0 {
            tableView.separatorStyle = .singleLine
            rowCount = arrayForApprovals.count
        }else if countForApprovalType == 1{
            tableView.separatorStyle = .none
            rowCount = arrayLeaveApprovals.count
        }else if countForApprovalType == 2{
            tableView.separatorStyle = .none
            rowCount = arrayEmployeeApprovals.count
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if countForApprovalType == 1{
            let cell:LeaveApprovalCustomCell = tableView.dequeueReusableCell(withIdentifier: "LeaveApprovalCell") as! LeaveApprovalCustomCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.lblForLeaveType.text = (arrayLeaveApprovals[indexPath.row] as! NSDictionary).value(forKey: "ReqTypeDesc") as! String?
            cell.lblForEmpName.text = String(format:"Employee Name : %@",((arrayLeaveApprovals[indexPath.row] as! NSDictionary).value(forKey: "ForEmpName") as! String?)!)
            cell.lblForDetails.text = String(format:"Details : %@",((arrayLeaveApprovals[indexPath.row] as! NSDictionary).value(forKey: "Details") as! String?)!)
            cell.lblForRemarks.text = String(format:"Remarks : %@",((arrayLeaveApprovals[indexPath.row] as! NSDictionary).value(forKey: "Remark") as! String?)!)
            
            cell.btnForApprove.tag = indexPath.row
            cell.btnForReject.tag = indexPath.row
            
            return cell
        }else if countForApprovalType == 2{
            let cell:EmployeeApprovalCustomCell = tableView.dequeueReusableCell(withIdentifier: "EmployeeApprovalCell") as! EmployeeApprovalCustomCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.lblForEmpName.text = String(format:"Employee Name : %@",((arrayEmployeeApprovals[indexPath.row] as! NSDictionary).value(forKey: "Name") as! String?)!)
            cell.lblForRequestedOn.text = String(format:"Requested On : %@",((arrayEmployeeApprovals[indexPath.row] as! NSDictionary).value(forKey: "ReqDate") as! String?)!)
            cell.lblForRequestID.text = String(format:"Requested ID : %@",((arrayEmployeeApprovals[indexPath.row] as! NSDictionary).value(forKey: "ReqCode") as! String?)!)
            cell.lblForRequestBy.text = String(format:"Requested By : %@",((arrayEmployeeApprovals[indexPath.row] as! NSDictionary).value(forKey: "Initiator") as! String?)!)
            
            cell.btnForApprove.tag = indexPath.row
            cell.btnForReject.tag = indexPath.row

            return cell
        }
        let cell:HomeViewCustomCell = tableView.dequeueReusableCell(withIdentifier: "ApprovalCell") as! HomeViewCustomCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.lblForTitle.text = (arrayForApprovals[indexPath.row] as! NSDictionary).value(forKey: "ReqDesc") as! String?
        cell.lblForCount.text =  (arrayForApprovals[indexPath.row] as! NSDictionary).value(forKey: "Count") as! String?
        cell.lblForActionTitle.text = "Pending"
        
        if (arrayForApprovals[indexPath.row] as! NSDictionary).value(forKey: "ReqDesc") as! String? == "Leave" {
            cell.imgVwForIcon.image = #imageLiteral(resourceName: "manager_approval")
            cell.lblForSubTitle.text = "Check Leaves"
        }else if (arrayForApprovals[indexPath.row] as! NSDictionary).value(forKey: "ReqDesc") as! String? == "Employee" {
            cell.imgVwForIcon.image = #imageLiteral(resourceName: "team_blue")
            cell.lblForSubTitle.text = "View Employee Approvals"
        }else{
            cell.imgVwForIcon.image = #imageLiteral(resourceName: "na")
            cell.lblForSubTitle.text = ""
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if countForApprovalType == 0 {
            if (arrayForApprovals[indexPath.row] as! NSDictionary).value(forKey: "ReqDesc") as! String? == "Leave" {
                if (arrayForApprovals[indexPath.row] as! NSDictionary).value(forKey: "Count") as! String? == "0"{
                    self.showAlertView(title: "", message: "There is no pending leave.")
                }else{
                    countForApprovalType = 1
                    lblForTitle.text = "Pending Leaves"
                    self.getLeaveApprovalsData()
                    tableView.reloadData()
                }
            }else if (arrayForApprovals[indexPath.row] as! NSDictionary).value(forKey: "ReqDesc") as! String? == "Employee" {
                
                if (arrayForApprovals[indexPath.row] as! NSDictionary).value(forKey: "Count") as! String? == "0"{
                    self.showAlertView(title: "", message: "There is no pending employee.")
                }else{
                    countForApprovalType = 2
                    lblForTitle.text = "Pending Employees"
                    self.getEmployeeApprovalsData()
                    tableView.reloadData()
                }
            }else{
                
            }
        }else if countForApprovalType == 1{
            
        }else if countForApprovalType == 2{
            
        }
    }
    
    //MARK: -
    
    
    func getApprovalsData(){
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_COMMON_SERVICE_PENDING_APPROVAL_COUNT
        let constant = Constants()
        let parameters = constant.getMenuJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getEmpPendingApprovalCountResult = json["GetEmpPendingApprovalCountResult"] as? [String: Any]
                let errorCode: Int = (getEmpPendingApprovalCountResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getEmpPendingApprovalCountResult?["list"] as? NSArray)!
                    NSLog("%@",resultData)
                    self.isValidForEmployeeApproval(arrayOfApprovalData: resultData)
                }else{
                    let errorMessage: String = (getEmpPendingApprovalCountResult?["ErrorMessage"] as? String)!
                   self.showAlertView(title: "", message: errorMessage)
                }
            }
        }
    }
    
    func isValidForEmployeeApproval(arrayOfApprovalData: NSArray){
        
        var tempArray = NSMutableArray()
        tempArray = arrayOfApprovalData.mutableCopy() as! NSMutableArray
        let savedArray: NSMutableArray = SharedManager.shareData().arrayForMenuDescript
        
        if !savedArray.contains(Constants.VALID_FOR_EMPLOYEE_APPROVAL){
            for i in (0..<arrayOfApprovalData.count){
                 let dictData = (arrayOfApprovalData[i] as! NSDictionary)
                if dictData.value(forKey: "ReqDesc") as! String == "Employee"{
                    tempArray.removeObject(at: i)
                }
            }
        }
        
        self.arrayForApprovals = tempArray
        self.tableView.reloadData()
    }
    
    
    func getLeaveApprovalsData(){
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_LEAVE_APPROVALS
        let constant = Constants()
        let parameters = constant.getMenuJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getEmpPendingApprovalCountResult = json["GetEmpPendingApprovalReqsResult"] as? [String: Any]
                let errorCode: Int = (getEmpPendingApprovalCountResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getEmpPendingApprovalCountResult?["reqTypeDetails"] as? NSArray)!
                    if(resultData.count > 0){
                        NSLog("%@",resultData)
                        self.arrayLeaveApprovals = resultData
                        self.tableView.reloadData()
                    }else{
                        self.lblForTitle.text = "Approvals"
                        self.countForApprovalType = 0
                        self.getApprovalsData()
                        self.tableView.reloadData()
                    }
                }else{
                    let errorMessage: String = (getEmpPendingApprovalCountResult?["ErrorMessage"] as? String)!
                    self.showAlertView(title: "", message: errorMessage)
                }
            }
        }
    }

    
    func getEmployeeApprovalsData(){
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_EMP_APPROVALS
        let constant = Constants()
        let parameters = constant.getLocationsJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getPendingMemberReqListResult = json["GetPendingMemberReqListResult"] as? [String: Any]
                let errorCode: Int = (getPendingMemberReqListResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getPendingMemberReqListResult?["list"] as? NSArray)!
                    if(resultData.count > 0){
                        NSLog("%@",resultData)
                        self.arrayEmployeeApprovals = resultData
                        self.tableView.reloadData()
                    }else{
                        self.lblForTitle.text = "Approvals"
                        self.countForApprovalType = 0
                        self.getApprovalsData()
                        self.tableView.reloadData()
                    }
                }else{
                    let errorMessage: String = (getPendingMemberReqListResult?["ErrorMessage"] as? String)!
                    self.showAlertView(title: "", message: errorMessage)
                }
            }
        }
    }

    
    
    @IBAction func onClickLeaveReject(_ sender: UIButton) {
        
        var approvalLevel = "-1"
        if !((arrayLeaveApprovals[sender.tag] as! NSDictionary).value(forKey: "ApprovalLevel") is NSNull) {
            approvalLevel = ((arrayLeaveApprovals[sender.tag] as! NSDictionary).value(forKey: "ApprovalLevel") as! String?)!
        }
        
        let refreshAlert = UIAlertController(title: "Confirmation", message:"Are you sure you want to reject this request  ?" , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            
            self.getUpdateLeaveApproval(requestID: ((self.arrayLeaveApprovals[sender.tag] as! NSDictionary).value(forKey: "ReqID") as! String?)!, status: ((self.arrayLeaveApprovals[sender.tag] as! NSDictionary).value(forKey: "Status") as! String?)!, approvalLevel: approvalLevel, action: "R")
            
        }))
        self.present(refreshAlert, animated: true, completion: nil)

        
        
    }
    
    
    @IBAction func onClickLeaveApprove(_ sender: UIButton) {
        var approvalLevel = "-1"
        if !((arrayLeaveApprovals[sender.tag] as! NSDictionary).value(forKey: "ApprovalLevel") is NSNull) {
            approvalLevel = ((arrayLeaveApprovals[sender.tag] as! NSDictionary).value(forKey: "ApprovalLevel") as! String?)!
        }
        
        let refreshAlert = UIAlertController(title: "Confirmation", message:"Are you sure you want to approve this request ?" , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            
            self.getUpdateLeaveApproval(requestID: ((self.arrayLeaveApprovals[sender.tag] as! NSDictionary).value(forKey: "ReqID") as! String?)!, status: ((self.arrayLeaveApprovals[sender.tag] as! NSDictionary).value(forKey: "Status") as! String?)!, approvalLevel: approvalLevel, action: "A")
            
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func onClickEmpReject(_ sender: UIButton) {
        var approvalLevel = "-1"
        if !((arrayEmployeeApprovals[sender.tag] as! NSDictionary).value(forKey: "ApprovalLevel") is NSNull) {
            approvalLevel = ((arrayEmployeeApprovals[sender.tag] as! NSDictionary).value(forKey: "ApprovalLevel") as! String?)!
        }
        
        let refreshAlert = UIAlertController(title: "Confirmation", message:"Are you sure you want to reject this request ?" , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            
            self.getUpdateEmpApproval(requestID: ((self.arrayEmployeeApprovals[sender.tag] as! NSDictionary).value(forKey: "ReqID") as! String?)!, status: ((self.arrayEmployeeApprovals[sender.tag] as! NSDictionary).value(forKey: "ReqStatus") as! String?)!, approvalLevel: approvalLevel, action: "R")
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func onClickEmpApprove(_ sender: UIButton) {
        var approvalLevel = "-1"
        if !((arrayEmployeeApprovals[sender.tag] as! NSDictionary).value(forKey: "ApprovalLevel") is NSNull) {
            approvalLevel = ((arrayEmployeeApprovals[sender.tag] as! NSDictionary).value(forKey: "ApprovalLevel") as! String?)!
        }

        let refreshAlert = UIAlertController(title: "Confirmation", message:"Are you sure you want to approve this request ?" , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            
            self.getUpdateEmpApproval(requestID: ((self.arrayEmployeeApprovals[sender.tag] as! NSDictionary).value(forKey: "ReqID") as! String?)!, status: ((self.arrayEmployeeApprovals[sender.tag] as! NSDictionary).value(forKey: "ReqStatus") as! String?)!, approvalLevel: approvalLevel, action: "A")
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    
    func getUpdateLeaveApproval(requestID: String, status: String, approvalLevel: String, action: String){
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_LEAVE_UPDATE
        let constant = Constants()
        let parameters = constant.getLeaveUpdateJsonData(requestID: requestID, status: status, approvalLevel: approvalLevel, action: action)
        NSLog("Pending : %@", parameters)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                print(json)
                let updateEmpPendingReqResult = json["UpdateEmpPendingReqResult"] as? [String: Any]
                let errorCode: Int = (updateEmpPendingReqResult?["ErrorCode"] as? Int)!
               
                if errorCode == 0{
                    self.countForApprovalType = 1
                    self.lblForTitle.text = "Pending Leaves"
                    self.getLeaveApprovalsData()
                    self.tableView.reloadData()
                }else{
                    let errorMessage: String = (updateEmpPendingReqResult?["ErrorMessage"] as? String)!
                    self.showAlertView(title: "", message: errorMessage)
                }
            }
        }
    }

    
    func getUpdateEmpApproval(requestID: String, status: String, approvalLevel: String, action: String){
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_EMP_UPDATE_APPROVE_REJECT
        
        let constant = Constants()
        let parameters = constant.getEmpApprovalUpdateJsonData(requestID: requestID, status: status, approvalLevel: approvalLevel, action: action)
        NSLog("Pending : %@", parameters)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let updateEmpPendingReqResult = json["UpdateMemberApprovalRejectionResult"] as? [String: Any]
                let errorCode: Int = (updateEmpPendingReqResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    self.countForApprovalType = 2
                    self.lblForTitle.text = "Pending Employees"
                    self.getEmployeeApprovalsData()
                    self.tableView.reloadData()
                    
                }else{
                    let errorMessage: String = (updateEmpPendingReqResult?["ErrorMessage"] as? String)!
                    self.showAlertView(title: "", message: errorMessage)
                }
            }
        }
    }

    
    
    func showAlertView(title: String, message: String) {
        // Inconsistent request status.
        let refreshAlert = UIAlertController(title: "", message:message , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if message.contains("Inconsistent request status"){
                if self.countForApprovalType == 1{
                    self.getLeaveApprovalsData()
                }else if self.countForApprovalType == 2{
                    self.getEmployeeApprovalsData()
                }
            }
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }

    
    
    
    
    @IBAction func onClickBack(_ sender: JTHamburgerButton) {
        
        if countForApprovalType == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
        }else if countForApprovalType == 1{
            countForApprovalType = 0
            self.getApprovalsData()
            tableView.reloadData()
        }else if countForApprovalType == 2{
            countForApprovalType = 0
            self.getApprovalsData()
            tableView.reloadData()
        }
        lblForTitle.text = "Approvals"
    }
    
    @IBAction func onClickPlus(_ sender: UIButton) {
        SharedManager.shareData().popupFor = ""
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
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
