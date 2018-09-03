//
//  EditProfileViewController.swift
//  EazeWork
//
//  Created by User1 on 5/24/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView

class EditProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblForTitle: UILabel!
    
    @IBOutlet weak var viewForPersonalDetails: UIView!
    @IBOutlet weak var viewForOfficialDetails: UIView!
    
    @IBOutlet weak var lblForEmail: UILabel!
    @IBOutlet weak var lblForDesignation: UILabel!
    @IBOutlet weak var lblForDateOfBirth: UILabel!
    @IBOutlet weak var lblForDateOfJoining: UILabel!
    @IBOutlet weak var lblForMaritalStatus: UILabel!
    
    @IBOutlet weak var btnManagerName: UIButton!
    @IBOutlet weak var btnOfficeLocation: UIButton!
    @IBOutlet weak var btnWorkLocation: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var tableVwForPersonalDetails: UITableView!
    
    @IBOutlet weak var personalDetailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollVwHeight: NSLayoutConstraint!
    
    var arrayForPersonalDetailsType = NSMutableArray()
    var arrayForPersonalDetailsTypeValue = NSMutableArray()
    
    var workLocationID = String()
    var managerID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        
        viewForPersonalDetails.backgroundColor = UIColor.clear
        viewForPersonalDetails.layer.borderWidth = 1.0
        viewForPersonalDetails.layer.borderColor = UIColor.lightGray.cgColor
        viewForOfficialDetails.backgroundColor = UIColor.clear
        viewForOfficialDetails.layer.borderWidth = 1.0
        viewForOfficialDetails.layer.borderColor = UIColor.lightGray.cgColor
        self.setProfileData(dictData: SharedManager.shareData().dictForTeamProfileData as NSDictionary)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationCallback(_:)),
                                               name: NSNotification.Name(rawValue: "WorkLocationSelected"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationCallback(_:)),
                                               name: NSNotification.Name(rawValue: "ManagerSelected"),
                                               object: nil)
        
        //button.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);

        btnManagerName.imageEdgeInsets = UIEdgeInsetsMake(0, 315, 0, 0)
        btnManagerName.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25)
        btnManagerName.addBorder(side: UIButtonBorderSide.Bottom, color: UIColor.lightGray, width: 1.0)
        
        
        
        btnWorkLocation.imageEdgeInsets = UIEdgeInsetsMake(0, 315, 0, 0)
        btnWorkLocation.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25)
        btnWorkLocation.addBorder(side: UIButtonBorderSide.Bottom, color: UIColor.lightGray, width: 1.0)

    }
  
    @objc  func notificationCallback(_ notification: NSNotification){
        
        if notification.name.rawValue == "WorkLocationSelected" {
            let userInfo = notification.userInfo as NSDictionary? as! [String:Any]?
            
            var titleString:String  = ((userInfo! as NSDictionary).value(forKey: "Value") as? String)!
        
           if titleString.count < 10
           {
             titleString  = titleString + "                      "
            }
            
            
            btnWorkLocation.setTitle(titleString, for: UIControlState.normal)
            
           
//            btnWorkLocation.setTitle((userInfo! as NSDictionary).value(forKey: "Value") as? String, for: UIControlState.normal)
            workLocationID = ((userInfo! as NSDictionary).value(forKey: "Code") as? String)!
            
        }else if notification.name.rawValue == "ManagerSelected"{
            let userInfo = notification.userInfo as NSDictionary? as! [String:Any]?
            managerID = ((userInfo! as NSDictionary).value(forKey: "EmpID") as? String)!
            btnManagerName.setTitle(((userInfo! as NSDictionary).value(forKey: "Name") as? String)!, for: UIControlState.normal)
        }
    }
    
    func setProfileData(dictData:NSDictionary){
        
        lblForEmail.text = dictData.value(forKey: "Email") as! String?
        lblForDateOfBirth.text = dictData.value(forKey: "DateOfBirth") as! String?
        lblForDateOfJoining.text = dictData.value(forKey: "DateOfJoining") as! String?
        lblForMaritalStatus.text = dictData.value(forKey: "MaritalStatusDesc") as! String?
        lblForDesignation.text = dictData.value(forKey: "Designation") as! String?
        
        btnManagerName.setTitle(dictData.value(forKey: "MangerName") as! String?, for: UIControlState.normal)
        btnWorkLocation.setTitle(dictData.value(forKey: "WorkLocation") as! String?, for: UIControlState.normal)
        btnOfficeLocation.setTitle(dictData.value(forKey: "OfficeLocation") as! String?, for: UIControlState.normal)
        btnOfficeLocation.backgroundColor = Constants.Cal_Cell_Gray
        
        workLocationID = (dictData.value(forKey: "OfficeIDWork") as! String?)!
        managerID = (dictData.value(forKey: "ManagerID") as! String?)!
        
        
        
        arrayForPersonalDetailsType.add(" Email")
        arrayForPersonalDetailsType.add(" Designation")
        arrayForPersonalDetailsType.add(" Date Of Birth")
        arrayForPersonalDetailsType.add(" Date Of Joining")
        arrayForPersonalDetailsType.add(" Marital Status")
        
        arrayForPersonalDetailsTypeValue.add(dictData.value(forKey: "Email") as! String)
        arrayForPersonalDetailsTypeValue.add(dictData.value(forKey: "Designation") as! String)
        arrayForPersonalDetailsTypeValue.add(dictData.value(forKey: "DateOfBirth") as! String)
        arrayForPersonalDetailsTypeValue.add(dictData.value(forKey: "DateOfJoining") as! String)
        arrayForPersonalDetailsTypeValue.add(dictData.value(forKey: "MaritalStatusDesc") as! String)
        
        
        if (dictData.value(forKey: "CompanyNameYN") as! String) == "Y"{
            arrayForPersonalDetailsType.add(" Company")
            arrayForPersonalDetailsTypeValue.add(dictData.value(forKey: "CompanyName") as! String)
        }
        if (dictData.value(forKey: "DivNameYN") as! String) == "Y"{
            arrayForPersonalDetailsType.add(" Division")
            arrayForPersonalDetailsTypeValue.add(dictData.value(forKey: "DivName") as! String)
        }
        if (dictData.value(forKey: "SubDeptNameYN") as! String) == "Y"{
            arrayForPersonalDetailsType.add(" Sub-Department")
            arrayForPersonalDetailsTypeValue.add(dictData.value(forKey: "SubDeptName") as! String)
        }
        if (dictData.value(forKey: "SubDivNameYN") as! String) == "Y"{
            arrayForPersonalDetailsType.add(" Sub-Division")
            arrayForPersonalDetailsTypeValue.add(dictData.value(forKey: "SubDivName") as! String)
        }
        
        tableVwForPersonalDetails.delegate = self
        tableVwForPersonalDetails.dataSource = self
        tableVwForPersonalDetails.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayForPersonalDetailsType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell:ProfileViewCustomCell = tableView.dequeueReusableCell(withIdentifier: "PersonalDetailsCell") as! ProfileViewCustomCell!
        
        if indexPath.row == 0 {
            scrollVwHeight.constant = scrollVwHeight.constant - personalDetailsViewHeight.constant
            personalDetailsViewHeight.constant = tableVwForPersonalDetails.contentSize.height + 10
            scrollVwHeight.constant = scrollVwHeight.constant + personalDetailsViewHeight.constant + 20
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.labelName.text = (arrayForPersonalDetailsType[indexPath.row] as! String)
        cell.valueType.text =  (arrayForPersonalDetailsTypeValue[indexPath.row] as! String)
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }

    
    @IBAction func onClickManager(_ sender: UIButton) {
        SharedManager.shareData().popupFor = "GetManager"
        self.showPopup()
    }
    
    @IBAction func onClickWorkLocation(_ sender: UIButton) {
        SharedManager.shareData().popupFor = "GetWorkLocation"
        self.showPopup()
    }
    
    func showPopup(){
    
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 400))
        present(popupViewController!, animated: false, completion: nil)
    }
    
    
    @IBAction func onClickSave(_ sender: UIButton) {
        self.getUpdateTeamMember()
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.showTeamListView()
    }
    
    func showTeamListView(){
       
        SharedManager.shareData().teamCount = 1
        let arrayForEmpID = NSMutableArray()
        arrayForEmpID.add(SharedManager.shareData().employeeID)
        SharedManager.shareData().arrayForEmpID = arrayForEmpID
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "TeamListVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }

    
    
    func getUpdateTeamMember(){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        btnSave.isEnabled = false
        btnSave.alpha = 0.5
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_EDIT_EMPLOYEE_PROFILE
        let constant = Constants()
       // let empID =  String(SharedManager.shareData().employeeIDForAttendance)
        let empID = String(format: "%@",SharedManager.shareData().arrayForEmpID.lastObject as! CVarArg)
        let parameters = constant.getEditProfileJsonData(empID: empID, managerID: managerID, workLocationID: workLocationID)
      
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let updateEmployeeDetailsResult = json["UpdateEmployeeDetailsResult"] as? [String: Any]
                let errorCode: Int = (updateEmployeeDetailsResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let refreshAlert = UIAlertController(title: "", message:"Details Updated" , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    self.showTeamListView()
                }else{
                    let errorMessage: String = (updateEmployeeDetailsResult?["ErrorMessage"] as? String)!
                    let refreshAlert = UIAlertController(title: "", message:errorMessage , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
            self.btnSave.isEnabled = true
            self.btnSave.alpha = 1.0
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
