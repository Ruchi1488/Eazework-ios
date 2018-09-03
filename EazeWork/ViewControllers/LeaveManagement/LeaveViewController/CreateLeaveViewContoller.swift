//
//  CreateLeaveViewContoller.swift
//  EazeWork
//
//  Created by User1 on 5/8/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
import DLRadioButton
class CreateLeaveViewContoller: UIViewController,EmployeeSelectorDelegate,UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var serchBtn: UIButton!
    @IBOutlet weak var requestForLbl: UILabel!
    
    @IBOutlet weak var employeeNameLbl: UITextField!
    
    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var viewForRHLeaveSelectDate: UIView!
    @IBOutlet weak var viewForFromDate: UIView!
    @IBOutlet weak var viewForToDate:UIView!
    @IBOutlet weak var bgViewForConsumedAvailableLeaves : UIView!
    @IBOutlet weak var txtViewForRemarks: UITextView!
    
    @IBOutlet weak var buttonForLeaveType: UIButton!
    @IBOutlet weak var buttonForRHLeaveSelectDate: UIButton!
    
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var lblForFromDate:UILabel!
    @IBOutlet weak var lblForToData:UILabel!
    @IBOutlet weak var lblFromDateTitle: UILabel!
    @IBOutlet weak var lblToDateTitle: UILabel!
    @IBOutlet weak var lblConsumedLeave: UILabel!
    @IBOutlet weak var lblAvailableLeave: UILabel!
    @IBOutlet weak var lblForRemarks: UILabel!
    @IBOutlet weak var lblNoRestrictedLeaves: UILabel!
    
    @IBOutlet weak var lblConsumedLeaveTitle: UILabel!
    @IBOutlet weak var lblAvailableLeaveTitle: UILabel!
    @IBOutlet weak var bgImgViewForConsumedLeave: UIImageView!
    @IBOutlet weak var bgImgViewForAvailableLeave: UIImageView!
    
    @IBOutlet weak var radioButton: DLRadioButton!
    @IBOutlet weak var radioButtonHalfDay: DLRadioButton!
    @IBOutlet weak var radioButton025Day: DLRadioButton!
    @IBOutlet weak var radioButton075Day: DLRadioButton!
    
    @IBOutlet weak var btnForSave: UIButton!
    
    @IBOutlet weak var heightConstrintForViewConsumeAvailableView: NSLayoutConstraint!
    var leaveTypeData = NSDictionary()
    var isFromOrToDate = Bool()
    var leaveStartDate = String()
    var leaveEndDate = String()
    var totalDays = NSString()
  
    
   
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentInset.top = 0
        self.view.translatesAutoresizingMaskIntoConstraints = true
        lblNoRestrictedLeaves.isHidden = true
        viewForRHLeaveSelectDate.isHidden = true
        
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        txtViewForRemarks.layer.borderWidth = 0.5
        txtViewForRemarks.layer.borderColor = UIColor.lightGray.cgColor
        txtViewForRemarks.tintColor = SharedManager.shareData().headerBGColor 
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        
        viewForFromDate.layer.cornerRadius = 5
        viewForToDate.layer.cornerRadius = 5
        
        lblAvailableLeave.text = "--"
        lblConsumedLeave.text = "--"
        
        radioButton.isMultipleSelectionEnabled = false
        self.radioButtonsHidden()
        
        
        let size = UIScreen.main.bounds.size
        if size.height <= 568 {
            //widthConstraintOfFromDateCalIcon.constant = 45
          //  widthConstraintOfToDateCalIcon.constant = 45
        }
        
        
        self.bgViewForConsumedAvailableLeaves.isHidden = true
        self.heightConstrintForViewConsumeAvailableView.constant = 0
        
        getEmpCropDetails()
        
        
         NotificationCenter.default.addObserver(self,
         selector: #selector(notificationCallback(_:)),
         name: NSNotification.Name(rawValue: "LeaveSelected"),
         object: nil)
         
         NotificationCenter.default.addObserver(self,
         selector: #selector(notificationCallback(_:)),
         name: NSNotification.Name(rawValue: "RHLeaveTypeSelected"),
         object: nil)
         NotificationCenter.default.addObserver(self,
         selector: #selector(notificationCallback(_:)),
         name: NSNotification.Name(rawValue: "DateSelected"),
         object: nil)
        
        let Name:String  = (SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "Name") as! String
        
        self.employeeNameLbl.text = Name
        
        self.employeeNameLbl.isHidden = false
        self.serchBtn.isHidden = true
        self.requestForLbl.isHidden = false
        
        self.employeeNameLbl.isEnabled = false
        self.employeeNameLbl.isUserInteractionEnabled = false

    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.contentViewHeight.constant)
    
    }
    
    func getEmpCropDetails()  {
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.GetCorpEmpParam
        let constant = Constants()
        
        
        Alamofire.request(urlPath, method: .post, parameters: constant.getCorpEmpParam(), encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                if let resultData: NSDictionary = json["GetCorpEmpParamResult"] as? NSDictionary {
                    if let paramList = resultData["CorpEmpParamList"] as? NSArray {
                        if let dict = paramList.firstObject as? NSDictionary {
                            if dict["Value"] as? String == "Y" {
                                //Hit Api
                                //LeaveService.svc/GetLeaveEmpList
                                print(dict["Value"] ?? nil)
                                self.employeeNameLbl.isHidden = false
                                self.serchBtn.isHidden = false
                                self.requestForLbl.isHidden = false
                                
                            } else {
                             
                            }
                        }
                    }
                    
                }
                
                
            }
        }
    }
    
    
    
    @objc func notificationCallback(_ notification: NSNotification){
        
        if notification.name.rawValue == "RHLeaveTypeSelected" {
            
            let userInfo = notification.userInfo as NSDictionary? as! [String:Any]?
            buttonForRHLeaveSelectDate.setTitle((userInfo! as NSDictionary).value(forKey: "RHLeaveType") as! String?, for: UIControlState.normal)
            
        }else if notification.name.rawValue == "LeaveSelected" {
            let userInfo = notification.userInfo as NSDictionary? as! [String:Any]?
            leaveTypeData = (userInfo! as NSDictionary)
            buttonForLeaveType.setTitle(leaveTypeData.value(forKey: "LeaveName") as! String?, for: UIControlState.normal)
            if(leaveTypeData.value(forKey: "LeaveID") as! String? == "E008001000") && (leaveTypeData.value(forKey: "ProcessStep") as! String? == "1"){
        heightConstrintForViewConsumeAvailableView.constant = 40
                self.showAvailableLeaveCount(isShow: true)
            }else{
              heightConstrintForViewConsumeAvailableView.constant = 84
                self.showAvailableLeaveCount(isShow: false)
            }
            
            NSLog("%@", leaveTypeData)
            self.getLeaveTypeBalance()
            
            if  leaveTypeData.value(forKey: "ProcessStep") as! String == "1" {
                lblFromDateTitle.text = "Date Worked"
                lblToDateTitle.text = "Compensatory Off Date"
                //lblFromDateTitle.textAlignment = NSTextAlignment.left
                //lblToDateTitle.textAlignment = NSTextAlignment.right
            }else{
                lblFromDateTitle.text = "From Date"
                lblToDateTitle.text = "To Date"
            }
            
            if leaveTypeData.value(forKey: "LeaveType") as! String == "R" {
                self.getLeaveTypeRHLeaves()
            }else{
                viewForFromDate.isHidden = false
                viewForToDate.isHidden = false
                lblForRemarks.isHidden = false
                txtViewForRemarks.isHidden = false
                lblFromDateTitle.isHidden = false
                lblToDateTitle.isHidden = false
                lblNoRestrictedLeaves.isHidden = true
                viewForRHLeaveSelectDate.isHidden = true
                //self.heightConstraintForViewFromDate.constant = 74
                
                if leaveStartDate.characters.count > 0 && leaveEndDate.characters.count > 0 && leaveTypeData.count > 0{
                    
                    self.getLeaveRequestTotalDays()
                }
            }
        }else if notification.name.rawValue == "DateSelected"{
            
            let userInfo = notification.userInfo as NSDictionary? as! [String:Any]?
            NSLog("%@", (userInfo! as NSDictionary))
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let fromDate = formatter.string(from: (userInfo! as NSDictionary).value(forKey: "date") as! Date)
            
            let weekday = Calendar.current.component(.weekday, from: (userInfo! as NSDictionary).value(forKey: "date") as! Date)
            var dayName: String = ""
            
            switch weekday {
            case 1:
                dayName = "Sunday"
            case 2:
                dayName = "Monday"
            case 3:
                dayName = "Tuesday"
            case 4:
                dayName = "Wednesday"
            case 5:
                dayName = "Thursday"
            case 6:
                dayName = "Friday"
            case 7:
                dayName = "Saturday"
            default:
                print("Error fetching days")
                dayName = "Day"
            }
            
            if isFromOrToDate == true{
                lblForFromDate.text = String(format: "%@\n%@",dayName,fromDate)
                leaveStartDate = fromDate
            }else{
                lblForToData.text = String(format: "%@\n%@",dayName,fromDate)
                leaveEndDate = fromDate
            }
            
            if leaveStartDate.characters.count > 0 && leaveEndDate.characters.count > 0 && leaveTypeData.count > 0{
                self.getLeaveRequestTotalDays()
            }
        }
    }
    
    
    func showAvailableLeaveCount(isShow: Bool){
        lblAvailableLeaveTitle.isHidden = isShow
        bgImgViewForAvailableLeave.isHidden = isShow
        lblAvailableLeave.isHidden = isShow
    }
    
    func radioButtonsHidden(){
        
        radioButton.sendActions(for: .touchUpInside)
        radioButton.isHidden = true
        radioButtonHalfDay.isHidden = true
        radioButton025Day.isHidden = true
        radioButton075Day.isHidden = true
    }
    
    
    @IBAction func onClickFromDate(_ sender: UIButton) {
        isFromOrToDate = true
        self.showCalendar()
    }
    
    @IBAction func onClickToDate(_ sender: UIButton) {
        isFromOrToDate = false
        self.showCalendar()
    }
    
    func showCalendar(){
        SharedManager.shareData().calendarForLeave = 1
        let addStatusViewController: CalendarViewController? = storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarViewController?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 30), height: 312))
        present(popupViewController!, animated: false, completion: nil)
    }
    
    
    @IBAction func onClickCancelButton(_ sender: UIButton) {
        SharedManager.shareData().isOnBehalfLeaveApplied = false
        self.showLeaveView()

    }
    
    func showLeaveView()   {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "LeaveVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    @IBAction func onClickLeaveType(_ sender: UIButton) {
        self.radioButtonsHidden()
        SharedManager.shareData().popupFor = "LeaveType"
        
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 500))
        present(popupViewController!, animated: false, completion: nil)
    }
    
    // MARK: -
    
    func getLeaveTypeBalance(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_LEAVE_TYPE_BALANCE
        
        let constant = Constants()
        let parameters = constant.getLeaveTypeBalanceJsonData(leaveID:leaveTypeData.value(forKey: "LeaveID") as Any)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                let getEmpLeavesResult = json["GetEmpLeaveBalanceResult"] as? [String: Any]
                let errorCode: Int = (getEmpLeavesResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let  leaveTypeBalance = (getEmpLeavesResult! as NSDictionary)
                    self.lblAvailableLeave.text = leaveTypeBalance.value(forKey: "Available") as! String?
                    self.lblConsumedLeave.text = leaveTypeBalance.value(forKey: "Consumed") as! String?
                    self.bgViewForConsumedAvailableLeaves.isHidden = false
                self.heightConstrintForViewConsumeAvailableView.constant = 84
                    self.contentViewHeight.constant = self.heightConstrintForViewConsumeAvailableView.constant + self.contentViewHeight.constant
                    self.scrollView.contentSize.height = self.contentViewHeight.constant
                    if(self.leaveTypeData.value(forKey: "LeaveID") as! String? == "E008001000") && (self.leaveTypeData.value(forKey: "ProcessStep") as! String? == "1"){
                    self.heightConstrintForViewConsumeAvailableView.constant = 40
                        self.showAvailableLeaveCount(isShow: true)
                    }else{
                        self.showAvailableLeaveCount(isShow: false)
                    }
                }else{
                    self.bgViewForConsumedAvailableLeaves.isHidden = true
                    self.heightConstrintForViewConsumeAvailableView.constant = 0
                }
            }else{
                self.bgViewForConsumedAvailableLeaves.isHidden = true
                self.heightConstrintForViewConsumeAvailableView.constant = 0
            }
        }
    }
    
    
    
    
    func getLeaveTypeRHLeaves(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_RH_LEAVES
        
        let constant = Constants()
        let parameters = constant.getLeaveTypeRHLeaves()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                
                let getEmpLeavesResult = json["GetEmpRHLeavesResult"] as? [String: Any]
                let errorCode: Int = (getEmpLeavesResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    let  leaveRHTypeBalance = (getEmpLeavesResult! as NSDictionary)
                    NSLog("Get LeaveTypeRHLeaves ==%@", leaveRHTypeBalance)
                    let resultData: NSArray = (leaveRHTypeBalance["RHLeaves"] as? NSArray)!
                    NSLog("%@", resultData)
                    
                    SharedManager.shareData().arrayForRHLeaves = resultData as? NSArray as! [Any]!
                    
                    if resultData.count <= 0 {
                        
                        self.viewForFromDate.isHidden = true
                        self.viewForToDate.isHidden = true
                        self.lblForRemarks.isHidden = true
                        self.txtViewForRemarks.isHidden = true
                        self.lblFromDateTitle.isHidden = true
                        self.lblToDateTitle.isHidden = true
                        self.lblNoRestrictedLeaves.isHidden = false
                        self.bgViewForConsumedAvailableLeaves.isHidden = true
                    }else{
                        self.bgViewForConsumedAvailableLeaves.isHidden = false
                        self.lblNoRestrictedLeaves.isHidden = true
                        self.viewForFromDate.isHidden = true
                        self.viewForToDate.isHidden = true
                        self.lblFromDateTitle.isHidden = true
                        self.lblToDateTitle.isHidden = true
                      //  self.heightConstraintForViewFromDate.constant = 1
                        self.viewForRHLeaveSelectDate.isHidden = false
                    }
                }else{
                    
                }
            }
        }
    }
    
    func getLeaveRequestTotalDays(){
        self.radioButtonsHidden()
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_LEAVE_REQUEST_TOTAL_DAYS
        
        let constant = Constants()
        let parameters = constant.getLeaveRequestTotalDays(leaveID: leaveTypeData.value(forKey: "LeaveID") as Any, leaveStartDate: leaveStartDate, leaveEndDate: leaveEndDate)
        
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                
                let getEmpLeavesResult = json["GetLeaveReqTotalDaysResult"] as? [String: Any]
                let errorCode: Int = (getEmpLeavesResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let  leaveCountData = (getEmpLeavesResult! as NSDictionary)
                    self.totalDays = leaveCountData.value(forKey: "TotalDays") as! NSString
                    if self.totalDays.doubleValue <= 1.00{
                        self.radioButton.isHidden = false
                        
                        if self.leaveTypeData.value(forKey: "DayP50") as! String == "Y"{
                            self.radioButtonHalfDay.isHidden = false
                        }
                        if self.leaveTypeData.value(forKey: "DayP75") as! String == "Y"{
                            self.radioButton075Day.isHidden = false
                        }
                        if self.leaveTypeData.value(forKey: "DayP25") as! String == "Y"{
                            self.radioButton025Day.isHidden = false
                            self.radioButton025Day.setTitle("0.25 Day", for: UIControlState.normal)
                        }
                        if self.leaveTypeData.value(forKey: "DayP25") as! String == "N" && self.leaveTypeData.value(forKey: "DayP75") as! String == "Y" {
                            self.radioButton025Day.isHidden = false
                            self.radioButton075Day.isHidden = true
                            self.radioButton025Day.setTitle("0.75 Day", for: UIControlState.normal)
                        }
                    }else{
                        
                    }
                }else{
                    
                }
            }
        }
    }
    
    func saveLeaveRequest(){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_SAVE_LEAVE_REQUEST
        
        let constant = Constants()
        let parameters = constant.getSaveLeaveRequestJsonData(leaveID: leaveTypeData.value(forKey: "LeaveID") as Any, leaveStartDate: leaveStartDate, leaveEndDate: leaveEndDate, totalDays: totalDays as String, remarks: txtViewForRemarks.text, reqID: "0")
        
        NSLog("Save Leave Request--%@",parameters)
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            self.btnForSave.isEnabled = true
            self.btnForSave.alpha = 1.0
            if let json = response.result.value as? [String: Any] {
                
                let saveLeaveReqResult = json["SaveLeaveReqResult"] as? [String: Any]
                let errorCode: Int = (saveLeaveReqResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let refreshAlert = UIAlertController(title: "", message:"Leave Submitted" , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                    
                    self.showLeaveView()
                }else{
                    let refreshAlert = UIAlertController(title: "", message:(saveLeaveReqResult?["ErrorMessage"] as? String)! , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: -
    
    @IBAction func onClickRHSelectDate(_ sender: UIButton) {
        
        SharedManager.shareData().popupFor = "RHLeaveType"
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
    }
    
    @IBAction func onClickRadioButton(_ sender: DLRadioButton) {
        print(String(format: "%@ is selected.\n", sender.selected()!.titleLabel!.text!));
        
        if sender.selected()!.titleLabel!.text!.contains("Full Day"){
            totalDays = "1.00"
        }else if sender.selected()!.titleLabel!.text!.contains("Half Day"){
            totalDays = "0.50"
        }else if sender.selected()!.titleLabel!.text!.contains("0.25 Day"){
            totalDays = "0.25"
        }else if sender.selected()!.titleLabel!.text!.contains("0.75 Day"){
            totalDays = "0.75"
        }
    }
    
    
    @IBAction func onClickLeaveSave(_ sender: UIButton) {
        if leaveStartDate.characters.count > 0 && leaveEndDate.characters.count > 0 && leaveTypeData.count > 0{
            self.btnForSave.isEnabled = false
            self.btnForSave.alpha = 0.5
            self.saveLeaveRequest()
        }else{
            
            var errorMessage: String = ""
            
            if leaveTypeData.count <= 0{
                errorMessage = "Please select Leave Type"
            }else if leaveStartDate.characters.count <= 0 {
                if  leaveTypeData.value(forKey: "ProcessStep") as! String == "1" {
                    errorMessage = "Date Worked"
                }else{
                    errorMessage = "Please select From Date"
                }
            }else if leaveEndDate.characters.count <= 0 {
                if  leaveTypeData.value(forKey: "ProcessStep") as! String == "1" {
                    errorMessage = "Compensatory Off Date"
                }else{
                    errorMessage = "Please select To Date"
                }
            }
            let refreshAlert = UIAlertController(title: "", message:errorMessage , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: -
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
    
    @IBAction func searchEmpList(_ sender: Any) {
        

        //CreateLeaveVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: SearchEmployeeListViewController? = storyboard.instantiateViewController(withIdentifier: "searchEmployeeListViewController") as? SearchEmployeeListViewController
        rootViewController?.empDelegate = self;
        self.present(rootViewController!, animated: true, completion: nil)
    }
    
    func didSelectEmployee(employee: EmpList)
    {
        self.employeeNameLbl.text = employee.Name
        SharedManager.shareData().isOnBehalfLeaveApplied = true
        SharedManager.shareData().onBehalfEmpID = employee.EmpID
        
        buttonForLeaveType.setTitle("Leave Type", for: UIControlState.normal)
        //--------- mohit
        
        self.viewDidLoad()
        self.txtViewForRemarks.text = ""
        self.lblForToData.text = "-/-/--"
        self.lblForFromDate.text = "-/-/--"
        
        leaveTypeData = NSDictionary()
       self.employeeNameLbl.text = employee.Name

        /*
 self.radioButtonsHidden()
        lblNoRestrictedLeaves.isHidden = true
        viewForRHLeaveSelectDate.isHidden = true
        self.bgViewForConsumedAvailableLeaves.isHidden = true

        scrollView.contentInset.top = 0
        self.view.translatesAutoresizingMaskIntoConstraints = true
        lblNoRestrictedLeaves.isHidden = true
        viewForRHLeaveSelectDate.isHidden = true
 */
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       //  scrollView.contentInset.top = 0
//        print("view top :   \(self.view.frame.origin.y)")
//        self.topscroolViewCotrant.constant = -20
//        print("self.topscroolViewCotrant.constant :   \(self.topscroolViewCotrant.constant)")
        
        
    }
}


public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    public var deviceIOSVersion: String {
        return UIDevice.current.systemVersion
    }
    
    public var deviceScreenWidth: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let width = screenSize.width;
        return width
    }
    public var deviceScreenHeight: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let height = screenSize.height;
        return height
    }
    
    
    
    
    public var deviceOrientationString: String {
        var orientation : String
        switch UIDevice.current.orientation{
        case .portrait:
            orientation="Portrait"
        case .portraitUpsideDown:
            orientation="Portrait Upside Down"
        case .landscapeLeft:
            orientation="Landscape Left"
        case .landscapeRight:
            orientation="Landscape Right"
        case .faceUp:
            orientation="Face Up"
        case .faceDown:
            orientation="Face Down"
        default:
            orientation="Unknown"
        }
        return orientation
    }
    
    //  Landscape Portrait
    public var isDevicePortrait: Bool {
        return UIDevice.current.orientation.isPortrait
    }
    public var isDeviceLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    var isIPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    var isIPad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType? {
        guard isIPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return nil
        }
    }
    
    // helper funcs
    static func isScreen35inch() -> Bool {
        return UIDevice().screenType == .iPhone4
    }
    
    func isScreen4inch() -> Bool {
        return UIDevice().screenType == .iPhone5
    }
    
    func isScreen47inch() -> Bool {
        return UIDevice().screenType == .iPhone6
    }
    
    func isScreen55inch() -> Bool {
        return UIDevice().screenType == .iPhone6Plus
    }
}


