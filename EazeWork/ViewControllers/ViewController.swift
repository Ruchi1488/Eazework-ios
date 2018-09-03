//
//  ViewController.swift
//  EazeWork
//
//  Created by User1 on 5/3/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
import Crashlytics
import GoogleSignIn


//Url - t*trl
//
//Username - admin
//
//Password - a12345

class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var viewForInputBackground: UIView!
    @IBOutlet weak var textFieldForURL: UITextField!
    @IBOutlet weak var textFieldForUsername: UITextField!
    @IBOutlet weak var textFieldForPassword: UITextField!
    @IBOutlet weak var btnForLogin: UIButton!
    @IBOutlet weak var labelForRegisterDemo: UILabel!
    @IBOutlet weak var imgBtnForPasswordView:UIImageView!
    
    @IBOutlet weak var imageVwForDataLoad: UIImageView!
    
    @IBOutlet weak var btnGmaiLogin: GIDSignInButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        imageVwForDataLoad.isHidden = false
        
        self.btnForLogin.backgroundColor = BUTTON_GREEN_BG_COLOR
        self.btnForLogin.layer.cornerRadius = 8
        self.view.backgroundColor = UIColor(red: (227/255.0), green: (228/255.0), blue: (228/255.0), alpha: 1.0)
        
        self.editTextField(textField: self.textFieldForURL)
        self.editTextField(textField: self.textFieldForUsername)
        self.editTextField(textField: self.textFieldForPassword)
        let defaults = UserDefaults.standard
        
      
        var error: NSError?
        if(error != nil){
            print("Error is:",error!)
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
       // self.btnGmaiLogin.layer.cornerRadius = 8
        
//        let signInBTN = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 370, height: 65))
       // signInBTN.center = view.center
        //view.addSubview(btnGmaiLogin)
        
        if Connectivity.isConnectedToInternet() {
            if  defaults.bool(forKey: "Is_Login"){
                imageVwForDataLoad.isHidden = false
                self.validateLogin()
            }else{
                imageVwForDataLoad.isHidden = true
            }
        }else{
            imageVwForDataLoad.isHidden = true
            let refreshAlert = UIAlertController(title: "", message:"Internet connection not available" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (textFieldForURL.text?.characters.count)! == 0 {
            let refreshAlert = UIAlertController(title: "", message:"Please Enter URL" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
            return
        } else{
            if error != nil{
                print(" google error is",error)
                return
            }
            
            print("Email id :",user.profile.email)
            let gmailIdToken: String = user.authentication.idToken // Safe to send to the server
            print("Google Token1",gmailIdToken)
            
            self.disabelSaveButton()
            let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            self.view.addSubview(activityIndicatorView)
            
            activityIndicatorView.lineWidth = 2
            activityIndicatorView.autoStartAnimating = true
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.color = TOP_COLOR
            activityIndicatorView.center = self.view.center
            activityIndicatorView.startAnimating()
            
            var corpURL: String = textFieldForURL.text!
            
            let defaults = UserDefaults.standard
            
            if (textFieldForURL.text?.contains("t*"))! || (textFieldForURL.text?.contains("T*"))! {
                let index: String.Index = corpURL.index(corpURL.startIndex, offsetBy: 2)
                corpURL = corpURL.substring(from: index)
                defaults.set(Constants.TEST_MODE, forKey: "BaseURL")
                SharedManager.shareData().base_URL = Constants.TEST_MODE
            }else if(textFieldForURL.text?.contains("s*"))! || (textFieldForURL.text?.contains("S*"))! {
                let index: String.Index = corpURL.index(corpURL.startIndex, offsetBy: 2)
                corpURL = corpURL.substring(from: index)
                defaults.set(Constants.STAGING_MODE, forKey: "BaseURL")
                SharedManager.shareData().base_URL = Constants.STAGING_MODE
            }else{
                defaults.set(Constants.PRODUCTION_MODE, forKey: "BaseURL")
                SharedManager.shareData().base_URL = Constants.PRODUCTION_MODE
            }
            
            let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_LOGIN_GOOGLE
            print("Google login url:",urlPath)
            
            let constant = Constants()
            
            let parameters = constant.getLoginGoogleJsonData(corpURL: corpURL, gmailToken: gmailIdToken, fcmToken: "ab")
            
            print("parameters : \(parameters)")
            
            
            Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                
                activityIndicatorView.stopAnimating()
                if let statusCode = response.response?.statusCode {
                    print("statusCode : \(statusCode)")
                }
                
                if let json = response.result.value as? [String: Any] {
                    
                    print("response : \(json)")
                    
                    
                    let logInUserResult = json["LoginUserWithGoogleResult"] as? [String: Any]
                    let errorCode: Int = (logInUserResult?["ErrorCode"] as? Int)!
                    
                    if errorCode == 0{
                        
                        let sessionID: String = (logInUserResult?["SessionID"] as? String)!
                        let loggedInUser = logInUserResult?["LoggedInUser"] as? [String: Any]
                        let empID: Int  = (loggedInUser?["EmpID"] as? Int
                            )!
                        let loginName = (loggedInUser?["Login"] as? String
                            )!
                        defaults.set(sessionID, forKey: "SessionID")
                        defaults.set(empID, forKey: "EmpID")
                        defaults.set(true, forKey: "Is_Login")
                        defaults.set(loginName, forKey: "Login")
                        defaults.set(parameters, forKey: "User_Data")
                        
                        
                        //self.logUser(empID: String(empID), empNameURL: String(format:"%@/%@",SharedManager.shareData().base_URL,self.textFieldForUsername.text!))
                        
                        self.logUser(empID: String(empID), empNameURL: String(format:"%@/%@",SharedManager.shareData().base_URL,loginName))
                       
                        self.getEmployeeData()
                        
                    }else if errorCode == -9 {
                        self.enableSaveButton()
                        if let errorMessage: String = (logInUserResult?["ErrorMessage"] as? String) {
                            
                            self.showVersionControll(errorMsg: errorMessage)
                        }
                    }
                        
                    else
                    {
                        if let errorMessage: String = (logInUserResult?["ErrorMessage"] as? String) {
                            
                            let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
                            
                            let ok = UIAlertAction(title: "OK", style: .default) { _ in
                                print("pressed")
                            }
                            alert.addAction(ok)
                            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                            
                        }
                        self.enableSaveButton()
                        
                    }
                }
                    
                else{
                    self.enableSaveButton()
                    
                    
                }
            }
        }
    
        // Sign out
        GIDSignIn.sharedInstance().signOut()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if Connectivity.isConnectedToInternet()  == true {
            
        }else{
            imageVwForDataLoad.isHidden = true
            let refreshAlert = UIAlertController(title: "", message:"Internet connection not available" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    
    
    func editTextField(textField : UITextField){
        
        textField.backgroundColor = UIColor.clear
        textField.tintColor = SharedManager.shareData().headerBGColor
        
        let imgVw: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        if textField == self.textFieldForURL {
            imgVw.image = UIImage(named:"link_url")
        }else if textField == self.textFieldForUsername{
            imgVw.image = UIImage(named:"icon_user")
        }else if textField == self.textFieldForPassword{
            imgVw.image = UIImage(named:"icon_password")
            let paddingView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
            textField.rightView = paddingView
            textField.rightViewMode = UITextFieldViewMode.always
        }
        imgVw.contentMode = UIViewContentMode.scaleAspectFit;
        textField.leftView = imgVw
        textField.leftViewMode = UITextFieldViewMode.always
        
        textField.addTarget(self, action: #selector(UIResponder.resignFirstResponder), for: UIControlEvents.editingDidEndOnExit)
        textField.autocorrectionType = UITextAutocorrectionType.no
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        //        imgBtnForPasswordView.image = UIImage.init(named: "plus")
        textFieldForPassword.isSecureTextEntry = false
    }
    
    @IBAction func hidePassword(_ sender: UIButton) {
        //        imgBtnForPasswordView.image = UIImage.init(named: "show_pws")
        textFieldForPassword.isSecureTextEntry = true
    }
    
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        
        
        
        if (textFieldForURL.text?.characters.count)! > 0 &&
            (textFieldForUsername.text?.characters.count)! > 0 &&
            (textFieldForPassword.text?.characters.count)! > 0{
            
            
            if Connectivity.isConnectedToInternet()  == true{
                self.getLogin()
            }else{
                let refreshAlert = UIAlertController(title: "", message:"Internet connection not available" , preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }
        }else{
            let refreshAlert = UIAlertController(title: "", message:"Please Enter All Fields" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onClickRegisterDemo(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "http://www.eazework.com/contact-us/request-a-demo.aspx")!)
    }
    
    
    func getLogin(){
        self.disabelSaveButton()
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = TOP_COLOR
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        var corpURL: String = textFieldForURL.text!
        
        let defaults = UserDefaults.standard
        
        if (textFieldForURL.text?.contains("t*"))! || (textFieldForURL.text?.contains("T*"))! {
            let index: String.Index = corpURL.index(corpURL.startIndex, offsetBy: 2)
            corpURL = corpURL.substring(from: index)
            defaults.set(Constants.TEST_MODE, forKey: "BaseURL")
            SharedManager.shareData().base_URL = Constants.TEST_MODE
        }else if(textFieldForURL.text?.contains("s*"))! || (textFieldForURL.text?.contains("S*"))! {
            let index: String.Index = corpURL.index(corpURL.startIndex, offsetBy: 2)
            corpURL = corpURL.substring(from: index)
            defaults.set(Constants.STAGING_MODE, forKey: "BaseURL")
            SharedManager.shareData().base_URL = Constants.STAGING_MODE
        }else{
            defaults.set(Constants.PRODUCTION_MODE, forKey: "BaseURL")
            SharedManager.shareData().base_URL = Constants.PRODUCTION_MODE
        }
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_LOGIN
        
        let constant = Constants()
        
        let parameters = constant.getLoginJsonData(corpURL: corpURL, username: textFieldForUsername.text!, password: textFieldForPassword.text!)
        
        print("parameters : \(parameters)")

        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            activityIndicatorView.stopAnimating()
            if let statusCode = response.response?.statusCode {
                print("statusCode : \(statusCode)")
            }
          
            if let json = response.result.value as? [String: Any] {
                
                print("response : \(json)")

                
                let logInUserResult = json["LogInUserResult"] as? [String: Any]
                let errorCode: Int = (logInUserResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    let sessionID: String = (logInUserResult?["SessionID"] as? String)!
                    let loggedInUser = logInUserResult?["LoggedInUser"] as? [String: Any]
                    let empID  = (loggedInUser?["EmpID"] as? Int
                        )!
                    defaults.set(sessionID, forKey: "SessionID")
                    defaults.set(empID, forKey: "EmpID")
                    defaults.set(true, forKey: "Is_Login")
                    defaults.set(parameters, forKey: "User_Data")
                    
                    self.logUser(empID: String(empID), empNameURL: String(format:"%@/%@",SharedManager.shareData().base_URL,self.textFieldForUsername.text!))
                    self.getEmployeeData()
                    
                }else if errorCode == -9 {
                    self.enableSaveButton()
                    if let errorMessage: String = (logInUserResult?["ErrorMessage"] as? String) {
                        
                        self.showVersionControll(errorMsg: errorMessage)
                    }
                }
                    
                    else
                    {
                        if let errorMessage: String = (logInUserResult?["ErrorMessage"] as? String) {
                            
                            let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
                            
                            let ok = UIAlertAction(title: "OK", style: .default) { _ in
                                print("pressed")
                            }
                            alert.addAction(ok)
                            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                            
                        }
                        self.enableSaveButton()

                    }
                }
            
            else{
                self.enableSaveButton()
                

            }
        }
    }
    
    // Login via gmail
    @IBAction func gmailLogin(_ sender: GIDSignInButton) {
        
        if (textFieldForURL.text?.characters.count)! < 1{
            let refreshAlert = UIAlertController(title: "", message:"Please Enter URL" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        } else{
        self.disabelSaveButton()
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = TOP_COLOR
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        var corpURL: String = textFieldForURL.text!
        
        let defaults = UserDefaults.standard
        
        if (textFieldForURL.text?.contains("t*"))! || (textFieldForURL.text?.contains("T*"))! {
            let index: String.Index = corpURL.index(corpURL.startIndex, offsetBy: 2)
            corpURL = corpURL.substring(from: index)
            defaults.set(Constants.TEST_MODE, forKey: "BaseURL")
            SharedManager.shareData().base_URL = Constants.TEST_MODE
        }else if(textFieldForURL.text?.contains("s*"))! || (textFieldForURL.text?.contains("S*"))! {
            let index: String.Index = corpURL.index(corpURL.startIndex, offsetBy: 2)
            corpURL = corpURL.substring(from: index)
            defaults.set(Constants.STAGING_MODE, forKey: "BaseURL")
            SharedManager.shareData().base_URL = Constants.STAGING_MODE
        }else{
            defaults.set(Constants.PRODUCTION_MODE, forKey: "BaseURL")
            SharedManager.shareData().base_URL = Constants.PRODUCTION_MODE
        }
          
            let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_LOGIN_GOOGLE
            
            let constant = Constants()
            
            let parameters = constant.getLoginGoogleJsonData(corpURL: corpURL, gmailToken: "", fcmToken: "ab")
            
            print("parameters : \(parameters)")
            
            
            Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                
                activityIndicatorView.stopAnimating()
                if let statusCode = response.response?.statusCode {
                    print("statusCode : \(statusCode)")
                }
                
                if let json = response.result.value as? [String: Any] {
                    
                    print("response : \(json)")
                    
                    
                    let logInUserResult = json["LogInUserResult"] as? [String: Any]
                    let errorCode: Int = (logInUserResult?["ErrorCode"] as? Int)!
                    
                    if errorCode == 0{
                        let sessionID: String = (logInUserResult?["SessionID"] as? String)!
                        let loggedInUser = logInUserResult?["LoggedInUser"] as? [String: Any]
                        let empID: Int  = (loggedInUser?["EmpID"] as? Int
                            )!
                        defaults.set(sessionID, forKey: "SessionID")
                        defaults.set(empID, forKey: "EmpID")
                        defaults.set(true, forKey: "Is_Login")
                        defaults.set(parameters, forKey: "User_Data")
                        
                        self.logUser(empID: String(empID), empNameURL: String(format:"%@/%@",SharedManager.shareData().base_URL,self.textFieldForUsername.text!))
                        self.getEmployeeData()
                        
                    }else if errorCode == -9 {
                        self.enableSaveButton()
                        if let errorMessage: String = (logInUserResult?["ErrorMessage"] as? String) {
                            
                            self.showVersionControll(errorMsg: errorMessage)
                        }
                    }
                        
                    else
                    {
                        if let errorMessage: String = (logInUserResult?["ErrorMessage"] as? String) {
                            
                            let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
                            
                            let ok = UIAlertAction(title: "OK", style: .default) { _ in
                                print("pressed")
                            }
                            alert.addAction(ok)
                            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                            
                        }
                        self.enableSaveButton()
                        
                    }
                }
                    
                else{
                    self.enableSaveButton()
                    
                    
                }
            }
        }
    }
    
    func validateLogin(){
        
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = TOP_COLOR
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        
        let defaults = UserDefaults.standard
        
        SharedManager.shareData().base_URL = defaults.value(forKey: "BaseURL") as! String!
        SharedManager.shareData().sessionID = defaults.value(forKey: "SessionID") as! String!
        SharedManager.shareData().dictForUserData = (defaults.value(forKey: "User_Data") as! NSDictionary!) as! [AnyHashable : Any]!
        print(SharedManager.shareData().dictForUserData)
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_VALIDATE_LOGIN
        
        let constant = Constants()
        let parameters = constant.getValidateLoginJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                
                let logInUserResult = json["ValidateLogInResult"] as? [String: Any]
                let errorCode: Int = (logInUserResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    let sessionID: String = (logInUserResult?["SessionID"] as? String)!
                    let loggedInUser = logInUserResult?["LoggedInUser"] as? [String: Any]
                    let empID : Int = (loggedInUser?["EmpID"] as? Int
                        )!
                    let empLogin : String = (loggedInUser?["Login"] as? String
                        )!
                    defaults.set(sessionID, forKey: "SessionID")
                    defaults.set(empID, forKey: "EmpID")
                    defaults.set(true, forKey: "Is_Login")
                    self.logUser(empID: String(empID), empNameURL: String(format: "%@/%@",SharedManager.shareData().base_URL,empLogin))
                    self.getEmployeeData()
                    
                }
                else if errorCode == -999 {
                    self.getLogout();
                }
                else{
                    self.imageVwForDataLoad.isHidden = true
                    let errorMessage: String = (logInUserResult?["ErrorMessage"] as? String)!
                    let refreshAlert = UIAlertController(title: "", message:errorMessage , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }else{
                self.imageVwForDataLoad.isHidden = true
            }
        }
    }
    
    func logUser(empID: String, empNameURL: String) {
        
        NSLog("Employee ID--%@", empID)
        NSLog("Emp Name URL ID--%@", empNameURL)
        // Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
        Crashlytics.sharedInstance().setUserIdentifier(empID)
        Crashlytics.sharedInstance().setUserName(empNameURL)
    }
    
    
    
    
    func getEmployeeData(){
        
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = TOP_COLOR
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let defaults = UserDefaults.standard
        
        SharedManager.shareData().base_URL = defaults.value(forKey: "BaseURL") as! String!
        SharedManager.shareData().sessionID = defaults.value(forKey: "SessionID") as! String!
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_EMPLOYEE_PROFILE
        
        let constant = Constants()
        let parameters = constant.getValidateLoginJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let empProfileResult = json["EmpProfileResult"] as? [String: Any]
                let errorCode: Int = (empProfileResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    let dictEmployeeData: NSDictionary = (empProfileResult as? NSDictionary as! [AnyHashable : Any]! as NSDictionary)
                    SharedManager.shareData().dictEmployeeProfile = (dictEmployeeData as? NSDictionary as! [AnyHashable : Any]!)
                }
                else if errorCode == -999 {
                    self.getLogout();
                }

                else{
                    
                }
                self.getMenuData()
                
            }else{
                self.imageVwForDataLoad.isHidden = true
            }
        }
    }
    
    func getMenuData(){
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_MENU_DATA
        
        let constant = Constants()
        let parameters = constant.getMenuJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                
                let getMenuDataResult = json["GetMenuDataResult"] as? [String: Any]
                let errorCode: Int = (getMenuDataResult?["ErrorCode"] as? Int)!
                
                if errorCode == 0{
                    let resultData: NSArray = (getMenuDataResult?["menuDataList"] as? NSArray)!
                    let saveArray = NSMutableArray()
                    for dictData in resultData{
                        if ((dictData as! NSDictionary).value(forKey: "AccessYN") as! NSString).isEqual(to: "Y"){
                            let menuItemName: NSString = ((dictData as! NSDictionary).value(forKey: "ObjecID") as! NSString)
                            saveArray.add(menuItemName)
                        }
                    }
                    SharedManager.shareData().getEmpProfileData = 1
                    self.imageVwForDataLoad.isHidden = true
                    SharedManager.shareData().arrayForMenuData = resultData as? NSArray as! [Any]!
                    SharedManager.shareData().arrayForMenuDescript = saveArray
                    SharedManager.shareData().validForSelfViewProfile = 1
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                }
                else if errorCode == -999 {
                    self.getLogout();
                }
                else if errorCode == -9 {
                    self.enableSaveButton()
                    self.imageVwForDataLoad.isHidden = true
                    
                    let errorMessage: String = (getMenuDataResult?["ErrorMessage"] as? String)!
                    
                    self.showVersionControll(errorMsg: errorMessage)
                }
            }else{
                self.enableSaveButton()
                self.imageVwForDataLoad.isHidden = true
            }
        }
    }
    
    
    func enableSaveButton(){
        self.btnForLogin.isEnabled = true
        self.btnForLogin.alpha = 1.0
    }
    
    func disabelSaveButton(){
        self.btnForLogin.isEnabled = false
        self.btnForLogin.alpha = 0.5
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getLogout()
    {
        let defaults = UserDefaults.standard
        // Sign out from Google account
        // GIDSignIn.sharedInstance().signOut()
        defaults.set(false, forKey: "Is_Login")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "RootVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    
    }
    
    
    func showVersionControll(errorMsg: String) {
        let alert = UIAlertController(title: nil, message: errorMsg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            self.doSomething()
        }
        alert.addAction(ok)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
    }
    
    func doSomething() {
        //Use action.title
        print("pressed")
        
        let urlString = "https://itunes.apple.com/in/app/eazehr-hr-and-payroll/id1244641344?mt=8"
        guard let url = URL(string: urlString) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

