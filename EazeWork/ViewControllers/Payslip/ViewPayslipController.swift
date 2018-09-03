//
//  ViewPayslipController.swift
//  EazeWork
//
//  Created by User1 on 5/15/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
class ViewPayslipController: UIViewController,HADropDownDelegate {

    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var menuButton: JTHamburgerButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var txtFieldMonth: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    var arrayForPayslip = NSArray()
    var indexForMonth = NSInteger()
    @IBOutlet weak var dropDownView: HADropDown!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getLastPaySlipMonth()
        
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        buttonSubmit.backgroundColor = BUTTON_GREEN_BG_COLOR
        
        buttonSubmit.layer.cornerRadius = 5
        buttonSubmit.setTitle("View", for: UIControlState.normal)
        self.editTextField(textField: txtFieldPassword)
        self.editTextField(textField: txtFieldMonth)
        
       // dropDownView.items = ["Cat", "Mouse", "Horse", "Elephant", "Dog", "Zebra"]
        
    }
    


    func didSelectItem(dropDown: HADropDown, at index: Int) {
        dropDownView.title = (self.arrayForPayslip[index] as? NSDictionary)!.value(forKey: "MonthDesc") as! String
        indexForMonth = index
    }

    
    func editTextField(textField : UITextField){
        
        textField.backgroundColor = UIColor.clear
        textField.tintColor = TOP_COLOR
        //textField.delegate = self
        let imgVw: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 30))
        imgVw.contentMode = UIViewContentMode.scaleAspectFit;
        
        textField.leftView = imgVw
        textField.leftViewMode = UITextFieldViewMode.always
        
        textField.addTarget(self, action: #selector(UIResponder.resignFirstResponder), for: UIControlEvents.editingDidEndOnExit)
        textField.autocorrectionType = UITextAutocorrectionType.no
       textField.isUserInteractionEnabled = false
        if textField == self.txtFieldPassword{
            textField.isSecureTextEntry = true
            textField.isUserInteractionEnabled = true
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor.lightGray.cgColor
            border.frame = CGRect(x: 10, y: textField.frame.size.height - width, width:  textField.frame.size.width-20, height: textField.frame.size.height)
            
            border.borderWidth = width
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
        }
    }

    
    
    func getLastPaySlipMonth(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_SALARY_SLIP_MONTHS

        let constant = Constants()
        let parameters = constant.getMenuJsonData()

        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let salaryMonthResult = json["SalaryMonthResult"] as? [String: Any]
                let errorCode: Int = (salaryMonthResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (salaryMonthResult?["Months"] as? NSArray)!
                    let arrayData: NSArray = (resultData as NSArray) as! [Any] as NSArray
                    self.arrayForPayslip = arrayData
                    NSLog("%@",self.arrayForPayslip)
                    self.dropDownView.title = String(format: "%@", (arrayData[0] as! NSDictionary).value(forKey: "MonthDesc") as! CVarArg)
                    SharedManager.shareData().paySlipMonthName = String(format: "%@", (arrayData[0] as! NSDictionary).value(forKey: "MonthDesc") as! CVarArg)
                    self.indexForMonth = 0
                    self.dropDownView.delegate = self
                    for i in (0..<self.arrayForPayslip.count){
                        self.dropDownView.items.append((self.arrayForPayslip[i] as? NSDictionary)!.value(forKey: "MonthDesc") as! String)
                    }
                }else{
                    
                }
            }
        }
    }
     
    @IBAction func onClickSelectMonth(_ sender: UIButton) {
    
    }
    
    @IBAction func onClickBackButton(_ sender: JTHamburgerButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }

    @IBAction func onClickPlus(_ sender: UIButton) {
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
    }
    
    
    @IBAction func onClickView(_ sender: UIButton) {
        
        if (txtFieldPassword.text?.characters.count)! > 0 {
            self.validatePassword()
        }else{
            let refreshAlert = UIAlertController(title: "", message:"Enter Password To Validate" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)

        }
    }
    
    func validatePassword(){
        //FILE_GET_VALIDATE_PASSWORD
        buttonSubmit.isEnabled = false
        buttonSubmit.alpha = 0.5
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor

        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_VALIDATE_PASSWORD
        
        let constant = Constants()
        let parameters = constant.getValidatePasswordJsonData(password: self.txtFieldPassword.text!)
    
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let validatePasswordResult = json["ValidatePasswordResult"] as? [String: Any]
                let errorCode: Int = (validatePasswordResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    self.getPaySlip()
                }else{
                    self.buttonSubmit.isEnabled = true
                    self.buttonSubmit.alpha = 1.0
                    let refreshAlert = UIAlertController(title: "", message:(validatePasswordResult?["ErrorMessage"] as? String)! , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                }
            }else{
                self.buttonSubmit.isEnabled = true
                self.buttonSubmit.alpha = 1.0

            }
        }
    }

    func getPaySlip(){
        
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor

        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_SALARY_SLIP

        let constant = Constants()
        let parameters = constant.getPayslipJsonData(month: (self.arrayForPayslip[indexForMonth] as? NSDictionary)!.value(forKey: "Month") as! String)
       
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let salarySlipDataResult = json["SalarySlipDataResult"] as? [String: Any]
                let errorCode: Int = (salarySlipDataResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
               //PayslipVC
                    
                    SharedManager.shareData().dictForPayslipData = json["SalarySlipDataResult"] as? NSDictionary as! [AnyHashable : Any]!
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "PayslipVC")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                }else{
                    let refreshAlert = UIAlertController(title: "", message:(salarySlipDataResult?["ErrorMessage"] as? String)! , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
            self.buttonSubmit.isEnabled = true
            self.buttonSubmit.alpha = 1.0
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
