//
//  HomeViewController.swift
//  EazeWork
//
//  Created by User1 on 5/3/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import CoreLocation
import SWActivityIndicatorView

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var viewForTopView           : UIView!
    @IBOutlet weak var viewForProfileView       : UIView!
    @IBOutlet weak var viewForParentShare       : UIView!
    
    @IBOutlet weak var imgVwForTopViewPic       : UIImageView!
    @IBOutlet weak var imgVwForProfilePic       : UIImageView!
    
    @IBOutlet weak var lblForName               : UILabel!
   
    @IBOutlet weak var lblForEmployeeID         : UILabel!
    @IBOutlet weak var lblForTitle              : UILabel!
    
    @IBOutlet weak var sideMenuTableView        : UITableView!
    @IBOutlet weak var homeMenuTableView        : UITableView!
    
    @IBOutlet weak var sideMenuWidth            : NSLayoutConstraint!
    
    @IBOutlet weak var menuButton               : JTHamburgerButton!
    @IBOutlet weak var timeInOutButton          : UIButton!
    @IBOutlet weak var breakInOutButton         : UIButton!
    @IBOutlet weak var editBtnForProfile        : UIButton!
    @IBOutlet weak var plusBtn                  : UIButton!
    
    @IBOutlet weak var trailigSpaceTimeInOutBtn : NSLayoutConstraint!
    @IBOutlet weak var widthOfTimeInOut         : NSLayoutConstraint!
    
    var arrayForSideMenu                = [Any]()
    var arrayForSideMenuIcons           = [Any]()
    var arrayForHomeTableView           = [Any]()
    var arrayForHomeTableSubtitle       = [Any]()
    var arrayForHomeTableRedIcons       = [Any]()
    var arrayForHomeTableBlueIcons      = [Any]()
    var arrayForHomeTableActionTitles   = [Any]()
    var arrayForHomeTableCountValues    = [Any]()
    
    var boolValueForIsChildShown        = Bool()
    var blurView                        = UIView()
    var totalLeaveBalance               = String()
    var markAttendance                  = Bool()
    var attendaceInOut                  = String()
    var attendanceStatus                = String()
    var teamCount                       = String()
    var leaveBalance                    = String()
    var paySlipMonth                    = String()
    var approvalCount                   = String()
    var locationsCount                  = String()
     var isImageCaptured                     = Bool()
    var greenColor                      = UIColor()
    var redColor                        = UIColor()
    
     var locationManager:CLLocationManager!
    var iscamera = false
    var ipc: UIImagePickerController?
    var imageDataToSend                     = NSData()
    let picker = UIImagePickerController()
   
    //MARK: - View Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        
        boolValueForIsChildShown = false
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        viewForProfileView.backgroundColor = SharedManager.shareData().headerBGColor
        viewForParentShare.isHidden = true
        lblForTitle.isHidden = true
        sideMenuTableView.isHidden = true
        sideMenuWidth.constant = 250
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.hamburger)
        
        attendanceStatus = "--:--"
        
        self.processMenuValidData()
        //arrayForHomeTableCountValues = ["--:--", "", "", "", "", ""]
        
        homeMenuTableView.delegate = self
        homeMenuTableView.dataSource = self
        
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        
        homeMenuTableView.tableFooterView = UIView()
        sideMenuTableView.tableFooterView = UIView()
        
        blurView = UIView(frame: CGRect(x: 250, y: CGFloat(64), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height)))
        blurView.backgroundColor = UIColor.clear
        blurView.isUserInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.gestureHandlerMethod))
        blurView.addGestureRecognizer(tapRecognizer)
        
        
        imgVwForProfilePic.layer.cornerRadius = imgVwForProfilePic.frame.size.height / 2
        imgVwForProfilePic.layer.masksToBounds = true
     //   imgVwForProfilePic.layer.borderWidth = 0.5
        imgVwForProfilePic.layer.borderColor = UIColor.white.cgColor
        imgVwForProfilePic.contentMode = UIViewContentMode.scaleAspectFill
        
        
        let defaults = UserDefaults.standard
        
        SharedManager.shareData().base_URL = defaults.value(forKey: "BaseURL") as! String!
        SharedManager.shareData().sessionID = defaults.value(forKey: "SessionID") as! String!
        SharedManager.shareData().employeeID = defaults.integer(forKey: "EmpID")
        SharedManager.shareData().dictForUserData = (defaults.value(forKey: "User_Data") as! NSDictionary!) as! [AnyHashable : Any]!
             
        
        
        var headerBGColor:String  = (SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "HeaderBGColor") as! String
        let indexHeaderBGColor: String.Index = headerBGColor.index(headerBGColor.startIndex, offsetBy: 1)
        headerBGColor = headerBGColor.substring(from: indexHeaderBGColor) as String
        SharedManager.shareData().headerBGColor = self.getColor(hex: headerBGColor)
        
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        viewForProfileView.backgroundColor = SharedManager.shareData().headerBGColor
        
        var headerTextColor:String  = (SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "HeaderTextColor") as! String
        
        let indexHeaderTextColor: String.Index = headerTextColor.index(headerTextColor.startIndex, offsetBy: 1)
        headerTextColor = headerTextColor.substring(from: indexHeaderTextColor) as String
        SharedManager.shareData().headerTextColor = self.getColor(hex: headerTextColor)
        
        self.setProfileTextColor()
        
        editBtnForProfile.isHidden = true
        
        if  SharedManager.shareData().validForSelfViewProfile == 1 {
            
            self.getProfilePic()
            
            if SharedManager.shareData().getEmpProfileData == 1{
                self.getProfileData(empID: String(SharedManager.shareData().employeeID))
            }else{
                self.setProfileData(dictData: SharedManager.shareData().dictForProfileData as NSDictionary)
            }
            
            self.getMenuDataValues()
            
            
        }else{
            plusBtn.isHidden = true
            
            self.getProfileData(empID: String(format: "%@",SharedManager.shareData().arrayForEmpID.lastObject as! CVarArg))
            self.showChildView()
            boolValueForIsChildShown = false
        }
        
        SharedManager.shareData().popupFor=""
        markAttendance = true
    }
    
    
    func getProfilePic(){
        
        let profileURL: String = ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpImageUrl") as! String)
        
        imgVwForProfilePic.sd_setImage(with: URL(string: String(format:"%@%@",SharedManager.shareData().base_URL,profileURL)), placeholderImage: UIImage(named: "profile_image"))
        var logoURL: NSString = ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "CompanyImageUrl") as! NSString)
        imgVwForTopViewPic.image = UIImage(named: "")
        if !(logoURL is NSNull){
            imgVwForTopViewPic.sd_setImage(with: URL(string: String(format:"%@%@",SharedManager.shareData().base_URL,logoURL)), placeholderImage: UIImage(named: ""))
        }else{
            logoURL = ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EazeWorkLogo") as! String as NSString)
            imgVwForTopViewPic.sd_setImage(with: URL(string: String(format:"%@%@",SharedManager.shareData().base_URL,logoURL)), placeholderImage: UIImage(named: ""))
        }
    }
    
    func processMenuValidData(){
        
        let savedArray: NSMutableArray = SharedManager.shareData().arrayForMenuDescript
        //Edit Profile
        arrayForSideMenu.append("Home")
        arrayForSideMenuIcons.append("icon_home")
        
        if  savedArray.contains(Constants.VALID_FOR_ATTENDANCE){
            arrayForHomeTableView.append("Attendance")
            arrayForHomeTableRedIcons.append("attendance_red")
            arrayForHomeTableBlueIcons.append("attendance_blue")
            arrayForHomeTableSubtitle.append("Review history")
            arrayForHomeTableActionTitles.append("Today's In-Time")
            
            arrayForSideMenu.append("Calendar")
            arrayForSideMenuIcons.append("icon_attandance")
            attendaceInOut = "Today's In-Time"
        }
        
        if  savedArray.contains(Constants.VALID_FOR_TEAM){
            arrayForHomeTableView.append("Team")
            arrayForHomeTableRedIcons.append("team_red")
            arrayForHomeTableBlueIcons.append("team_blue")
            arrayForHomeTableSubtitle.append("Team")
            arrayForHomeTableActionTitles.append("View Team")
        }
        
        if  savedArray.contains(Constants.VALID_FOR_LEAVE){
            arrayForHomeTableView.append("Leave")
            arrayForHomeTableRedIcons.append("leave_red")
            arrayForHomeTableBlueIcons.append("leave_blue")
            arrayForHomeTableSubtitle.append("View and update your leave")
            arrayForHomeTableActionTitles.append("Leave Balance")
            
            arrayForSideMenu.append("Leave")
            arrayForSideMenuIcons.append("icon_leaves")
        }
        
        if  savedArray.contains(Constants.VALID_FOR_PAYSLIP){
            arrayForHomeTableView.append("Payslip")
            arrayForHomeTableRedIcons.append("payslip_red")
            arrayForHomeTableBlueIcons.append("payslip_blue")
            arrayForHomeTableSubtitle.append("Check your payslip")
            arrayForHomeTableActionTitles.append("Last Payslip")
            
            arrayForSideMenu.append("Payslip")
            arrayForSideMenuIcons.append("icon_pay_slip")
        }
        
        if  savedArray.contains(Constants.VALID_FOR_APPROVAL) || savedArray.contains(Constants.VALID_FOR_EMPLOYEE_APPROVAL){
            arrayForHomeTableView.append("Approval")
            arrayForHomeTableRedIcons.append("manager_approval")
            arrayForHomeTableBlueIcons.append("manager_approval_blue")
            arrayForHomeTableSubtitle.append("Check approvals")
            arrayForHomeTableActionTitles.append("Pending Approval")
        }
        
        if  savedArray.contains(Constants.VALID_FOR_LOCATIONS){
            arrayForHomeTableView.append("Locations")
            arrayForHomeTableRedIcons.append("location_red")
            arrayForHomeTableBlueIcons.append("location_blue")
            arrayForHomeTableSubtitle.append("View location details")
            arrayForHomeTableActionTitles.append("Total")
            
            arrayForSideMenu.append("Location")
            arrayForSideMenuIcons.append("icon_location")
        }
        
        if savedArray.contains(Constants.VALID_FOR_VIEW_PROFILE) {
            arrayForSideMenu.append("Profile")
            arrayForSideMenuIcons.append("icon_profile")
        }
        
        arrayForSideMenu.append("Change Password")
        arrayForSideMenuIcons.append("icon_change_pass")
        
        arrayForSideMenu.append("Logout")
        arrayForSideMenuIcons.append("icon_logout")
        
        //        arrayForSideMenu = ["Home", "Calendar", "Leave", "Payslip", "Location", "Profile", "Change Password", "Logout"]
        //        arrayForSideMenuIcons = ["icon_home", "icon_attandance", "icon_leaves", "icon_pay_slip", "icon_location", "icon_profile", "icon_change_pass", "icon_logout"]
        //arrayForHomeTableRedIcons = ["attendance_red", "team_red", "leave_red", "payslip_red", "manager_approval", "location_red"]
        //arrayForHomeTableBlueIcons = ["attendance_blue", "team_blue", "leave_blue", "payslip_blue", "manager_approval_blue", "location_blue"]
        //arrayForHomeTableSubtitle = ["Review History", "Team", "View and update your leave", "Check your payslip", "Check approvals", "View Location Details"]
        // arrayForHomeTableActionTitles = ["Today's In-Time", "View Team", "Leave Balance", "Last Payslip", "Pending Approval", "Total"]
    }
    
    
    func getMenuDataValues(){
        
        greenColor =  UIColor(red: (78/255.0), green: (242/255.0), blue: (48/255.0), alpha: 1.0)
        redColor = UIColor(red: (217/255.0), green: (2/255.0), blue: (13/255.0), alpha: 1.0)
        
        breakInOutButton.backgroundColor = BUTTON_GREEN_BG_COLOR
        timeInOutButton.backgroundColor = BUTTON_GREEN_BG_COLOR
        timeInOutButton.isHidden = true
        breakInOutButton.isHidden = true
        
        timeInOutButton.layer.cornerRadius = 5
        breakInOutButton.layer.cornerRadius = 5
        
       /* 
        let savedArray: NSMutableArray = SharedManager.shareData().arrayForMenuDescript
         if  savedArray.contains(Constants.VALID_FOR_ATTENDANCE){
           // self.getAttendanceStatus()
        }
        if  savedArray.contains(Constants.VALID_FOR_TEAM){
            //self.getTeamCount()
        }
        if  savedArray.contains(Constants.VALID_FOR_LEAVE){
           // self.getLeaveBalancesData()
        }
        if  savedArray.contains(Constants.VALID_FOR_PAYSLIP){
            //self.getLastPaySlip()
        }
        if  savedArray.contains(Constants.VALID_FOR_APPROVAL){
            //self.getPendingApprovalCount()
        }
        if  savedArray.contains(Constants.VALID_FOR_LOCATIONS){
           // self.getLocationsCount()
        }
        */
        self.getHomeData()
    }
    
    func getColor(hex: String) -> UIColor{
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0x00ff00) >> 8
        let b = rgbValue & 0x0000ff
        
        return UIColor(red:CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    func setProfileTextColor() {
        
        editBtnForProfile.setTitleColor(SharedManager.shareData().headerTextColor, for: UIControlState.normal)
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        lblForName.textColor = SharedManager.shareData().headerTextColor
        lblForEmployeeID.textColor = SharedManager.shareData().headerTextColor
    }
    
    @objc func gestureHandlerMethod(sender:UITapGestureRecognizer){
        self.menuOpen()
    }
    
    @IBAction func onClickMenuButton(_ sender: JTHamburgerButton) {
        
        if !boolValueForIsChildShown {
            if sender.currentMode == JTHamburgerButtonMode.hamburger {
                menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
            }else{
                menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.hamburger)
            }
            self.menuOpen()
        }else{
            
            
            if  SharedManager.shareData().validForSelfViewProfile == 1{
                self.getProfilePic()
                self.getMenuDataValues()
                menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.hamburger)
                boolValueForIsChildShown = false
                viewForParentShare.isHidden = true
                lblForTitle.isHidden = true
                imgVwForTopViewPic.isHidden = false
            }else{
                SharedManager.shareData().arrayForEmpID.removeLastObject()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "TeamListVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }
        }
    }
    
    func menuOpen(){
        
        if !sideMenuTableView.isHidden {
            
            sideMenuTableView.isHidden = true
            let animation = CATransition()
            //animation.delegate = self
            animation.type = kCATransitionPush
            animation.subtype = kCATransitionFromRight
            animation.duration = 0.50
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            sideMenuTableView.layer.add(animation, forKey: kCATransition)
            blurView.removeFromSuperview()
            menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.hamburger)
        }else{
            sideMenuTableView.isHidden = false
            let animation = CATransition()
            // animation.delegate = self
            animation.type = kCATransitionPush
            animation.subtype = kCATransitionFromLeft
            animation.duration = 0.50
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            sideMenuTableView.layer.add(animation, forKey: kCATransition)
            menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
            self.view.addSubview(blurView)
        }
    }
    // MARK: Get Home Data
    
    func getHomeData() {
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_HOME_DATA
        let constant = Constants()
        let parameters = constant.getLocationsJsonData()
        
        
      //  print("home data ==>",parameters)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                
                let getHomeDataResult = json["GetHomeDataResult"] as? [String: Any]
                let errorCode: Int = (getHomeDataResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    let resultDictData: NSDictionary = (json["GetHomeDataResult"] as? NSDictionary)!
                    NSLog("Home Data---%@", resultDictData)
                    
                    self.teamCount = String(format:"%@",(resultDictData.value(forKey: "EmpProfile") as? NSDictionary)!.value(forKey: "TeamSize") as! CVarArg)
                    
                    self.timeInOutValidate(dictData: (resultDictData.value(forKey: "AttendanceStatus") as? NSDictionary)!)
                    SharedManager.shareData().dictAttendanceStatus = (resultDictData.value(forKey: "AttendanceStatus") as? NSDictionary)! as NSDictionary? as! [AnyHashable : Any]!
                    
                    self.leaveBalance = (resultDictData.value(forKey: "EmpLeaveBalance") as? NSDictionary)!.value(forKey: "Available") as! String
                    
                    let empSalaryData: NSArray = ((resultDictData.value(forKey: "SalaryMonth") as? NSDictionary)!["Months"] as? NSArray)!
                    if empSalaryData.count > 0{
                        let arrayData: NSArray = (empSalaryData as NSArray) as! [Any] as NSArray
                        self.paySlipMonth = String(format: "%@", (arrayData[0] as! NSDictionary).value(forKey: "MonthDesc") as! CVarArg)
                    }else{
                        self.paySlipMonth = "Download"
                    }

                    let locationDataArray = ((resultDictData.value(forKey: "EmpLocationCount") as? NSDictionary)!["list"] as? NSArray)!
                    
                    if locationDataArray.count > 0{
                        let arrayData: NSArray = (locationDataArray as NSArray) as! [Any] as NSArray
                        self.locationsCount = String(format: "%@", (arrayData[0] as! NSDictionary).value(forKey: "Value") as! CVarArg)
                    }else{
                        self.locationsCount = "0"
                    }
                    
                    self.approvalCount = String(format:"%@",(resultDictData.value(forKey: "EmpPendingApprovalCount") as? NSDictionary)!.value(forKey: "PendingCount") as! CVarArg)
                    
                    self.homeMenuTableView.reloadData()
                }
                else if errorCode == -999 {
                   self.getForceLogout()
                }
                else{
                    
                }
            }
            self.enableTimeInBreakInButton()
            activityIndicatorView.stopAnimating()
        }
    }
    
    
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == sideMenuTableView {
            count = arrayForSideMenu.count
        }else if tableView == homeMenuTableView{
            count = arrayForHomeTableView.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == homeMenuTableView {
            
            let cell:HomeViewCustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HomeViewCustomCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.lblForTitle.text = arrayForHomeTableView[indexPath.row] as? String
            cell.lblForSubTitle.text = arrayForHomeTableSubtitle[indexPath.row] as? String
            cell.lblForActionTitle.text = arrayForHomeTableActionTitles[indexPath.row] as? String
            
            if indexPath.row % 2 == 0 {
                cell.imgVwForIcon.image = UIImage(named: arrayForHomeTableRedIcons[indexPath.row] as! String)
            }
            else {
                cell.imgVwForIcon.image = UIImage(named: arrayForHomeTableBlueIcons[indexPath.row] as! String)
            }
            
            if cell.lblForTitle.text == "Attendance"{
                cell.lblForCount.text = attendanceStatus
                cell.lblForActionTitle.text = attendaceInOut
                if !markAttendance{
                    cell.lblForActionTitle.isHidden = true
                    cell.lblForCount.isHidden = true
                }
            }else if cell.lblForTitle.text == "Team"{
                cell.lblForCount.text = teamCount
            }else if cell.lblForTitle.text == "Leave"{
                cell.lblForCount.text = leaveBalance
            }else if cell.lblForTitle.text == "Payslip"{
                cell.lblForCount.text = paySlipMonth
            }else if cell.lblForTitle.text == "Approval"{
                cell.lblForCount.text = approvalCount
            }else if cell.lblForTitle.text == "Locations"{
                cell.lblForCount.text = locationsCount
            }
            
        
            if UIDevice.current.userInterfaceIdiom == .pad {
                cell.lblForCount.textAlignment = .right
                cell.lblForActionTitle.textAlignment = .right
            }
            
            
            
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        let cell:SideMenuCustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SideMenuCustomCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.lblForText.text = arrayForSideMenu[indexPath.row] as? String
        cell.imgVwForIcon.image = UIImage(named: arrayForSideMenuIcons[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.sideMenuTableView {
            let cell: SideMenuCustomCell? = tableView.cellForRow(at: indexPath) as! SideMenuCustomCell?
            if (cell?.lblForText?.text == "Profile") {
                self.showProfileView()
            }else if (cell?.lblForText?.text == "Logout"){
                
                let refreshAlert = UIAlertController(title: "Confirmation", message: "Do you want to logout ?" , preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                }))
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                    self.getLogout()
                }))
                
                DispatchQueue.main.async(execute: {
                    self.present(refreshAlert, animated: true, completion: nil)
                });
                
            }else if (cell?.lblForText?.text == "Leave") {
                self.showLeaveView()
            }else if (cell?.lblForText?.text == "Home") {
                self.menuOpen()
            }else if (cell?.lblForText?.text == "Change Password") {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }else if (cell?.lblForText?.text == "Payslip"){
               self.showPaySlipView()
            }else if (cell?.lblForText?.text == "Calendar"){
             //CalendarVC
               self.showCalendarView()
            }
            else if (cell?.lblForText?.text == "Location"){
               self.showLocationsView()
            }
        }else if tableView == self.homeMenuTableView{
            let cell: HomeViewCustomCell? = tableView.cellForRow(at: indexPath) as! HomeViewCustomCell?
            if (cell?.lblForTitle?.text == "Leave") {
                self.showLeaveView()
            }else if (cell?.lblForTitle?.text == "Payslip"){
                self.showPaySlipView()
            }else if (cell?.lblForTitle?.text == "Attendance"){
             //AttendanceHistoryVC
                
                SharedManager.shareData().isSelfAttendanceHistory = 1
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "AttendanceHistoryVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }else if  (cell?.lblForTitle?.text == "Locations"){
                self.showLocationsView()
            }else if  (cell?.lblForTitle?.text == "Team"){
                self.showTeamListView()
            }else if  (cell?.lblForTitle?.text == "Approval"){
                self.showApprovalsView()
            }
        }
    }
    
    //MARK: -
    
    
    
    @IBAction func onClickProfileView(_ sender: UIButton) {
        
        self.showProfileView()
    }
    
    
    func showPaySlipView(){
        if paySlipMonth == "Download" {
            let refreshAlert = UIAlertController(title: "", message:"Currently no pay slip available" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "ViewPayslipVC")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
        }

    }
    
    func showApprovalsView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "ApprovalsVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    func showTeamListView(){
        //TeamListVC
        SharedManager.shareData().teamCount = 1
        
        //SharedManager.shareData().arrayForEmpID.append(String(SharedManager.shareData().employeeID))
    
        let arrayForEmpID = NSMutableArray()
        arrayForEmpID.add(SharedManager.shareData().employeeID)
        SharedManager.shareData().arrayForEmpID = arrayForEmpID
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "TeamListVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    func showLocationsView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "StoreLocationVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    func showLeaveView()   {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "LeaveVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    func showProfileView() {
        
        if !boolValueForIsChildShown {
            lblForTitle.text = "Profile"
            self.showChildView()
            
            let addStatusViewController: ViewProfileController? = storyboard?.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileController?
            addStatusViewController?.view?.frame = viewForParentShare.bounds
            addStatusViewController?.willMove(toParentViewController: self)
            viewForParentShare.addSubview((addStatusViewController?.view)!)
            addChildViewController(addStatusViewController!)
            addStatusViewController?.didMove(toParentViewController: self)
        }
    }
    
    func showCalendarView(){
        
        if !boolValueForIsChildShown {
            lblForTitle.text = "Calendar"
            SharedManager.shareData().calendarForLeave = 0
            self.showChildView()
            
            let addStatusViewController: CalendarViewController? = storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarViewController?
            addStatusViewController?.view?.frame = viewForParentShare.bounds
            addStatusViewController?.willMove(toParentViewController: self)
            viewForParentShare.addSubview((addStatusViewController?.view)!)
            addChildViewController(addStatusViewController!)
            addStatusViewController?.didMove(toParentViewController: self)
        }
    }
    
    func showChildView(){
        blurView.removeFromSuperview()
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        sideMenuTableView.isHidden = true
        lblForTitle.isHidden = false
        viewForParentShare.isHidden = false
        boolValueForIsChildShown = true
        imgVwForTopViewPic.isHidden = true
    }
    
    //MARK: - Get Profile Data
    
    func getProfileData(empID: String){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_PROFILE

        let constant = Constants()
        let parameters = constant.getProfileJsonData(empID: empID)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let getEmployeeDetailsResult = json["GetEmployeeDetailsResult"] as? [String: Any]
                let errorCode: Int = (getEmployeeDetailsResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let dictData: NSDictionary = (getEmployeeDetailsResult?["employeeDetails"] as? NSDictionary)!
                    self.setProfileData(dictData: dictData)
                }else{
                    
                }
            }
        }
    }
    
    //MARK: - Set Profile Data
    
    func setProfileData(dictData:NSDictionary){
        
        NSLog("Profile Data---%@",dictData)
       
        if SharedManager.shareData().getEmpProfileData == 1 {
            SharedManager.shareData().dictForProfileData = dictData as NSDictionary? as! [AnyHashable : Any]!
            SharedManager.shareData().getEmpProfileData = 0
        }
    
        if  SharedManager.shareData().validForSelfViewProfile == 2{
            SharedManager.shareData().dictForTeamProfileData = dictData as NSDictionary? as! [AnyHashable : Any]!
        }
        
        
        
        
        if (dictData.value(forKey: "MiddleName") as! String?)!.characters.count > 0{
            lblForName.text = String(format:"%@ %@ %@",(dictData.value(forKey: "FirstName") as! String?)!,(dictData.value(forKey: "MiddleName") as! String?)!,(dictData.value(forKey: "LastName") as! String?)!)
        }else{
            lblForName.text = String(format:"%@ %@",(dictData.value(forKey: "FirstName") as! String?)!,(dictData.value(forKey: "LastName") as! String?)!)
        }
        
        let department: String = "Department : "
        let departmentData: String = (dictData.value(forKey: "DeptName") as! String?)!
//        lblForDepartment.text = department + departmentData

        let designation: String = "Designation : "
        let designationData: String = (dictData.value(forKey: "Designation") as! String?)!
       // lblForDesignation.text = designation + designationData
        
        let employeeID: String = "Employee ID : "
        let employeeIDData: String = (dictData.value(forKey: "EmpCode") as! String?)!
        lblForEmployeeID.text = employeeID + employeeIDData
        
        if  SharedManager.shareData().validForSelfViewProfile == 2{
            
            let savedArray: NSMutableArray = SharedManager.shareData().arrayForMenuDescript
            //Edit Profile
            if savedArray.contains(Constants.VALID_FOR_EDIT_PROFILE) {
                editBtnForProfile.isHidden = false
            }
            self.showProfileView()
            let profileURL: String = (dictData.value(forKey: "EmpImageUrl") as! String?)!
            imgVwForProfilePic.sd_setImage(with: URL(string: String(format:"%@%@",SharedManager.shareData().base_URL,profileURL)), placeholderImage: UIImage(named: "profile_image"))
        }
    }
    
    //MARK: - Get Leave Balances Data
    
    func getLeaveBalancesData(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_LEAVE_BALANCES
        
        let constant = Constants()
        let parameters = constant.getLeaveBalanceJsonData()
        
       Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let getEmployeeDetailsResult = json["GetEmpLeaveBalancesResult"] as? [String: Any]
                let errorCode: Int = (getEmployeeDetailsResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getEmployeeDetailsResult?["leavesBalanceList"] as? NSArray)!
                    var leaveCount: Float = 0
                    for i in (0..<resultData.count){
                        let dictLeave: NSDictionary = (resultData[i] as? NSDictionary)!
                        leaveCount = leaveCount + Float((dictLeave.value(forKey: "Balance") as? String)!)!
                    }
                    let totalLeaves = String(format: "%.1f", leaveCount)
                    self.leaveBalance = totalLeaves
                    self.homeMenuTableView.reloadData()
                    SharedManager.shareData().arrayForLeaveBalancesData = resultData as NSArray? as! [Any]!
                }else{
                    
                }
            }
        }
    }
    
    func getAttendanceStatus(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_ATTENDANCE_STATUS
        let constant = Constants()
        let parameters = constant.getAttendanceStatusJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                
                let attendanceStatusResult = json["AttendanceStatusResult"] as? [String: Any]
                let errorCode: Int = (attendanceStatusResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    let resultData: NSDictionary = (json["AttendanceStatusResult"] as? NSDictionary)!
                    self.timeInOutValidate(dictData: resultData)
                    SharedManager.shareData().dictAttendanceStatus = resultData as NSDictionary? as! [AnyHashable : Any]!
                }else{
                    
                }
            }
            self.enableTimeInBreakInButton()
        }
    }
    
    
    func enableTimeInBreakInButton(){
        UIApplication.shared.endIgnoringInteractionEvents()
        self.breakInOutButton.isEnabled = true
        self.breakInOutButton.alpha = 1.0
        self.timeInOutButton.isEnabled = true
        self.timeInOutButton.alpha = 1.0    }
    
    func disableTimeInBreakInButton(){
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.breakInOutButton.isEnabled = false
        self.breakInOutButton.alpha = 0.5
        self.timeInOutButton.isEnabled = false
        self.timeInOutButton.alpha = 0.5
    }

    
    
    func timeInOutValidate(dictData: NSDictionary)  {
    
        if !(dictData["InTime"] is NSNull) {
            var inTime = NSString()
            if !(dictData["OutTime"] is NSNull) {
                inTime = (dictData["OutTime"] as? NSString)!
                self.attendaceInOut = "Today's Out-Time"
                
                widthOfTimeInOut.constant = 150
                timeInOutButton.isHidden = false
                timeInOutButton.setTitle("Cancel Time-Out", for: UIControlState.normal)
                timeInOutButton.backgroundColor = redColor
            }else{
                
                inTime = (dictData["InTime"] as? NSString)!
                self.attendaceInOut = "Today's In-Time"
                
                widthOfTimeInOut.constant = 80
                timeInOutButton.isHidden = false
                timeInOutButton.setTitle("Time-Out", for: UIControlState.normal)
                timeInOutButton.backgroundColor = BUTTON_GREEN_BG_COLOR
                
                breakInOutButton.isHidden = true
                trailigSpaceTimeInOutBtn.constant = 20
                if dictData["ATTLevel"] as? String == "1" {
                    
                }else if dictData["ATTLevel"] as? String == "2"{
                    
                }else if dictData["ATTLevel"] as? String == "3"{
                    trailigSpaceTimeInOutBtn.constant = 120
                    breakInOutButton.isHidden = false
                    
                    if !(dictData["BreakOut"] is NSNull){
                        breakInOutButton.setTitle("Break-In", for: UIControlState.normal)
                    }else{
                        breakInOutButton.setTitle("Break-Out", for: UIControlState.normal)
                    }
                }
            }
            self.attendanceStatus = inTime as String
            self.homeMenuTableView.reloadData()
        }else{
            NSLog("No Attendance Today")
            self.attendaceInOut = "Today's In-Time"
            self.attendanceStatus = "--:--"
            
            widthOfTimeInOut.constant = 80
            timeInOutButton.isHidden = false
            timeInOutButton.setTitle("Time-In", for: UIControlState.normal)
            
            if dictData["ATTLevel"] as? String == "1" {
                widthOfTimeInOut.constant = 150
                timeInOutButton.isHidden = false
                timeInOutButton.setTitle("Mark Attendance", for: UIControlState.normal)
            }else if dictData["ATTLevel"] as? String == "2"{
                
            }else if dictData["ATTLevel"] as? String == "3"{
                
            }
        }
        if !(dictData["MarkAttendanceYN"] as? String == "Y") {
            timeInOutButton.isHidden = true
            breakInOutButton.isHidden = true
            markAttendance = false
        }
    }
    
    func getTeamCount(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_TEAM_MEMBER_LIST
        let constant = Constants()
        
        let parameters = constant.getTeamCountJsonData(subLevel: "1", empID: String(SharedManager.shareData().employeeID))
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let getTeamMemberListResult = json["GetTeamMemberListResult"] as? [String: Any]
                let errorCode: Int = (getTeamMemberListResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getTeamMemberListResult?["list"] as? NSArray)!
                    let arrayData: NSArray = (resultData as NSArray) as! [Any] as NSArray
                    self.teamCount = String(format: "%i", arrayData.count)
                    self.homeMenuTableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    func getLastPaySlip(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_SALARY_SLIP_MONTHS
        
        let constant = Constants()
        let parameters = constant.getMenuJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let salaryMonthResult = json["SalaryMonthResult"] as? [String: Any]
                let errorCode: Int = (salaryMonthResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (salaryMonthResult?["Months"] as? NSArray)!
                    if resultData.count > 0{
                        let arrayData: NSArray = (resultData as NSArray) as! [Any] as NSArray
                        self.paySlipMonth = String(format: "%@", (arrayData[0] as! NSDictionary).value(forKey: "MonthDesc") as! CVarArg)
                    }else{
                        self.paySlipMonth = "Download"
                    }
                     self.homeMenuTableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    func getPendingApprovalCount(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_COMMON_SERVICE_PENDING_APPROVAL_COUNT
        let constant = Constants()
        let parameters = constant.getMenuJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let getEmpPendingApprovalCountResult = json["GetEmpPendingApprovalCountResult"] as? [String: Any]
                let errorCode: Int = (getEmpPendingApprovalCountResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSString = (getEmpPendingApprovalCountResult?["PendingCount"] as? NSString)!
                    self.approvalCount = String(format: "%@", resultData)
                    self.homeMenuTableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    func getLocationsCount(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_LOCATION_LIST
        
        let constant = Constants()
        let parameters = constant.getLocationsJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                
                let getLocationListResult = json["GetLocationListResult"] as? [String: Any]
                let errorCode: Int = (getLocationListResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getLocationListResult?["list"] as? NSArray)!
                    self.locationsCount = String(format: "%i", resultData.count)
                    self.homeMenuTableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
     func getForceLogout()
     {
    let defaults = UserDefaults.standard
    defaults.set(false, forKey: "Is_Login")
        
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "RootVC")
    UIApplication.shared.keyWindow?.rootViewController = rootViewController
    
    }
    func getLogout(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_LOGOUT
        
        let constant = Constants()
        let parameters = constant.getValidateLoginJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let logOutUserResult = json["LogOutUserResult"] as? [String: Any]
                let errorCode: Int = (logOutUserResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    
                    let defaults = UserDefaults.standard
                    defaults.set(false, forKey: "Is_Login")
                    // Sign out from Google account
                    //GIDSignIn.sharedInstance().signOut()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "RootVC")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                }else{
                    let message = (logOutUserResult?["ErrorMessage"] as? String)!
                    
                    let refreshAlert = UIAlertController(title: "", message:message , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: -
    
    @IBAction func onClickPlusButton(_ sender: UIButton) {
        
        NSLog("%@", arrayForHomeTableCountValues)
        
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
    }


    @IBAction func onClickTimeInOut(_ sender: UIButton) {
        
         self.disableTimeInBreakInButton()
        
        if timeInOutButton.titleLabel?.text == "Cancel Time-Out"{
            self.getLocationName(requestType: "4")
        }
//        else if timeInOutButton.titleLabel?.text == "Mark Attendance"{
//            self.getLocationName(requestType: "0")
//        }
        else{
            self.enableTimeInBreakInButton()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "MapVC")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
        }
    }
    
    @IBAction func onClickBreakInOut(_ sender: UIButton) {
        
        
        if CLLocationManager.locationServicesEnabled() {
            self.disableTimeInBreakInButton()
            var requestType = ""
            if self.breakInOutButton.titleLabel?.text == "Break-In"{
                requestType = "2"
            }else{
                requestType = "1"
            }
            self.getLocationName(requestType: requestType)
        }else{
            let refreshAlert = UIAlertController(title: "Location is not enabled", message:"Please enable GPS" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }

    
    func getLocationName(requestType: String){
    

        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        var locationName = ""
        
         let locatonCoordinate = self.determineMyCurrentLocation()
        let location = CLLocation(latitude: locatonCoordinate.latitude, longitude: locatonCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                locationName = ""
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                print(pm.addressDictionary as Any)
                locationName = (pm.addressDictionary?["FormattedAddressLines"] as! NSArray).componentsJoined(by: ",")
            }else {
                locationName = ""
            }
             activityIndicatorView.stopAnimating()
            self.breakInOut(locationName: locationName, requestType: requestType)
        })
}
    
    func breakInOut(locationName: String, requestType: String ) {
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_MARK_ATTENDANCE
        
       let locCoordinate = self.determineMyCurrentLocation()
        let constant = Constants()
        let parameters = constant.markAttendance(requestType:requestType, attendanceID: "0", latitude: String(format:"%f",locCoordinate.latitude), longitude: String(format:"%f",locCoordinate.longitude), location:locationName)
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                   
                self.getHomeData()
            }
        }
    }
    
    
    func determineMyCurrentLocation() -> CLLocationCoordinate2D{
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }else{
            var coordinate = CLLocationCoordinate2D()
            coordinate.latitude = 0.0
            coordinate.longitude = 0.0
            return coordinate
        }
        
        return (locationManager.location?.coordinate)!
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }

    @IBAction func onClickEdit(_ sender: UIButton) {
        //EditProfileVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "EditProfileVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func get_dialouge() {
        self.view.endEditing(true)
        let view = UIAlertController(title: "", message: "YOUR OPTIONS", preferredStyle: .actionSheet)
        
        
        
        let Camera = UIAlertAction(title: "Open Camera", style: .default, handler: { action in
            self.opencamera()
            //you can check here on what button is pressed using title
        })
        
        
        view.addAction(Camera)
        
        let Gallery = UIAlertAction(title: "Open Gallery", style: .default, handler: { action in
            self.openGallery()
            //you can check here on what button is pressed using title
        })
        
        
        view.addAction(Gallery)
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            view.dismiss(animated: true)
            
        })
        
        
        view.addAction(cancel)
        present(view, animated: true)
        
    }
    
    func opencamera(){
        self.picker.allowsEditing = false
        self.picker.sourceType = UIImagePickerControllerSourceType.camera
        self.picker.delegate = self
        self.present(self.picker, animated: true, completion: nil)

    }
    func openGallery() {
        self.picker.allowsEditing = false
        self.picker.sourceType = .photoLibrary
        self.picker.delegate = self
        self.present(self.picker, animated: true, completion: nil)
    }
   
    
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        imgVwForProfilePic.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated:true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: ({
            self.uploadProfilePicture()
            
        }))
        
      
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func uploadProfilePicture(){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_ProfilePic_Upload
        let parameters = self.getuploaddata()
        //print(parameters)
        
        
        //
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                if let UploadProfilePicResult = json["UploadProfilePicResult"] as? [String: Any]
                {
                    let errorCode: Int = (UploadProfilePicResult["ErrorCode"] as? Int)!
                    if errorCode == 0
                    {
                        print("profile pic uploaded")
                    }
                    else if errorCode == -999 {
                        self.getForceLogout()
                    }
                }
            }
            self.enableTimeInBreakInButton()
            activityIndicatorView.stopAnimating()
        }
    }
    
    func getuploaddata() -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "FileInfo":[
                "Name": "sample.jpeg",
                "Extension": ".jpeg",
                "Base64Data":imgVwForProfilePic.image?.base64(format:.jpeg(10)),
                "Length":"10"
            ]
        ]
        return parameters
    }
    func compressImage(image:UIImage) -> NSData {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 200.0
        let maxWidth : CGFloat = 200.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        var maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        
        let rect = CGRect(x:0.0, y:0.0, width:actualWidth, height:actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
        UIGraphicsEndImageContext();
        return imageData as NSData!
    }
    
}
extension UIImage {
    
    public func base64(format: ImageFormat) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = UIImagePNGRepresentation(self)
        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
        }
        return imageData?.base64EncodedString()
    }
}
