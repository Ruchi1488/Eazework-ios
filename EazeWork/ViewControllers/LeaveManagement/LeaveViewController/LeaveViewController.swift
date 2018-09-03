//
//  LeaveViewController.swift
//  EazeWork
//
//  Created by User1 on 5/4/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
class LeaveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var viewForLeaveBalanceView: UIView!
    
    @IBOutlet weak var lblForLeaveCount: UILabel!
    @IBOutlet weak var lblForLeaveBalnce: UILabel!
    @IBOutlet weak var lblForLeaveDescript: UILabel!
    @IBOutlet weak var lblForTitle: UILabel!
    
    @IBOutlet weak var lblForNoLeavesPending: UILabel!
    @IBOutlet weak var lblForNoLeavesApproved: UILabel!
   
    @IBOutlet weak var lblForPendingApprovalTitle: UILabel!
    @IBOutlet weak var lblForApprovedLeaveTitle: UILabel!
    
    @IBOutlet weak var pendingLeaveTableView: UITableView!
    @IBOutlet weak var approvedLeaveTableView: UITableView!
    @IBOutlet weak var textVwForLeaveDescript: UITextView!
    
    
    @IBOutlet weak var textVwForLeaveDescriptHeight: NSLayoutConstraint!
    @IBOutlet weak var viewForLeaveBalanceHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pendingLeaveTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var approvedLeaveTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var menuButton: JTHamburgerButton!
    
    var arrayForApprovedLeaves = NSArray()
    var arrayForPendingLeaves = NSArray()
    var fromDate = String()
    var toDate = String()
    // MARK: ViewDid Load
    override func viewDidLoad() {
        super.viewDidLoad()
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        viewForLeaveBalanceView.backgroundColor = SharedManager.shareData().headerBGColor
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        self.setTextColor()
        self.getLeaveBalancesData()
        
        //        pendingLeaveTableViewHeight.constant = 0
        //        approvedLeaveTableViewHeight.constant = 0
        
        approvedLeaveTableView.delegate = self
        approvedLeaveTableView.dataSource = self
        
        pendingLeaveTableView.delegate = self
        pendingLeaveTableView.dataSource = self
        
        lblForNoLeavesPending.isHidden = true
        lblForNoLeavesApproved.isHidden = true
        
        lblForPendingApprovalTitle.textColor = SharedManager.shareData().headerBGColor 
        lblForApprovedLeaveTitle.textColor = BUTTON_GREEN_BG_COLOR
        
        self.getLeaveRequests()
        self.getLeaveRequestsPending()
    }
    
    
    func setTextColor() {
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        lblForLeaveCount.textColor = SharedManager.shareData().headerTextColor
        lblForLeaveBalnce.textColor = SharedManager.shareData().headerTextColor
        lblForLeaveDescript.textColor = SharedManager.shareData().headerTextColor
        textVwForLeaveDescript.textColor = SharedManager.shareData().headerTextColor
    }
    
    
    func setTotalLeaveBalances(arrayData: NSArray) {
        var leaveCount: Float = 0.00
        var leaveTypes: String = ""
        for i in (0..<arrayData.count){
            let dictLeave: NSDictionary = (arrayData[i] as? NSDictionary)!
            leaveCount = leaveCount + Float((dictLeave.value(forKey: "Balance") as? String)!)!
            
            leaveTypes = leaveTypes + String(format: "%@:%@ ", (dictLeave.value(forKey: "LeaveShortCode") as? String)!,(dictLeave.value(forKey: "Balance") as? String)!)
        }
        let totalLeaves = String(format: "%.2f", leaveCount)
        lblForLeaveCount.text = totalLeaves as String
        lblForLeaveDescript.text = ""
        textVwForLeaveDescript.text = leaveTypes as String
        
        self.setLeaveBalanceViewSize()
    }
    
    func setLeaveBalanceViewSize()  {
        viewForLeaveBalanceHeight.constant = viewForLeaveBalanceHeight.constant - textVwForLeaveDescriptHeight.constant
        contentViewHeight.constant = contentViewHeight.constant - viewForLeaveBalanceHeight.constant
        let contentSize = textVwForLeaveDescript.sizeThatFits(textVwForLeaveDescript.bounds.size)
        textVwForLeaveDescriptHeight.constant = contentSize.height
        viewForLeaveBalanceHeight.constant = viewForLeaveBalanceHeight.constant + textVwForLeaveDescriptHeight.constant
        contentViewHeight.constant = contentViewHeight.constant + viewForLeaveBalanceHeight.constant
    }
    
    func getLeaveBalancesData(){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_LEAVE_BALANCES
        
        let constant = Constants()
        let parameters = constant.getLeaveBalanceJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getEmployeeDetailsResult = json["GetEmpLeaveBalancesResult"] as? [String: Any]
                let errorCode: Int = (getEmployeeDetailsResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getEmployeeDetailsResult?["leavesBalanceList"] as? NSArray)!
                    SharedManager.shareData().arrayForLeaveBalancesData = resultData as NSArray? as! [Any]!
                    self.setTotalLeaveBalances(arrayData: SharedManager.shareData().arrayForLeaveBalancesData as NSArray)
                }else{
                    
                }
            }
        }
    }

    
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        
        if tableView == approvedLeaveTableView {
            count = arrayForApprovedLeaves.count
            if count == 0 {
                approvedLeaveTableViewHeight.constant = 50
                approvedLeaveTableView.layer.borderWidth = 0.5
                approvedLeaveTableView.layer.borderColor = UIColor.lightGray.cgColor
                lblForNoLeavesApproved.isHidden = false
            }else{
                approvedLeaveTableView.layer.borderColor = UIColor.clear.cgColor
                lblForNoLeavesApproved.isHidden = true
            }
        }else if tableView == pendingLeaveTableView{
            count = arrayForPendingLeaves.count
            if count == 0 {
                pendingLeaveTableViewHeight.constant = 50
                pendingLeaveTableView.layer.borderWidth = 0.5
                pendingLeaveTableView.layer.borderColor = UIColor.lightGray.cgColor
                lblForNoLeavesPending.isHidden = false
            }else{
                pendingLeaveTableView.layer.borderColor = UIColor.clear.cgColor
                lblForNoLeavesPending.isHidden = true
            }
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == pendingLeaveTableView{
            let cell:PendingLeaveCustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PendingLeaveCustomCell!
            
            if (indexPath.row == 0){
                pendingLeaveTableViewHeight.constant = pendingLeaveTableView.contentSize.height
                contentViewHeight.constant = 280 + approvedLeaveTableViewHeight.constant + pendingLeaveTableViewHeight.constant
                self.setLeaveBalanceViewSize()
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            
            let dictLeave: NSDictionary = (arrayForPendingLeaves[indexPath.row] as? NSDictionary)!
            cell.lblForLeaveType.text = (dictLeave.value(forKey: "LeaveName") as? String)!
            cell.lblForDayCount.text = String(format: "Total Day : %@",(dictLeave.value(forKey: "TotalDays") as? String)!)
            cell.lblForLeaveRequestID.text = String(format: "Req ID : %@",(dictLeave.value(forKey: "ReqCode") as? String)!)
            cell.lblForLeaveDate.text =  String(format: "From: %@ To: %@",(dictLeave.value(forKey: "StartDate") as? String)!,(dictLeave.value(forKey: "EndDate") as? String)!)
            cell.lblForRemarks.text = String(format: "Remarks : %@",(dictLeave.value(forKey: "Remarks") as? String)!)
            
            let withDraw: String = String(format: "%@",(dictLeave.value(forKey: "WithdrawYN") as? String)!)
            cell.btnForWithdraw.tag = indexPath.row
            //cell.btnForWithdraw.backgroundColor = shared
            cell.btnForWithdraw.isHidden = true
            if withDraw == "Y"{
                cell.btnForWithdraw.isHidden = false
            }
            
            
            
            return cell
        }
        
        
        let cell:ApprovedLeaveCustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ApprovedLeaveCustomCell!
        
        if (indexPath.row == 0){
            approvedLeaveTableViewHeight.constant = approvedLeaveTableView.contentSize.height
            contentViewHeight.constant = 280 + approvedLeaveTableViewHeight.constant + pendingLeaveTableViewHeight.constant
            self.setLeaveBalanceViewSize()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let dictLeave: NSDictionary = (arrayForApprovedLeaves[indexPath.row] as? NSDictionary)!
        cell.lblForLeaveType.text = (dictLeave.value(forKey: "LeaveName") as? String)!
        cell.lblForDayCount.text = String(format: "Total Day : %@",(dictLeave.value(forKey: "TotalDays") as? String)!)
        cell.lblForLeaveRequestID.text = String(format: "Req ID : %@",(dictLeave.value(forKey: "ReqCode") as? String)!)
        cell.lblForLeaveDate.text =  String(format: "From: %@ To: %@",(dictLeave.value(forKey: "StartDate") as? String)!,(dictLeave.value(forKey: "EndDate") as? String)!)
        cell.lblForRemarks.text = String(format: "Remarks : %@",(dictLeave.value(forKey: "Remarks") as? String)!)
        let withDraw: String = String(format: "%@",(dictLeave.value(forKey: "WithdrawYN") as? String)!)
        cell.btnForWithdraw.isHidden = true
        if withDraw == "Y"{
            cell.btnForWithdraw.isHidden = false
        }
        cell.btnForWithdraw.tag = indexPath.row
        return cell
    }
    
    
    //MARK: - Get Leave Requests
    
    
    func getFromToDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let nextMonth = Calendar.current.date(byAdding: .month, value: 6, to: Date())
        let previousMonth = Calendar.current.date(byAdding: .month, value: -6, to: Date())
        fromDate = formatter.string(from: previousMonth!)
        toDate = formatter.string(from: nextMonth!)
    }
    
    func getLeaveRequests(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_LEAVE_REQUESTS
        
        self.getFromToDate()
                
        let constant = Constants()
        let parameters = constant.getLeaveRequestsJsonData(toDate: toDate, fromDate: fromDate, flag: "A")
        
        NSLog("Approved : %@", parameters)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                
                let getEmployeeDetailsResult = json["GetEmpLeaveRequestsResult"] as? [String: Any]
                let errorCode: Int = (getEmployeeDetailsResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    let resultData: NSArray = (getEmployeeDetailsResult?["leaveReqs"] as? NSArray)!
                    self.arrayForApprovedLeaves = resultData as NSArray
                    self.approvedLeaveTableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    func getLeaveRequestsPending(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_LEAVE_REQUESTS
        
        self.getFromToDate()
        
        let constant = Constants()
        let parameters = constant.getLeaveRequestsJsonData(toDate: toDate, fromDate: fromDate, flag: "P")
        
        NSLog("Pending : %@", parameters)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                
                let getEmployeeDetailsResult = json["GetEmpLeaveRequestsResult"] as? [String: Any]
                let errorCode: Int = (getEmployeeDetailsResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    let resultData: NSArray = (getEmployeeDetailsResult?["leaveReqs"] as? NSArray)!
                    self.arrayForPendingLeaves = resultData as NSArray
                    self.pendingLeaveTableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    // MARK: -
    
    @IBAction func onClickBackButton(_ sender: JTHamburgerButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickPlusButton(_ sender: UIButton) {
        SharedManager.shareData().popupFor="Empty"
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)

    }
    
    @IBAction func onClickPendingWithdraw(_ sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: "Confirmation", message:"Are you sure you want to withdraw this request ?" , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            let dictLeave: NSDictionary = (self.arrayForPendingLeaves[sender.tag] as? NSDictionary)!
            self.leaveUpdate(action:  "W"
                , status:  (dictLeave.value(forKey: "Status") as? String)!
                , requestID:  (dictLeave.value(forKey: "ReqID") as? String)!
                , approvalLevel:  (dictLeave.value(forKey: "ApprovalLevel") as? String)!,
                  pendingORApproved:"Pending"
            )
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func onClickApproveWithdraw(_ sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: "Confirmation", message:"Are you sure you want to withdraw this request ?" , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            let dictLeave: NSDictionary = (self.arrayForApprovedLeaves[sender.tag] as? NSDictionary)!
            self.leaveUpdate(action:  "W"
                , status:  (dictLeave.value(forKey: "Status") as? String)!
                , requestID:  (dictLeave.value(forKey: "ReqID") as? String)!
                , approvalLevel:  (dictLeave.value(forKey: "ApprovalLevel") as? String)!,
                  pendingORApproved:"Approved"
            )
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    func leaveUpdate(action: String, status: String, requestID: String, approvalLevel: String, pendingORApproved: String)  {
        
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
                
                                let getEmployeeDetailsResult = json["UpdateEmpPendingReqResult"] as? [String: Any]
                                let errorCode: Int = (getEmployeeDetailsResult?["ErrorCode"] as? Int)!
                
                                if errorCode == 0{
                                    
                                    if pendingORApproved == "Approved"{
                                        self.getLeaveRequests()
                                    }else if pendingORApproved == "Pending"{
                                        self.getLeaveRequestsPending()
                                    }
                                    self.getLeaveBalancesData()
                                    //self.showAlertView(title: "", message: "Leave withdrawn successfully !")
                                }else{
                                    let errorMessage: String = (getEmployeeDetailsResult?["ErrorMessage"] as? String)!
                                   self.showAlertView(title: "", message: errorMessage)
                                }
            }
        }
    }
    
    func showAlertView(title: String, message: String) {
        let refreshAlert = UIAlertController(title: "", message:message , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        }))
        self.present(refreshAlert, animated: true, completion: nil)
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
