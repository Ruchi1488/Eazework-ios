//
//  AttendanceHistoryViewController.swift
//  EazeWork
//
//  Created by User1 on 5/16/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
class AttendanceHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var menuButton: JTHamburgerButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var historyTableVw: UITableView!
    
    
    var arrayForAttendanceHistory = NSArray()
    var fromDate = String()
    var toDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if  SharedManager.shareData().isSelfAttendanceHistory == 1 {
            lblForTitle.text = "Attendance History"
        }else{
           lblForTitle.text = "Member History"
        }
        
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor

        historyTableVw.delegate = self
        historyTableVw.dataSource = self
        historyTableVw.tableFooterView = UIView()
        self.getAttendanceHistory()
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForAttendanceHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AttendanceHistoryCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! AttendanceHistoryCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.lblDate.text = (arrayForAttendanceHistory[indexPath.row] as! NSDictionary).value(forKey: "MarkDate") as! String?
        cell.lblStatus.text = (arrayForAttendanceHistory[indexPath.row] as! NSDictionary).value(forKey: "StatusDesc") as! String?
        
        if !((arrayForAttendanceHistory[indexPath.row] as! NSDictionary).value(forKey: "TimeIn") is NSNull) {
           cell.lblInTime.text = (arrayForAttendanceHistory[indexPath.row] as! NSDictionary).value(forKey: "TimeIn") as! String?
        }else{
           cell.lblInTime.text = ""
        }

        if !((arrayForAttendanceHistory[indexPath.row] as! NSDictionary).value(forKey: "TimeOut") is NSNull) {
            cell.lblOutTime.text = (arrayForAttendanceHistory[indexPath.row] as! NSDictionary).value(forKey: "TimeOut") as! String?
        }else{
            cell.lblOutTime.text = ""
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       SharedManager.shareData().dictTimeLineData = arrayForAttendanceHistory[indexPath.row] as? NSDictionary as! [AnyHashable : Any]!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "TimeLineVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    func getFromToDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        //let nextMonth = formatter.defaultDate
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        fromDate = formatter.string(from: previousMonth!)
        toDate = formatter.string(from: Date())
    }
    
    func getAttendanceHistory(){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor

        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()

        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_ATTENDANCE_HISTORY
        self.getFromToDate()

        let constant = Constants()
        var empID = ""
        if  SharedManager.shareData().isSelfAttendanceHistory == 1 {
            empID = ""
        }else{
            empID = SharedManager.shareData().employeeIDForAttendance
        }
        
        
        
        let parameters = constant.getAttendanceHistoryJsonData(fromDate: fromDate, toDate: toDate, orderBy: "D",forEmpID: empID)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getEmpAttendanceCalendarStatusResult = json["GetEmpAttendanceCalendarStatusResult"] as? [String: Any]
                let errorCode: Int = (getEmpAttendanceCalendarStatusResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getEmpAttendanceCalendarStatusResult?["attendCalStatusList"] as? NSArray)!
                    self.arrayForAttendanceHistory = resultData
                    self.historyTableVw.reloadData()
                }else{
                    let refreshAlert = UIAlertController(title: "", message:(getEmpAttendanceCalendarStatusResult?["ErrorMessage"] as? String)! , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
                
            }
        }
    }

    @IBAction func onClickBack(_ sender: JTHamburgerButton) {
        
        if  SharedManager.shareData().isSelfAttendanceHistory == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
        }else{
        
            SharedManager.shareData().arrayForEmpID.removeLastObject()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "TeamListVC")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
        }
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
