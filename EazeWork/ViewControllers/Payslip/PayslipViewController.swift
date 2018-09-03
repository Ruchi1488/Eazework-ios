//
//  PayslipViewController.swift
//  EazeWork
//
//  Created by User1 on 5/15/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
import PDFReader
class PayslipViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var menuButton: JTHamburgerButton!
    
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var lblPayableDays: UILabel!
    @IBOutlet weak var lblLWP: UILabel!
    @IBOutlet weak var lblEarningHeader: UILabel!
    @IBOutlet weak var lblDeductionHeader: UILabel!
    @IBOutlet weak var lblTotalEarnigs: UILabel!
    @IBOutlet weak var lblTotalDeductions: UILabel!
    @IBOutlet weak var lblNetSalary: UILabel!
    
    @IBOutlet weak var btnDownload: UIButton!
    
    @IBOutlet weak var earningTableView: UITableView!
    @IBOutlet weak var deductionTableView: UITableView!
    
    @IBOutlet weak var deductionTableVwHeight: NSLayoutConstraint!
    @IBOutlet weak var earningTableVwHieght: NSLayoutConstraint!
    
    @IBOutlet weak var contentVwHeight: NSLayoutConstraint!
    
    var arrayForEarning = NSMutableArray()
    var arrayForDeduction = NSMutableArray()

    var docController:UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        
        lblForTitle.text = "Payslip" + " " + SharedManager.shareData().paySlipMonthName
        btnDownload.backgroundColor = BUTTON_GREEN_BG_COLOR
        btnDownload.layer.cornerRadius = 5
        
        lblTotalEarnigs.text = String(format:"%@",((SharedManager.shareData().dictForPayslipData as NSDictionary).value(forKey: "GrossPay") as! String?)!)
        lblTotalDeductions.text = String(format:"%@",((SharedManager.shareData().dictForPayslipData as NSDictionary).value(forKey: "GrossDeduction") as! String?)!)
        lblNetSalary.text = String(format:"Net Salary:  %@",((SharedManager.shareData().dictForPayslipData as NSDictionary).value(forKey: "NetSalary") as! String?)!)
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: String(format:"Payable Days : %@",((SharedManager.shareData().dictForPayslipData as NSDictionary).value(forKey: "PayableDays") as! String?)!), attributes: nil)
        myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 15), range: NSRange(location:0,length:14))
        lblPayableDays.attributedText = myMutableString

        
        myMutableString = NSMutableAttributedString(string: String(format:"LWP : %@",((SharedManager.shareData().dictForPayslipData as NSDictionary).value(forKey: "LWP") as! String?)!), attributes: nil)
        myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 15), range: NSRange(location:0,length:5))
        lblLWP.attributedText = myMutableString
        
        let arrayTemp = (SharedManager.shareData().dictForPayslipData as NSDictionary).object(forKey: "data") as! NSArray
        NSLog("%@", (SharedManager.shareData().dictForPayslipData as NSDictionary))
        for i in (0..<arrayTemp.count){
            if (arrayTemp[i] as! NSDictionary).value(forKey: "HeadType") as! String == "E" {
                arrayForEarning.add(arrayTemp[i] as! NSDictionary)
            }else{
                arrayForDeduction.add(arrayTemp[i] as! NSDictionary)
            }
        }
        
        
        earningTableView.delegate = self
        earningTableView.dataSource = self
        
        deductionTableView.delegate = self
        deductionTableView.dataSource = self
        
        lblEarningHeader.layer.borderWidth = 0.5
        lblEarningHeader.layer.borderColor = UIColor.lightGray.cgColor
        lblDeductionHeader.layer.borderWidth = 0.5
        lblDeductionHeader.layer.borderColor = UIColor.lightGray.cgColor
        earningTableView.layer.borderWidth = 0.5
        earningTableView.layer.borderColor = UIColor.lightGray.cgColor
        deductionTableView.layer.borderWidth = 0.5
        deductionTableView.layer.borderColor = UIColor.lightGray.cgColor
    }

    
    override func viewWillAppear(_ animated: Bool){
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //EarningCell
    
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == earningTableView {
            count = arrayForEarning.count
        }else if tableView == deductionTableView{
            count = arrayForDeduction.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == earningTableView {
            
        
        let cell:EarningDeductionCell = tableView.dequeueReusableCell(withIdentifier: "EarningCell") as! EarningDeductionCell!
        if (indexPath.row == 0){
            earningTableVwHieght.constant = earningTableView.contentSize.height + 10
            contentVwHeight.constant = 290 + earningTableVwHieght.constant + deductionTableVwHeight.constant
        }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lblType.text = (arrayForEarning[indexPath.row] as! NSDictionary).value(forKey: "CorpHeadName") as! String?
            cell.lblTypeValue.text = (arrayForEarning[indexPath.row] as! NSDictionary).value(forKey: "Amount") as! String?
            return cell
        }
        
        let cell:EarningDeductionCell = tableView.dequeueReusableCell(withIdentifier: "DeductionCell") as! EarningDeductionCell!
        
        if (indexPath.row == 0){
            deductionTableVwHeight.constant = deductionTableView.contentSize.height + 10
            contentVwHeight.constant = 290 + earningTableVwHieght.constant + deductionTableVwHeight.constant
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.lblType.text = (arrayForDeduction[indexPath.row] as! NSDictionary).value(forKey: "CorpHeadName") as! String?
        cell.lblTypeValue.text = (arrayForDeduction[indexPath.row] as! NSDictionary).value(forKey: "Amount") as! String?
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == earningTableView {
//
//            var sizingCell: EarningDeductionCell? = nil
//        //var onceToken: Int
//       // if (onceToken == 0) {
//            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
//            sizingCell = earningTableView.dequeueReusableCell(withIdentifier: "EarningCell") as! EarningDeductionCell?
//        //}
//       // onceToken = 1
//        sizingCell?.lblType.text = (arrayForEarning[indexPath.row] as! NSDictionary).value(forKey: "CorpHeadName") as! String?
//        sizingCell?.setNeedsLayout()
//        sizingCell?.layoutIfNeeded()
//        let size: CGSize? = sizingCell?.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        return (size?.height)!
//        }
//        
//        var sizingCell: EarningDeductionCell? = nil
//        //var onceToken: Int
//      //  if (onceToken == 0) {
//            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
//            sizingCell = deductionTableView.dequeueReusableCell(withIdentifier: "DeductionCell") as! EarningDeductionCell?
//        //}
//       // onceToken = 1
//        sizingCell?.lblType.text
//            = (arrayForDeduction[indexPath.row] as! NSDictionary).value(forKey: "CorpHeadName") as! String?
//        sizingCell?.setNeedsLayout()
//        sizingCell?.layoutIfNeeded()
//        let size: CGSize? = sizingCell?.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        return (size?.height)!
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickDownload(_ sender: UIButton) {
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        btnDownload.isEnabled = false
        btnDownload.alpha = 0.5
        
        let urlString = String(format:"%@%@",SharedManager.shareData().base_URL,((SharedManager.shareData().dictForPayslipData as NSDictionary).value(forKey: "SalarySlipPath") as! String?)!)
        NSLog("%@", urlString)
        btnDownload.isEnabled = true
        btnDownload.alpha = 1.0
        activityIndicatorView.stopAnimating()
        //UIApplication.shared.openURL(NSURL(string: urlString)! as URL)
        
       
        let remotePDFDocumentURL = URL(string: urlString)!
        let document = PDFDocument(url: remotePDFDocumentURL)!
        
        let button = JTHamburgerButton()
        button.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        button.addTarget(self, action: #selector(PayslipViewController.myCancelFunc), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        let barButton = UIBarButtonItem(customView: button)
        
        let titleString = "Payslip" + " " + SharedManager.shareData().paySlipMonthName

        
        let readerController = PDFViewController.createNew(with: document, title: titleString, actionStyle: .activitySheet, backButton: barButton, isThumbnailsEnabled: false)
        readerController.backgroundColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : SharedManager.shareData().headerTextColor]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = SharedManager.shareData().headerBGColor
        navigationController?.pushViewController(readerController, animated: true)
        
//        let urlPath : NSURL! = NSURL.fileURL(withPath: urlString) as NSURL!
//        self.docController = UIDocumentInteractionController(url: urlPath as URL)
//        self.docController.uti = "com.apple.ibooks"
//        let url = NSURL(string:"itms-books://itunes.apple.com/de/book/marchen/id436945766");
        
       
     //   UIApplication.shared.openURL(urlPath as URL)
        
//        if UIApplication.shared.canOpenURL(url! as URL) {
//            btnDownload.isEnabled = true
//            btnDownload.alpha = 1.0
//            activityIndicatorView.stopAnimating()
//            
//           // self.docController!.presentOpenInMenu(from: sender.frame, in: self.view, animated: true)
//           
//        }else{
//            btnDownload.isEnabled = true
//            btnDownload.alpha = 1.0
//            activityIndicatorView.stopAnimating()
//        }
        
    }

    
    @objc func myCancelFunc(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickBack(_ sender: JTHamburgerButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "ViewPayslipVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    @IBAction func onClickPlus(_ sender: UIButton) {
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
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
