//
//  TimeLineViewController.swift
//  EazeWork
//
//  Created by User1 on 5/16/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
import SDWebImage
import Agrume

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var menuButton: JTHamburgerButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTimeIn: UILabel!
    @IBOutlet weak var lblTimeOut: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var historyTableVw: UITableView!
    
    @IBOutlet weak var timeInImageView: UIImageView!
    @IBOutlet weak var timeOutImageView: UIImageView!
    @IBOutlet weak var timeIn: UILabel!
    @IBOutlet weak var timeOut: UILabel!
    
    
    var dictOfTimeLine = NSDictionary()
    var arrayOfTimeLineData = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideSelfieImages()
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        
        
        if !((SharedManager.shareData().dictTimeLineData as NSDictionary).value(forKey: "TimeIn") is NSNull) {
            lblTimeIn.text = String(format:"In-Time     : %@",((SharedManager.shareData().dictTimeLineData as NSDictionary).value(forKey: "TimeIn") as! String?)!)
        }else{
            lblTimeIn.text = "In-Time     :"
        }
        
        if !((SharedManager.shareData().dictTimeLineData as NSDictionary).value(forKey: "TimeOut") is NSNull) {
            lblTimeOut.text = String(format:"Out-Time  : %@",((SharedManager.shareData().dictTimeLineData as NSDictionary).value(forKey: "TimeOut") as! String?)!)
        }else{
            lblTimeOut.text = "Out-Time  :"
        }
        
        lblDate.text = ((SharedManager.shareData().dictTimeLineData as NSDictionary).value(forKey: "MarkDate") as! String?)!
        
        let status = ((SharedManager.shareData().dictTimeLineData as NSDictionary).value(forKey: "StatusDesc") as! String?)!
        
        lblStatus.text = status as String!
        lblStatus.textAlignment = NSTextAlignment.right
        
        historyTableVw.delegate = self
        historyTableVw.dataSource = self
        historyTableVw.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //        timeIn.isHidden = true
        //        timeOut.isHidden = true
        //        timeInImageView.isHidden = true
        //        timeOutImageView.isHidden = true
        
        self.getAttendanceHistory()
        
        
        timeInImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.gestureHandlerMethod))
        timeInImageView.addGestureRecognizer(tapRecognizer)
        
        
        timeOutImageView.isUserInteractionEnabled = true
        let tapRecognizerTimeOut = UITapGestureRecognizer(target: self, action: #selector(self.gestureHandlerTimeOut(sender:)))
        timeOutImageView.addGestureRecognizer(tapRecognizerTimeOut)
        
    }
    
    @objc func gestureHandlerMethod(sender:UITapGestureRecognizer){
        let agrume = Agrume(image: timeInImageView.image!, backgroundColor: .black)
        agrume.showFrom(self)
    }
    
    @objc func gestureHandlerTimeOut(sender:UITapGestureRecognizer){
        let agrume = Agrume(image: timeOutImageView.image!, backgroundColor: .black)
        agrume.showFrom(self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTimeLineData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TimeLineCustomCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as! TimeLineCustomCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if indexPath.row  == 0 {
            cell.topVerticalLine.isHidden = true
        }else if indexPath.row  == arrayOfTimeLineData.count - 1{
            cell.bottomVerticalLine.isHidden = true
        }
        
        let color = UIColor.darkGray
        
        cell.topVerticalLine.backgroundColor = color
        cell.bottomVerticalLine.backgroundColor = color
        cell.lblStatus.textColor = color
        cell.separatorLine.backgroundColor = color
        cell.lblTime.textColor = color
        
        let status = (arrayOfTimeLineData[indexPath.row] as! NSDictionary).value(forKey: "TypeDesc") as! String?
        cell.lblStatus.text = status
        
        if status == "In-Time" {
            cell.statusIcon.image = #imageLiteral(resourceName: "dot_login")
        }else if status == "Break-In" || status == "Location-In" {
            cell.statusIcon.image = #imageLiteral(resourceName: "dot_breakin")
        }else if status == "Break-Out" || status == "Location-Out"{
            cell.statusIcon.image = #imageLiteral(resourceName: "dot_breakout")
        }else if status == "Out-Time" {
            cell.statusIcon.image = #imageLiteral(resourceName: "dot_timeout")
        }
        
        var timeStamp = ""
        
        if !((arrayOfTimeLineData[indexPath.row] as! NSDictionary).value(forKey: "TimeStamp") is NSNull) && ((arrayOfTimeLineData[indexPath.row] as! NSDictionary).value(forKey: "TimeStamp") as! String).characters.count > 0{
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a xxxx"
            let showDate = inputFormatter.date(from: ((arrayOfTimeLineData[indexPath.row] as! NSDictionary).value(forKey: "TimeStamp") as! String?)!)
            inputFormatter.dateFormat = "hh:mm a"
            timeStamp = inputFormatter.string(from: showDate!)
        }
        
        cell.lblTime.text = timeStamp
        return cell
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
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_ATTENDANCE_TIME_LINE
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let showDate = inputFormatter.date(from: ((SharedManager.shareData().dictTimeLineData as NSDictionary).value(forKey: "MarkDate") as! String?)!)
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        
        let constant = Constants()
        
        var empID = ""
        if  SharedManager.shareData().isSelfAttendanceHistory == 1 {
            empID = String(SharedManager.shareData().employeeID)
        }else{
            empID = SharedManager.shareData().employeeIDForAttendance
        }
        
        let parameters = constant.getTimeLineJsonData(markDate: resultString, empID: empID)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getAttendanceTimeLineResult = json["GetAttendanceTimeLineResult"] as? [String: Any]
                print(json)
                let errorCode: Int = (getAttendanceTimeLineResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    
                    let resultData: NSArray = (getAttendanceTimeLineResult?["attendanceTimeLine"]
                        as? NSArray)!

                    let selfieYN = getAttendanceTimeLineResult?["SelfieYN"] as? String
                    
                    if selfieYN == "Y"{
                        self.showSelfieImages()
                    }else{
                        self.hideSelfieImages()
                    }
                    
                    
                    if !(resultData.object(at: 0) is NSNull) {
                        self.arrayOfTimeLineData = resultData
                        
                        var logoURL: NSString = (getAttendanceTimeLineResult?["ImagePath"] as? String)! as NSString
                        if !(logoURL is NSNull){
                            self.timeInImageView.sd_setImage(with: URL(string: String(format:"%@%@",SharedManager.shareData().base_URL,logoURL)), placeholderImage: UIImage(named: "na"))
                        }
                        
                        logoURL = (getAttendanceTimeLineResult?["ImagePathOut"] as? String)! as NSString
                        
                        if !(logoURL is NSNull){
                            self.timeOutImageView.sd_setImage(with: URL(string: String(format:"%@%@",SharedManager.shareData().base_URL,logoURL)), placeholderImage: UIImage(named: "na"))
                        }
                    }else{
                        
                    }
                    self.historyTableVw.reloadData()
                }else{
                    let refreshAlert = UIAlertController(title: "", message:(getAttendanceTimeLineResult?["ErrorMessage"] as? String)! , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    func showSelfieImages(){
        self.timeIn.isHidden = false
        self.timeOut.isHidden = false
        self.timeInImageView.isHidden = false
        self.timeOutImageView.isHidden = false
    }
    
    func hideSelfieImages(){
        self.timeIn.isHidden = true
        self.timeOut.isHidden = true
        self.timeInImageView.isHidden = true
        self.timeOutImageView.isHidden = true
    }
    
    @IBAction func onClickBack(_ sender: JTHamburgerButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "AttendanceHistoryVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
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
