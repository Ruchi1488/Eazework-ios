//
//  ViewProfileController.swift
//  EazeWork
//
//  Created by User1 on 5/4/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class ViewProfileController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewForPersonalDetails: UIView!
    @IBOutlet weak var viewForOfficialDetails: UIView!
    
    @IBOutlet weak var tableVwForOfficialDetails: UITableView!
    @IBOutlet weak var tableVwForPersonalDetails: UITableView!
    
   
    @IBOutlet weak var suportedview: UIView!
    
    @IBOutlet weak var profileHeight: NSLayoutConstraint!
    
    @IBOutlet weak var officialHeight: NSLayoutConstraint!
   
    @IBOutlet weak var scrollView: UIScrollView!
    var arrayForPersonalDetailsType = NSMutableArray()
    var arrayForPersonalDetailsTypeValue = NSMutableArray()
    
    var arrayForOfficialDetailsType = NSMutableArray()
    var arrayForOfficialDetailsTypeValue = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        viewForPersonalDetails.backgroundColor = UIColor.clear
        viewForPersonalDetails.layer.borderWidth = 1.0
        viewForPersonalDetails.layer.borderColor = UIColor.lightGray.cgColor
        viewForOfficialDetails.backgroundColor = UIColor.clear
        viewForOfficialDetails.layer.borderWidth = 1.0
        viewForOfficialDetails.layer.borderColor = UIColor.lightGray.cgColor
        
        if  SharedManager.shareData().validForSelfViewProfile == 2{
            self.setProfileData(dictData: SharedManager.shareData().dictForTeamProfileData as NSDictionary)
        }else{
            self.setProfileData(dictData: SharedManager.shareData().dictForProfileData as NSDictionary)
        }
        tableVwForPersonalDetails.estimatedRowHeight = 44
        tableVwForPersonalDetails.rowHeight = UITableViewAutomaticDimension
        tableVwForOfficialDetails.estimatedRowHeight = 44
        tableVwForOfficialDetails.rowHeight = UITableViewAutomaticDimension
    }
    
    
    func setProfileData(dictData:NSDictionary){
        //Personal Details
        if let email = dictData.value(forKey: "Email") as? String, email != "" {
            arrayForPersonalDetailsType.add(" Email")
            arrayForPersonalDetailsTypeValue.add(email)
        }
        if let dateOfBirth = dictData.value(forKey: "DateOfBirth") as? String, dateOfBirth != "" {
            arrayForPersonalDetailsType.add(" Date Of Birth")
            arrayForPersonalDetailsTypeValue.add(dateOfBirth)
        }
        if let dateOfJoining = dictData.value(forKey: "DateOfJoining") as? String, dateOfJoining != "" {
            arrayForPersonalDetailsType.add(" Date Of Joining")
            arrayForPersonalDetailsTypeValue.add(dateOfJoining)
        }
        if let marital = dictData.value(forKey: "MaritalStatusDesc") as? String,marital != "" {
            arrayForPersonalDetailsType.add(" Marital Status")
            arrayForPersonalDetailsTypeValue.add(marital)
        }
        
        //Official Details
//        if (dictData.value(forKey: "CompanyNameYN") as! String) == "Y" {
//            if let companyName = dictData.value(forKey: "CompanyName") as? String,companyName != "" {
//                
//                arrayForPersonalDetailsType.add(" Company")
//                arrayForPersonalDetailsTypeValue.add(companyName)
//            }
//        }

        
        
        if let mangerName = dictData.value(forKey: "MangerName") as? String, !mangerName.isEmpty {
            
            
            arrayForOfficialDetailsType.add(" Manager")
            arrayForOfficialDetailsTypeValue.add(mangerName)
        }
        
        //mohit - Functional Manager
        if (dictData.value(forKey: "FnMangerNameYN") as! String) == "Y"
        {
            if let FnMangerName = dictData.value(forKey: "FnMangerName") as? String, !FnMangerName.isEmpty {
                arrayForOfficialDetailsType.add(" Functional Manager")
                arrayForOfficialDetailsTypeValue.add(FnMangerName)
            }
           
        }
        if let officeLocation = dictData.value(forKey: "OfficeLocation") as? String, !officeLocation.isEmpty {
            arrayForOfficialDetailsType.add(" Office Location")
            arrayForOfficialDetailsTypeValue.add(officeLocation)
        }
        
        if (dictData.value(forKey: "WorkLocationYN") as! String) == "Y"{
            arrayForOfficialDetailsType.add(" Work Location")
            arrayForOfficialDetailsTypeValue.add(dictData.value(forKey: "WorkLocation") as! String)
        }
        
        //mohit - Dept
        if (dictData.value(forKey: "DeptNameYN") as! String) == "Y"
        {
            if let DeptName = dictData.value(forKey: "DeptName") as? String, !DeptName.isEmpty {
                arrayForOfficialDetailsType.add(" Department")
                arrayForOfficialDetailsTypeValue.add(DeptName)
            }
            
        }
        if (dictData.value(forKey: "SubDeptNameYN") as! String) == "Y"{
            if let subDeptName = dictData.value(forKey: "SubDeptName") as? String,subDeptName != "" {
                
                arrayForOfficialDetailsType.add(" Sub-Department")
                arrayForOfficialDetailsTypeValue.add(subDeptName)
                
            }
            
            
        }
        //mohit - Division
        if (dictData.value(forKey: "DivNameYN") as! String) == "Y"
        {
            if let DivName = dictData.value(forKey: "DivName") as? String, !DivName.isEmpty {
                arrayForOfficialDetailsType.add(" Division")
                arrayForOfficialDetailsTypeValue.add(DivName)
            }
            
        }
        if (dictData.value(forKey: "SubDivNameYN") as! String) == "Y"{
              if let subDeptName = dictData.value(forKey: "SubDeptName") as? String,subDeptName != "" {
                        arrayForOfficialDetailsType.add(" Sub-Division")
                       arrayForOfficialDetailsTypeValue.add(subDeptName)
                     }
        
          }
        if let employmentStatusDesc = dictData.value(forKey: "EmploymentStatusDesc") as? String, !employmentStatusDesc.isEmpty {
            
            
            arrayForOfficialDetailsType.add(" Status")
            arrayForOfficialDetailsTypeValue.add(employmentStatusDesc)
        }
        
        
        /*
         "CompanyNameYN":"N",
         "DivNameYN":"N"
         "SubDeptNameYN":"N"
         "SubDivNameYN":"N",
         "WorkLocationYN":"Y"
         */
        //
        
        
        tableVwForPersonalDetails.delegate = self
        tableVwForPersonalDetails.dataSource = self
        tableVwForPersonalDetails.reloadData()
        
        tableVwForOfficialDetails.delegate = self
        tableVwForOfficialDetails.dataSource = self
        tableVwForOfficialDetails.reloadData()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileHeight.constant = 40 + self.tableVwForPersonalDetails.contentSize.height
        officialHeight.constant = 40 + self.tableVwForOfficialDetails.contentSize.height
        suportedview.frame.size.height = profileHeight.constant +  officialHeight.constant + 40
        self.scrollView.contentSize.height = suportedview.frame.size.height + 15
        self.scrollView.contentSize.width = self.view.frame.size.width
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableVwForOfficialDetails{
            return arrayForOfficialDetailsType.count
        }
        
        return arrayForPersonalDetailsType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == tableVwForOfficialDetails{
            let cell:ProfileViewCustomCell = tableView.dequeueReusableCell(withIdentifier: "OfficialDetailsCell") as! ProfileViewCustomCell!
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.labelName.text = (arrayForOfficialDetailsType[indexPath.row] as! String)
            cell.valueType.text = (arrayForOfficialDetailsTypeValue[indexPath.row] as! String)
            return cell
        }
        
        let cell:ProfileViewCustomCell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileViewCustomCell!
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.labelName.text = (arrayForPersonalDetailsType[indexPath.row] as! String)
        cell.valueType.text =  (arrayForPersonalDetailsTypeValue[indexPath.row] as! String)
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 40
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        return UITableViewAutomaticDimension
    //    }
    
    
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

