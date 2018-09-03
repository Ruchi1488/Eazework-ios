//
//  ChangePasswordViewController.swift
//  EazeWork
//
//  Created by User1 on 5/5/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
class ChangePasswordViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var menuButton: JTHamburgerButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var txtFieldCurrentPassword: UITextField!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        buttonSubmit.backgroundColor = BUTTON_GREEN_BG_COLOR

        buttonSubmit.layer.cornerRadius = 5
        
        self.editTextField(textField: txtFieldCurrentPassword)
        self.editTextField(textField: txtFieldNewPassword)
        self.editTextField(textField: txtFieldConfirmPassword)
    }

    
    func editTextField(textField : UITextField){
        
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.clear
        textField.tintColor = TOP_COLOR
        textField.delegate = self
        let imgVw: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 30))
        imgVw.contentMode = UIViewContentMode.scaleAspectFit;
        
        textField.leftView = imgVw
        textField.leftViewMode = UITextFieldViewMode.always
        
        textField.addTarget(self, action: #selector(UIResponder.resignFirstResponder), for: UIControlEvents.editingDidEndOnExit)
        textField.autocorrectionType = UITextAutocorrectionType.no
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 10, y: textField.frame.size.height - width, width:  textField.frame.size.width-20, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = TOP_COLOR .cgColor
        border.frame = CGRect(x: 10, y: textField.frame.size.height - width, width:  textField.frame.size.width-20, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 10, y: textField.frame.size.height - width, width:  textField.frame.size.width-20, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    @IBAction func onClickMenuButton(_ sender: JTHamburgerButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    @IBAction func onClickPlusButton(_ sender: UIButton) {
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
    }
    
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
    
        if (txtFieldCurrentPassword.text?.characters.count)! > 0 && (txtFieldNewPassword.text?.characters.count)! > 0 && (txtFieldConfirmPassword.text?.characters.count)! > 0 {

            if txtFieldNewPassword.text == txtFieldConfirmPassword.text{
                self.changePassword()
            }else{
                let refreshAlert = UIAlertController(title: "", message:"New Password and Confirm Password's are not same" , preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }
        }else{
            
            var message: String = ""
            
            if (txtFieldCurrentPassword.text?.characters.count)! <= 0{
                message = "Enter Current Password"
            }else if (txtFieldNewPassword.text?.characters.count)! <= 0{
                message = "Enter New Password"
            }else if (txtFieldConfirmPassword.text?.characters.count)! <= 0{
                message = "Enter Confirm Password"
            }
            
            let refreshAlert = UIAlertController(title: "", message:message , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    
    func changePassword(){

        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_CHANGE_PASSWORD
        let constant = Constants()
        let parameters = constant.getChangePasswordJsonData(currentPassword: txtFieldCurrentPassword.text!, newPassword: txtFieldNewPassword.text!)

        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in

            if let json = response.result.value as? [String: Any] {
                let getLocationListResult = json["ChangePasswordResult"] as? [String: Any]
                let errorCode: Int = (getLocationListResult?["ErrorCode"] as? Int)!
                
                var message: String = ""
                if errorCode == 0{
                    message = "Password was changed successfully"
                    self.updateDefaults(password: self.txtFieldNewPassword.text!)
                }else{
                    message = (getLocationListResult?["ErrorMessage"] as? String)!
                }
                self.txtFieldCurrentPassword.text = ""
                self.txtFieldNewPassword.text = ""
                self.txtFieldConfirmPassword.text = ""
                let refreshAlert = UIAlertController(title: "", message:message , preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }else{
                            print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    
    func updateDefaults(password: String){
        let defaults = UserDefaults.standard
        let parameters: Parameters = [
            "loginCred": [
                "CorpUrl":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "CorpUrl") as! String),
                "Login":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Login") as! String),
                "Password":password,
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ]
        ]
        defaults.set(parameters, forKey: "User_Data")
        SharedManager.shareData().dictForUserData = (defaults.value(forKey: "User_Data") as! NSDictionary!) as! [AnyHashable : Any]!
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
