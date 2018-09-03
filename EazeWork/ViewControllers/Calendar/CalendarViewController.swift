//
//  CalendarViewController.swift
//  EazeWork
//
//  Created by User1 on 5/18/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Alamofire
import SWActivityIndicatorView
class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarVw: JTAppleCalendarView!
    
    @IBOutlet weak var calendarTopViewSpace: NSLayoutConstraint!
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var mainContentVw: UIView!
    
    @IBOutlet weak var viewForDate: UIView!
    @IBOutlet weak var viewForInTime: UIView!
    @IBOutlet weak var viewForOutTime: UIView!
    @IBOutlet weak var calendarContentView: UIView!
    
    @IBOutlet weak var viewWeeaklyOff: UIView!
    @IBOutlet weak var viewRestrictedHoliday: UIView!
    @IBOutlet weak var viewLeave: UIView!
    @IBOutlet weak var viewAbsent: UIView!
    @IBOutlet weak var calenderTopView: UIView!
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblInTime: UILabel!
    @IBOutlet weak var lblOutTime: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    @IBOutlet weak var lblSun: UILabel!
    @IBOutlet weak var lblMon: UILabel!
    @IBOutlet weak var lblTue: UILabel!
    @IBOutlet weak var lblWed: UILabel!
    @IBOutlet weak var lblThu: UILabel!
    @IBOutlet weak var lblFri: UILabel!
    @IBOutlet weak var lblSat: UILabel!
    
    let formatter = DateFormatter()
    var testCalendar = Calendar.current
    let red = UIColor.red
    let white = UIColor.white
    let black = UIColor.black
    let gray = UIColor.gray
    
    var fromDate = String()
    var toDate = String()
    var arrayForAttendanceData = NSMutableArray()
    
    var prePostVisibility: ((CellState, CalendarCell?)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if SharedManager.shareData().calendarForLeave == 1 || SharedManager.shareData().calendarForLeave == 2 {
            scrollVw.isScrollEnabled = false
            mainContentVw.backgroundColor = UIColor.clear
            scrollVw.backgroundColor = UIColor.clear
            view.backgroundColor = UIColor.clear
            calendarTopViewSpace.constant = -100
        }else{
            scrollVw.isScrollEnabled = true
            calendarTopViewSpace.constant = 0
        }
        
        self.calendarVw.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
            if !(SharedManager.shareData().calendarForLeave == 1 || SharedManager.shareData().calendarForLeave == 2){
                self.getAttendanceStatusDate(date: (visibleDates.monthDates.first?.date)!)
                NSLog("End....")
            }
        }
        
        viewForInTime.backgroundColor = BUTTON_RED_BG_COLOR
        viewForOutTime.backgroundColor = BUTTON_RED_BG_COLOR
        
        calendarContentView.layer.borderWidth = 0.3
        calendarContentView.layer.borderColor = UIColor.lightGray.cgColor
        calendarVw.minimumLineSpacing = 0
        calendarVw.minimumInteritemSpacing = 0
        
        calendarVw.scrollToHeaderForDate(Date())
        
        self.setUpDate(date: Date())
        
        viewWeeaklyOff.backgroundColor = Constants.Primary_Blue
        viewRestrictedHoliday.backgroundColor = Constants.Primary_Blue_Light
        viewLeave.backgroundColor = Constants.Primary_Pink
        viewAbsent.backgroundColor = Constants.Primary_Dark
        calenderTopView.backgroundColor = Constants.Cal_Top
        
        lblSun.backgroundColor = Constants.Cal_Top
        lblMon.backgroundColor = Constants.Cal_Top
        lblTue.backgroundColor = Constants.Cal_Top
        lblWed.backgroundColor = Constants.Cal_Top
        lblThu.backgroundColor = Constants.Cal_Top
        lblFri.backgroundColor = Constants.Cal_Top
        lblSat.backgroundColor = Constants.Cal_Top
        
        lblSun.textColor = Constants.Primary_Blue
        lblSat.textColor = Constants.Primary_Blue
        
        lblMon.textColor = Constants.Cal_Cell_Gray
        lblTue.textColor = Constants.Cal_Cell_Gray
        lblWed.textColor = Constants.Cal_Cell_Gray
        lblThu.textColor = Constants.Cal_Cell_Gray
        lblFri.textColor = Constants.Cal_Cell_Gray
        
        NSLog("Started....")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickLeft(_ sender: UIButton) {
        calendarVw.scrollToSegment(.previous)
    }
    
    @IBAction func onClickRight(_ sender: UIButton) {
        calendarVw.scrollToSegment(.next)
    }
    
    func setUpDate(date: Date){
        var day = testCalendar.dateComponents([.weekday], from: date).weekday!
        let dayName = DateFormatter().weekdaySymbols[(day-1) % 7]
        day = testCalendar.dateComponents([.day], from: date).day!
        lblDay.text = String(day) + dayName
        lblDay.text = String(day) + "\n" + dayName
}
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = testCalendar.component(.year, from: startDate)
        lblMonth.text = monthName + " " + String(year)
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellTextColor(view: cell, cellState: cellState)
        prePostVisibility?(cellState, cell as? CalendarCell)
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CalendarCell  else {
            return
        }
        
        if cellState.isSelected {
          //  myCustomCell.dayLabel.textColor = white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = black
                myCustomCell.backgroundColor = white
            } else {
                myCustomCell.dayLabel.textColor = black
                myCustomCell.backgroundColor = Constants.Cal_Cell_Gray
            }
        }
        
        if testCalendar.isDateInToday(cellState.date) {
           myCustomCell.dayLabel.textColor = BUTTON_RED_BG_COLOR
            myCustomCell.dayLabel.font = UIFont.boldSystemFont(ofSize: 22)
        }else{
             myCustomCell.dayLabel.font = UIFont.systemFont(ofSize: 14)
        }
        
        myCustomCell.bottomView.isHidden = true
        myCustomCell.statusLabel.isHidden = true

        if !(SharedManager.shareData().calendarForLeave == 1 || SharedManager.shareData().calendarForLeave == 2){
        
        
        if self.arrayForAttendanceData.count > 0 {
            if cellState.dateBelongsTo == .thisMonth {
                 for i in (0..<self.arrayForAttendanceData.count){
                    let status = (self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "Status") as! String
                    let markDate = (self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "MarkDate") as! String
                    formatter.dateFormat = "dd/MM/yyyy"
                    let endDate = formatter.string(from: cellState.date)
                    
                    if testCalendar.isDateInToday(formatter.date(from: markDate)!) {
                        if !((self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "TimeIn") is NSNull){
                            lblInTime.text = (self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "TimeIn") as! String?
                        }else{
                            lblInTime.text = "--:--"
                        }
                        
                        if !((self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "TimeOut") is NSNull){
                            lblOutTime.text = (self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "TimeOut") as! String?
                        }else{
                            lblOutTime.text = "--:--"
                        }
                    }
                    
                    if endDate ==  markDate {
                        if (status == "0"){
                            myCustomCell.bottomView.backgroundColor = UIColor.clear
                        }else if(status == "3"){
                            myCustomCell.bottomView.isHidden = false
                            myCustomCell.bottomView.backgroundColor = Constants.Primary_Blue
                        }else if(status == "1" || status == "2"){
                            myCustomCell.bottomView.isHidden = false
                            myCustomCell.bottomView.backgroundColor = Constants.Primary_Pink
                        }else if(status == "7"){
                            myCustomCell.bottomView.isHidden = false
                            myCustomCell.statusLabel.isHidden = false
                            myCustomCell.bottomView.backgroundColor = Constants.Primary_Dark
                        }
                    }
                }
            } else {
                myCustomCell.bottomView.isHidden = true
                myCustomCell.statusLabel.isHidden = true
            }
        }else{
            myCustomCell.bottomView.isHidden = true
            myCustomCell.statusLabel.isHidden = true
        }
        }
}
    
 /*   // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CalendarCell else {return }
//                switch cellState.selectedPosition() {
//                case .full:
//                    myCustomCell.backgroundColor = .green
//                case .left:
//                    myCustomCell.backgroundColor = .yellow
//                case .right:
//                    myCustomCell.backgroundColor = .red
//                case .middle:
//                    myCustomCell.backgroundColor = .blue
//                case .none:
//                    myCustomCell.backgroundColor = nil
//                }
//        
        if cellState.isSelected {
//             CustomCell.selectedView.layer.cornerRadius =  13
//              CustomCell.selectedView.isHidden = false
        } else {
            //CustomCell.selectedView.isHidden = true
        }
    }*/
    
    
    func getFromToDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let nextMonth =  Calendar.current.date(byAdding: .month, value: 24, to: Date())
        let previousMonth = Calendar.current.date(byAdding: .month, value: -24, to: Date())
        fromDate = formatter.string(from: previousMonth!)
        toDate = formatter.string(from: nextMonth!)
    }
    
    
    func getAttendanceHistory(fromDate: String, toDate: String){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_ATTENDANCE_HISTORY
        
        let constant = Constants()
        let parameters = constant.getAttendanceHistoryJsonData(fromDate: fromDate, toDate: toDate, orderBy: "A", forEmpID: "")
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getEmpAttendanceCalendarStatusResult = json["GetEmpAttendanceCalendarStatusResult"] as? [String: Any]
                let errorCode: Int = (getEmpAttendanceCalendarStatusResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getEmpAttendanceCalendarStatusResult?["attendCalStatusList"] as? NSArray)!
                    self.arrayForAttendanceData = resultData.mutableCopy() as! NSMutableArray
                    self.calendarVw.reloadData()
                }else{
//                    let refreshAlert = UIAlertController(title: "", message:(getEmpAttendanceCalendarStatusResult?["ErrorMessage"] as? String)! , preferredStyle: UIAlertControllerStyle.alert)
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                    }))
//                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func getAttendanceStatusDate(date: Date){
       
        let month = testCalendar.dateComponents([.month], from: date).month!
        let year = testCalendar.component(.year, from: date)
        let day = testCalendar.dateComponents([.day], from: date).day!
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        self.getAttendanceHistory(fromDate: String(format:"%i/%i/%i",day,month,year), toDate: String(format:"%i/%i/%i",range.count,month,year))
    }
    
    func getInTimeOutTime(cellState: CellState){
        
        if self.arrayForAttendanceData.count > 0 {
            if cellState.dateBelongsTo == .thisMonth {
                for i in (0..<self.arrayForAttendanceData.count){
//                    let status = (self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "Status") as! String
                    let markDate = (self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "MarkDate") as! String
                    formatter.dateFormat = "dd/MM/yyyy"
                    let endDate = formatter.string(from: cellState.date)
                    if endDate ==  markDate {
                       // if status == "0" {
                            
                            if !((self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "TimeIn") is NSNull){
                                lblInTime.text = (self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "TimeIn") as! String?
                            }else{
                                lblInTime.text = "--:--"
                            }
                            
                            if !((self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "TimeOut") is NSNull){
                                lblOutTime.text = (self.arrayForAttendanceData.object(at:i) as! NSDictionary).value(forKey: "TimeOut") as! String?
                            }else{
                                lblOutTime.text = "--:--"
                            }
                        //}
                    }
                }
            }
        }

    }
    
}


extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = testCalendar.timeZone
        formatter.locale = testCalendar.locale
        self.getFromToDate()
        let startDate = formatter.date(from: fromDate)!
        let endDate = formatter.date(from: toDate)!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CalendarCustomCell", for: indexPath) as! CalendarCell
        
        myCustomCell.dayLabel.text = cellState.text
        
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)

        myCustomCell.layer.borderWidth = 0.5
        myCustomCell.layer.borderColor = UIColor.lightGray.cgColor
        
        //NSLog("%i", indexPath.row)
        
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
        self.setUpDate(date: date)
        
        if SharedManager.shareData().calendarForLeave == 1 || SharedManager.shareData().calendarForLeave == 2{
            
            let name:NSNotification.Name = NSNotification.Name("DateSelected")
            let dictLeave = NSMutableDictionary()
            dictLeave.setValue(date, forKey: "date")
            
            NotificationCenter.default.post(name: name,
                                            object: self,
                                            userInfo: ((dictLeave ) as! [AnyHashable : Any]))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseView"),
                                            object: nil,
                                            userInfo: nil)

        }else{
            self.getInTimeOutTime(cellState: cellState)
        }
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        let startDate = visibleDates.monthDates.first?.date
         if !(SharedManager.shareData().calendarForLeave == 1 || SharedManager.shareData().calendarForLeave == 2){
            self.getAttendanceStatusDate(date: startDate!)
        }
        self.setupViewsOfCalendar(from: visibleDates)
}
    
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        let visibleDates = calendarVw.visibleDates()
        //        let dateWeShouldNotCross = formatter.date(from: "2017 08 07")!
        //        let dateToScrollBackTo = formatter.date(from: "2017 07 03")!
        //        if visibleDates.monthDates.contains (where: {$0.date >= dateWeShouldNotCross}) {
        //            calendarView.scrollToDate(dateToScrollBackTo)
        //            return
        //        }
        self.setupViewsOfCalendar(from: visibleDates)
    }
}
