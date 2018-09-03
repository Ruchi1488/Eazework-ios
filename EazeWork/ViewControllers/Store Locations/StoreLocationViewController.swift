//
//  StoreLocationViewController.swift
//  EazeWork
//
//  Created by User1 on 5/22/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView

class StoreLocationViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var menuButton: JTHamburgerButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayForLocationData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.getLocationsData()
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForLocationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:StoreLocationCustomCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! StoreLocationCustomCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = .disclosureIndicator
       
        cell.lblLocationName.text = (arrayForLocationData[indexPath.row] as! NSDictionary).value(forKey: "OfficeName") as! String?
        
        cell.lblLocationCode.text = (arrayForLocationData[indexPath.row] as! NSDictionary).value(forKey: "OfficeCode") as! String?
        
         cell.lblEmployeeCount.text = (arrayForLocationData[indexPath.row] as! NSDictionary).value(forKey: "EmpCount") as! String?
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        SharedManager.shareData().isEditOrCreateLocation = 1
        SharedManager.shareData().officeIDForDetails = (arrayForLocationData[indexPath.row] as! NSDictionary).value(forKey: "OfficeID") as! String?
        //CreateEditLocVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "CreateEditLocVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }

    @IBAction func onClickPlus(_ sender: UIButton) {
        SharedManager.shareData().popupFor=""
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: true) {
            //do something
        }
    }
    
    @IBAction func onClickBack(_ sender: JTHamburgerButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    
    func getLocationsData(){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_LOCATION_LIST
        
        let constant = Constants()
       let parameters = constant.getLocationsJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getLocationListResult = json["GetLocationListResult"] as? [String: Any]
                let errorCode: Int = (getLocationListResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getLocationListResult?["list"] as? NSArray)!
                    self.arrayForLocationData = resultData
                    self.tableView.reloadData()
                }else{
                    let refreshAlert = UIAlertController(title: "", message:(getLocationListResult?["ErrorMessage"] as? String)! , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
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
