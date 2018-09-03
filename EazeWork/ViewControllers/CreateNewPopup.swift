//
//  CreateNewPopup.swift
//  EazeWork
//
//  Created by User1 on 5/5/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView

class CreateNewPopup: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var viewForBackView: UIView!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var tableVw: UITableView!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
     var arrayForMenu = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.endEditing(true)
        viewForBackView.backgroundColor = UIColor.clear
        viewForBackView.layer.borderWidth = 0.5
        viewForBackView.layer.borderColor = UIColor.lightGray.cgColor
        
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
    
        if SharedManager.shareData().popupFor == "Gender" {
            lblForTitle.text = "Select"
            self.getTypeWiseList()
        }else if SharedManager.shareData().popupFor == "LeaveType"{
            lblForTitle.text = "Select Leave Type"
            contentViewHeight.constant = 460
            self.getLeaveTypes()
        }else if SharedManager.shareData().popupFor == "RHLeaveType"{
            arrayForMenu = SharedManager.shareData().arrayForRHLeaves
            lblForTitle.text = "Select Date"
        }else if SharedManager.shareData().popupFor == "OfficeType"{
            lblForTitle.text = "Select"
            arrayForMenu = SharedManager.shareData().arrayForOfficeType
            // self.getTypeWiseList()
        }else if SharedManager.shareData().popupFor == "MappingMember"{
            lblForTitle.text = "Select"
            arrayForMenu = SharedManager.shareData().arrayForMappingMembers
            //self.getTypeWiseList()
        }
        else if SharedManager.shareData().popupFor == "TeamList"{
            lblForTitle.text = "Select Action"
            let savedArray: NSMutableArray = SharedManager.shareData().arrayForMenuDescript
            if  savedArray.contains(Constants.VALID_FOR_VIEW_PROFILE){
                arrayForMenu.append("View Profile")
            }
            if SharedManager.shareData().validForTeamMembers > 0{
                arrayForMenu.append("Team Members")
            }
            arrayForMenu.append("Attendance Details")
            tableVw.isScrollEnabled = false
        }else if SharedManager.shareData().popupFor == "GetManager"{
            contentViewHeight.constant = 380
            lblForTitle.text = "Select Manager"
            self.getTeamList()
        }else if SharedManager.shareData().popupFor == "GetWorkLocation"{
            contentViewHeight.constant = 380
            lblForTitle.text = "Select Work Location"
            self.getTypeWiseList()
        }else{
            let savedArray: NSMutableArray = SharedManager.shareData().arrayForMenuDescript
            if  savedArray.contains(Constants.VALID_FOR_CREATE_LOCATION){
                arrayForMenu.append("Location")
            }
            if  savedArray.contains(Constants.VALID_FOR_CREATE_EMPLOYEE){
                arrayForMenu.append("Employee")
            }
            if  savedArray.contains(Constants.VALID_FOR_LEAVE_REQUEST){
                arrayForMenu.append("Leave")
            }
            tableVw.isScrollEnabled = false
        }
        
        tableVw.delegate = self
        tableVw.dataSource = self

        tableVw.tableFooterView = UIView()
    }

    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = arrayForMenu.count
        if SharedManager.shareData().popupFor == "Gender" ||  SharedManager.shareData().popupFor == "TeamList"{
            count = arrayForMenu.count
        } else if SharedManager.shareData().popupFor == "LeaveType"{
            count = arrayForMenu.count
        } else if  SharedManager.shareData().popupFor == "RHLeaveType"{
            count = arrayForMenu.count
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        if SharedManager.shareData().popupFor == "LeaveType"{
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            cell?.textLabel?.text = (dictLeave.value(forKey: "LeaveName") as? String)!
        }else if  SharedManager.shareData().popupFor == "RHLeaveType"{
              cell?.textLabel?.text = arrayForMenu[indexPath.row] as? String
        }else if SharedManager.shareData().popupFor == "Gender"{
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            cell?.textLabel?.text = (dictLeave.value(forKey: "Value") as? String)!
        }else if SharedManager.shareData().popupFor == "OfficeType"{
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            cell?.textLabel?.text = (dictLeave.value(forKey: "Value") as? String)!
        }else if SharedManager.shareData().popupFor == "MappingMember"{
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            cell?.textLabel?.text = (dictLeave.value(forKey: "Value") as? String)!
        }else if SharedManager.shareData().popupFor == "GetWorkLocation"{
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            cell?.textLabel?.text = (dictLeave.value(forKey: "Value") as? String)!
        }else if SharedManager.shareData().popupFor == "GetManager"{
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            cell?.textLabel?.text = (dictLeave.value(forKey: "Name") as? String)!
        }else{
            cell?.textLabel?.text = (arrayForMenu[indexPath.row] as? String)!
        }
        
        
            return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if SharedManager.shareData().popupFor == "Gender"{
            
            let name:NSNotification.Name = NSNotification.Name("GenderSelected")
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            let userInfo = dictLeave
            NotificationCenter.default.post(name: name,
                                            object: self,
                                            userInfo: ((userInfo ) as! [AnyHashable : Any]))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                            object: nil,
                                            userInfo: nil)
        }else if SharedManager.shareData().popupFor == "LeaveType"{
            
            let name:NSNotification.Name = NSNotification.Name("LeaveSelected")
            
            let leaveType: NSDictionary = arrayForMenu[indexPath.row] as! NSDictionary
            
            NotificationCenter.default.post(name: name,
                                            object: self,
                                            userInfo:(leaveType as! [AnyHashable : Any]))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                            object: nil,
                                            userInfo: nil)

        }else if SharedManager.shareData().popupFor == "RHLeaveType"{
            let name:NSNotification.Name = NSNotification.Name("RHLeaveTypeSelected")
            
            let rhLeaveType: String = arrayForMenu[indexPath.row] as! String
            
            let userInfo = ["RHLeaveType": rhLeaveType] as NSDictionary
            
            NotificationCenter.default.post(name: name,
                                            object: self,
                                            userInfo: ((userInfo ) as! [AnyHashable : Any]))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                            object: nil,
                                            userInfo: nil)
        }else if SharedManager.shareData().popupFor == "OfficeType"{
            let name:NSNotification.Name = NSNotification.Name("OfficeTypeSelected")
            
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            let userInfo = dictLeave
            
            NotificationCenter.default.post(name: name,
                                            object: self,
                                            userInfo: ((userInfo ) as! [AnyHashable : Any]))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                            object: nil,
                                            userInfo: nil)
        
        } else if SharedManager.shareData().popupFor == "MappingMember"{
            
            let name:NSNotification.Name = NSNotification.Name("MappingMemberSelected")
            
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            let userInfo = dictLeave
            
            NotificationCenter.default.post(name: name,
                                            object: self,
                                            userInfo: ((userInfo ) as! [AnyHashable : Any]))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                            object: nil,
                                            userInfo: nil)
            
        } else if SharedManager.shareData().popupFor == "TeamList"{
            
            SharedManager.shareData().arrayForEmpID.add(SharedManager.shareData().employeeIDForAttendance)
            
            if (arrayForMenu[indexPath.row] as? String)! == "View Profile"{
                SharedManager.shareData().getEmpProfileData = 0
                SharedManager.shareData().validForSelfViewProfile = 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
            }else if (arrayForMenu[indexPath.row] as? String)! == "Team Members"{
                
                SharedManager.shareData().teamCount = SharedManager.shareData().teamCount + 1

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "TeamListVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
            }else if (arrayForMenu[indexPath.row] as? String)! == "Attendance Details"{
                SharedManager.shareData().isSelfAttendanceHistory = 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "AttendanceHistoryVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }
        }else if SharedManager.shareData().popupFor == "GetWorkLocation"{
            
            let name:NSNotification.Name = NSNotification.Name("WorkLocationSelected")
            
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            let userInfo = dictLeave
            
            NotificationCenter.default.post(name: name,
                                            object: self,
                                            userInfo: ((userInfo ) as! [AnyHashable : Any]))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                            object: nil,
                                            userInfo: nil)
        
        }else if SharedManager.shareData().popupFor == "GetManager"{
            
            let name:NSNotification.Name = NSNotification.Name("ManagerSelected")
            
            let dictLeave: NSDictionary = (arrayForMenu[indexPath.row] as? NSDictionary)!
            let userInfo = dictLeave
            
            NotificationCenter.default.post(name: name,
                                            object: self,
                                            userInfo: ((userInfo ) as! [AnyHashable : Any]))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                            object: nil,
                                            userInfo: nil)
            
        }else{
        
            if (arrayForMenu[indexPath.row] as? String)! == "Employee"{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "CreateProfileVC")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }else if (arrayForMenu[indexPath.row] as? String)! == "Leave"{
                //CreateLeaveVC
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "CreateLeaveVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }else if (arrayForMenu[indexPath.row] as? String)! == "Location"{
                SharedManager.shareData().isEditOrCreateLocation = 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "CreateEditLocVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }
        }
    }

    //MARK: - 
    func getLeaveTypes(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_GET_EMPLOYEE_LEAVES
        //{"loginData":{"DeviceID":"JamesBond007","SessionID":"E847ACB3-19BE-4756-BE87-68275E27606F"},"empID":22279}
    
        let constant = Constants()
        
        let parameters = constant.getLeaveBalanceJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {

                let getEmpLeavesResult = json["GetEmpLeavesResult"] as? [String: Any]
                let errorCode: Int = (getEmpLeavesResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getEmpLeavesResult?["Leaves"] as? NSArray)!
                    self.arrayForMenu = (resultData as NSArray) as! [Any]
                    self.tableVw.reloadData()
                   // NSLog("%@", self.arrayForMenu)
                }else{
                    
                }
            }
        }
    }

    func getTypeWiseList(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_TYPE_WISE
        
        let constant = Constants()        
        var parameters = Parameters()
 
        if SharedManager.shareData().popupFor == "OfficeType"{
            ////Pass ParamType='ddParentLocationList' , RefCode=<OfficeType>
            parameters = constant.getTypeWiseListJsonData(fieldCode: "ddLocationTypeSMList",refCode: "")
        }else if SharedManager.shareData().popupFor == "MappingMember"{
             parameters = constant.getTypeWiseListJsonData(fieldCode: "ddLocationMapEligibleEmpList",refCode:  SharedManager.shareData().officeIDForDetails)
        }else if SharedManager.shareData().popupFor == "GetWorkLocation"{
            parameters = constant.getTypeWiseListJsonData(fieldCode: "ddLocationList",refCode:  "")
        }else{
            parameters = constant.getTypeWiseListJsonData(fieldCode: "FieldCode",refCode: (SharedManager.shareData().dictForGetTypeWiseList as NSDictionary).value(forKey: "FieldCode") as! String)
        }
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                
                let getTypeWiseListResult = json["GetTypeWiseListResult"] as? [String: Any]
                let errorCode: Int = (getTypeWiseListResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getTypeWiseListResult?["list"] as? NSArray)!
                    self.arrayForMenu = (resultData as NSArray) as! [Any]
                    self.tableVw.reloadData()
                    if SharedManager.shareData().popupFor == "MappingMember"{
                        if self.arrayForMenu.count <= 0{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                                            object: nil,
                                                            userInfo: nil)

                        }
                    }
                }else{
                    if SharedManager.shareData().popupFor == "MappingMember"{
                        if self.arrayForMenu.count <= 0{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                                            object: nil,
                                                            userInfo: nil)
                            
                        }
                    }
                }
            }
        }
    }
    
    func getTeamList(){
        
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
        
        let empID = String(SharedManager.shareData().employeeID)
        
        let parameters = constant.getTeamCountJsonData(subLevel: "9999", empID:empID)
        
      
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getTeamMemberListResult = json["GetTeamMemberListResult"] as? [String: Any]
                let errorCode: Int = (getTeamMemberListResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getTeamMemberListResult?["list"] as? NSArray)!
                    let arrayData: NSMutableArray = resultData.mutableCopy() as! NSMutableArray
                    self.arrayForMenu = arrayData as! [Any]
                    
                    for i in (0..<self.arrayForMenu.count){
                         let dictLeave: NSDictionary = (self.arrayForMenu[i] as? NSDictionary)!
                        if dictLeave.value(forKey: "EmpID") as! String == String(format: "%@",SharedManager.shareData().arrayForEmpID.lastObject as! CVarArg){
                            arrayData.removeObject(at: i)
                        }
                    }
                    self.arrayForMenu = arrayData as! [Any]
                    self.tableVw.reloadData()
                }else{
                    
                }
            }
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
