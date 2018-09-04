//
//  CreateEditLocationViewController.swift
//  EazeWork
//
//  Created by User1 on 5/22/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
import SDWebImage
import Agrume
import CoreLocation
import AMTagListView


class CreateEditLocationViewController: UIViewController, UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var viewForTopView       :UIView!
    @IBOutlet weak var lblForTitle          :UILabel!
    
    @IBOutlet weak var txtFieldName         :UITextField!
    @IBOutlet weak var txtFieldOfficeType   :UITextField!
    @IBOutlet weak var txtFieldCode         :UITextField!
    @IBOutlet weak var txtFieldPhoneNumber  :UITextField!
    @IBOutlet weak var txtFieldCity         :UITextField!
    @IBOutlet weak var txtFieldState        :UITextField!
    @IBOutlet weak var txtFieldCountry      :UITextField!
    @IBOutlet weak var txtFieldPincode      :UITextField!
    @IBOutlet weak var txtFieldLatitude     :UITextField!
    @IBOutlet weak var txtFieldLongitude    :UITextField!
    
    @IBOutlet weak var txtViewAddressOne    :UITextView!
    @IBOutlet weak var txtViewAddressTwo    :UITextView!
    
    @IBOutlet weak var cameraBtn            :UIButton!
    @IBOutlet weak var saveBtn              :UIButton!
    @IBOutlet weak var officeTypeBtn        :UIButton!
    @IBOutlet weak var locationImageVw      :UIImageView!
    
    @IBOutlet weak var viewPlus             :UIView!
    @IBOutlet weak var viewForTagList       :AMTagListView!
    @IBOutlet weak var contentVwHeight      :NSLayoutConstraint!
    
    var locationManager                     :CLLocationManager!
    var mappingMemberCode                   :String!
    var mappingMeberArray                   = NSMutableArray()
    var countryCode                         = String()
    var stateCode                           = String()
    var officeType                          = String()
    var isImageCaptured                     = Bool()
    var isLocationImageValid                = Bool()
    var imageDataToSend                     = NSData()
    var geoLocationName                     = String()
    var officeTypeCountCheck                = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mappingMemberCode = ""
    
        let amTagVw = AMTagView.appearance()
        amTagVw.innerTagColor = Constants.Cal_Cell_Gray
        amTagVw.tagColor = UIColor.clear
        amTagVw.textColor = UIColor.black
        amTagVw.radius = 10
        amTagVw.accessoryImage = #imageLiteral(resourceName: "icon_profile")

        
        viewPlus.layer.cornerRadius = viewPlus.frame.size.height/2
        viewPlus.layer.masksToBounds = true
        
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        
        self.editTextField(textField: txtFieldName, isEditable: true)
        self.editTextField(textField: txtFieldOfficeType, isEditable: true)
        
        //OfficeCodeSM
        
        let officeCodeSM:String  = (SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "OfficeCodeSM") as! String
        
        if officeCodeSM == "S"{
            self.editTextField(textField: txtFieldCode, isEditable: false)
        }else{
            self.editTextField(textField: txtFieldCode, isEditable: true)
        }
        
        self.editTextField(textField: txtFieldPhoneNumber, isEditable: true)
        self.editTextField(textField: txtFieldCity, isEditable: false)
        self.editTextField(textField: txtFieldState, isEditable: false)
        self.editTextField(textField: txtFieldCountry, isEditable: false)
        self.editTextField(textField: txtFieldPincode, isEditable: false)
        self.editTextField(textField: txtFieldLatitude, isEditable: false)
        self.editTextField(textField: txtFieldLongitude, isEditable: false)
        
        self.setTextViewBottomLine(txtView: txtViewAddressOne, lineColor: UIColor.lightGray)
        self.setTextViewBottomLine(txtView: txtViewAddressTwo, lineColor: UIColor.lightGray)
        
        txtFieldPhoneNumber.keyboardType = UIKeyboardType.numberPad
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationCallback(_:)),
                                               name: NSNotification.Name(rawValue: "OfficeTypeSelected"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationCallback(_:)),
                                               name: NSNotification.Name(rawValue: "MappingMemberSelected"),
                                               object: nil)
        
        if SharedManager.shareData().isEditOrCreateLocation == 1 {
            officeTypeBtn.isEnabled = false
            self.editTextField(textField: txtFieldOfficeType, isEditable: false)
            self.getLocationDetails()
            lblForTitle.text = "Edit Location"
        }else{
            lblForTitle.text = "Create Location"
            txtViewAddressOne.textColor = UIColor.lightGray
            txtViewAddressTwo.textColor = UIColor.lightGray
            officeTypeCountCheck = false
            self.getOfficeTypeData()
        }
    }
    
    @objc func notificationCallback(_ notification: NSNotification){
        
        if notification.name.rawValue == "OfficeTypeSelected" {
            let userInfo = notification.userInfo as NSDictionary? as! [String:Any]?
            txtFieldOfficeType.text = (userInfo! as NSDictionary).value(forKey: "Value") as? String
            officeType = ((userInfo! as NSDictionary).value(forKey: "Code") as? String)!
            

        }else if notification.name.rawValue == "MappingMemberSelected"{
            let userInfo = notification.userInfo as NSDictionary? as! [String:Any]?
            let value = (userInfo! as NSDictionary).value(forKey: "Value") as? String
        
            var isValid = Bool()
            isValid = true
            
            if mappingMeberArray.count > 0{
                for i in (0..<mappingMeberArray.count){
                   let memberCode = (mappingMeberArray.object(at:i) as! NSDictionary).value(forKey: "Code") as! String
                    if memberCode == (userInfo! as NSDictionary).value(forKey: "Code") as? String  {
                        isValid = false
                    }
                }
            }
            
            if isValid{
                mappingMeberArray.add(userInfo! as NSDictionary)
                viewForTagList.addTag(value)
                self.contentVwHeight.constant = self.contentVwHeight.constant + self.viewForTagList.contentSize.height
            }
            }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Address 1" || textView.text == "Address 2"{
            textView.text = ""
        }
                    textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.characters.count <= 0{
            if textView == txtViewAddressOne{
                txtViewAddressOne.text = "Address 1"
            }else{
                txtViewAddressTwo.text = "Address 2"
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  textField != txtFieldPhoneNumber{ return true }
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 10
    }
    
    func editTextField(textField : UITextField, isEditable : Bool){
         
        textField.tintColor = SharedManager.shareData().headerBGColor
        textField.delegate = self
        let imgVw: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 30))
        imgVw.contentMode = UIViewContentMode.scaleAspectFit;
        textField.leftView = imgVw
        textField.leftViewMode = UITextFieldViewMode.always
        textField.addTarget(self, action: #selector(UIResponder.resignFirstResponder), for: UIControlEvents.editingDidEndOnExit)
        textField.autocorrectionType = UITextAutocorrectionType.no

        if isEditable{
            textField.backgroundColor = UIColor.clear
            self.setTextFieldBottomLine(txtField: textField, lineColor: UIColor.lightGray)
        }else{
            textField.backgroundColor = Constants.Cal_Cell_Gray
            textField.isUserInteractionEnabled = false
        }
    }
    
    func setTextFieldBottomLine(txtField: UITextField, lineColor: UIColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = lineColor.cgColor
        border.frame = CGRect(x: 10, y: txtField.frame.size.height - width, width:  txtField.frame.size.width-20, height: txtField.frame.size.height)
        border.borderWidth = width
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true
    }
    
    func setTextViewBottomLine(txtView: UITextView, lineColor: UIColor){
        
        txtView.delegate = self
        txtView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = lineColor.cgColor
        border.frame = CGRect(x: 10, y: txtView.frame.size.height - width, width:  txtView.frame.size.width-20, height: txtView.frame.size.height)
        border.borderWidth = width
        txtView.layer.addSublayer(border)
        txtView.layer.masksToBounds = true
    }
    
    @IBAction func onClickCameraBtn(_ sender: UIButton) {
        
        if SharedManager.shareData().isEditOrCreateLocation == 1 {
            if !isLocationImageValid{
                self.openCamera()
            }else{
                let agrume = Agrume(image: locationImageVw.image!, backgroundColor: .black)
                agrume.showFrom(self)
            }
        }else{
            self.openCamera()
        }
}

    @IBAction func onClickOfficeType(_ sender: UIButton) {
        if officeTypeCountCheck{
                    SharedManager.shareData().popupFor = "OfficeType"
                    let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
                    let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
            
            present(popupViewController!, animated: true, completion: {
                //do something
            })
        }
    }
    
    func getOfficeTypeData(){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_TYPE_WISE
        let constant = Constants()
        var parameters = Parameters()
        parameters = constant.getTypeWiseListJsonData(fieldCode: "ddLocationTypeSMList",refCode: "")
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getTypeWiseListResult = json["GetTypeWiseListResult"] as? [String: Any]
                let errorCode: Int = (getTypeWiseListResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getTypeWiseListResult?["list"] as? NSArray)!
                    NSLog("%@", resultData)
                    if resultData.count == 1 {
                        self.txtFieldOfficeType.text = (resultData.object(at: 0) as! NSDictionary).value(forKey: "Value") as! String?
                        self.officeType = (resultData.object(at: 0) as! NSDictionary).value(forKey: "Code") as! String
                    }else if resultData.count > 1{
                        self.officeTypeCountCheck = true
                        SharedManager.shareData().arrayForOfficeType = resultData as? NSArray as! [Any]!
                    }else{
                        
                    }
                }else{
                }
            }
        }

    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.showLocationsView()
    }
    
    @IBAction func onClickSave(_ sender: UIButton) {
        
        if (txtFieldName.text?.characters.count)! > 0 && (txtFieldOfficeType.text?.characters.count)! > 0  && (txtFieldPhoneNumber.text?.characters.count)! > 0 && !((txtFieldPhoneNumber.text?.characters.count)! != 10) {
            self.disabelSaveButton()
            self.submitLocation()
        }else{
            if (txtFieldName.text?.characters.count)! <= 0{
                self.showAlert(message: "Enter office name")
            }else if (txtFieldOfficeType.text?.characters.count)! <= 0{
                self.showAlert(message: "Select office type")
            }else if (txtFieldPhoneNumber.text?.characters.count)! <= 0{
                self.showAlert(message: "Enter phone number")
            }else if !((txtFieldPhoneNumber.text?.characters.count)! != 10){
                self.showAlert(message: "Enter valid phone number")
            }
        }
    }
    
    func showLocationsView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "StoreLocationVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    func getLocationDetails(){
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_LOCATION_DETAILS
        
        let constant = Constants()
        let parameters = constant.getLocationDetailsJsonData(officeID: SharedManager.shareData().officeIDForDetails)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getLocationDetailsResult = json["GetLocationDetailsResult"] as? [String: Any]
                let errorCode: Int = (getLocationDetailsResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSDictionary = (getLocationDetailsResult?["locationDetail"] as? NSDictionary)!
                    
                    
                    self.setLocationDetails(dictData: resultData)
                    self.getMappedEmployeeList()
                }else{
                    self.showAlert(message: (getLocationDetailsResult?["ErrorMessage"] as? String)!)
                }
            }
        }
    }
    
    
    
    func getMappedEmployeeList(){
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_TYPE_WISE
        
        let constant = Constants()
        let parameters = constant.getTypeWiseListJsonData(fieldCode: "ddLocationMappedEmpList", refCode: SharedManager.shareData().officeIDForDetails)
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let getTypeWiseListResult = json["GetTypeWiseListResult"] as? [String: Any]
                let errorCode: Int = (getTypeWiseListResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    let resultData: NSArray = (getTypeWiseListResult?["list"] as? NSArray)!
                    
                    if (resultData.count > 0){

                        for i in (0..<resultData.count){
                            self.viewForTagList.addTag((resultData.object(at:i) as! NSDictionary).value(forKey: "Value") as! String)
                        }
                        self.contentVwHeight.constant = self.contentVwHeight.constant + self.viewForTagList.contentSize.height
                    }
                }else{
                    
                }
            }
        }
    }
    
    func setLocationDetails(dictData: NSDictionary)  {
        NSLog("%@", dictData)
        txtFieldName.text = dictData.value(forKey: "OfficeName") as! String?
        txtFieldOfficeType.text = dictData.value(forKey: "OfficeTypeDesc") as! String?
        txtFieldCode.text = dictData.value(forKey: "OfficeCode") as! String?
        txtFieldPhoneNumber.text = dictData.value(forKey: "PhoneNo") as! String?
        txtFieldCity.text = dictData.value(forKey: "City") as! String?
        txtFieldState.text = dictData.value(forKey: "State") as! String?
        txtFieldCountry.text = dictData.value(forKey: "Country") as! String?
        txtFieldPincode.text = dictData.value(forKey: "PinCode") as! String?
        txtFieldLatitude.text = dictData.value(forKey: "Latitude") as! String?
        txtFieldLongitude.text = dictData.value(forKey: "Longitude") as! String?

        txtViewAddressOne.text = dictData.value(forKey: "Address1") as! String?
        if txtViewAddressOne.text.characters.count <= 0 {
            txtViewAddressOne.text = "Address 1"
            txtViewAddressOne.textColor = UIColor.lightGray
        }

        txtViewAddressTwo.text = dictData.value(forKey: "Address2") as! String?
        
        if txtViewAddressTwo.text.characters.count <= 0 {
            txtViewAddressTwo.text = "Address 2"
            txtViewAddressTwo.textColor = UIColor.lightGray
        }
        
        if (txtViewAddressOne.text == "Address1" || txtViewAddressOne.text == "Address 1"){
            txtViewAddressOne.textColor = UIColor.lightGray
        }
        
        if (txtViewAddressTwo.text == "Address2" || txtViewAddressTwo.text == "Address 2"){
            txtViewAddressTwo.textColor = UIColor.lightGray
        }
        
        

        
        countryCode = (dictData.value(forKey: "CountryCode") as! String?)!
        stateCode = (dictData.value(forKey: "StateCode") as! String?)!
        
        officeType = (dictData.value(forKey: "OfficeType") as! String?)!
        
        if (dictData.value(forKey: "CountryCode") as! String).characters.count <= 0{
            countryCode = (dictData.value(forKey: "Country") as! String?)!
        }
        
        if (dictData.value(forKey: "StateCode") as! String).characters.count <= 0{
            stateCode = (dictData.value(forKey: "State") as! String?)!
        }
        
        if dictData.value(forKey: "OfficeCodeSM") as! String == "S"{
            txtFieldCode.isUserInteractionEnabled = false
            txtFieldCode.backgroundColor = Constants.Cal_Cell_Gray
        }
        
        var logoURL: NSString = (dictData.value(forKey: "Photo") as! String) as NSString
        if !(logoURL is NSNull) && logoURL.length > 0{
            isLocationImageValid = true
            self.locationImageVw.sd_setImage(with: URL(string: String(format:"%@%@",SharedManager.shareData().base_URL,logoURL)), placeholderImage: UIImage(named: "camera"))
        }else{
            self.locationImageVw.image = UIImage(named: "camera")
            isLocationImageValid = false
        }
    }
    
    func openCamera(){
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        locationImageVw.image = image!
        var imageData = UIImageJPEGRepresentation(image!, 0)
        imageDataToSend = self.compressImage(image: image!)

        if SharedManager.shareData().isEditOrCreateLocation != 1{
            let container = ExifContainer()
            let currentLocation = self.getCurrentLocation()
            let altitudeSF = 15.0;
            let accuracyHorizontal = 1.0;
            let accuracyVertical = 1.0;
            let location = CLLocation.init(coordinate: currentLocation, altitude: altitudeSF, horizontalAccuracy: accuracyHorizontal, verticalAccuracy: accuracyVertical, timestamp: Date())
            container.add(location)
            //self.getLocationDeatails(locatonCoordinate: currentLocation)
            self.getGeoLocationDeatails(locationCoordinate: currentLocation)
            imageDataToSend = UIImage(data:imageDataToSend as Data)!.addExif(container) as NSData!
        }
        isImageCaptured = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func compressImage(image:UIImage) -> NSData {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 200.0
        let maxWidth : CGFloat = 200.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        var maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        
        let rect = CGRect(x:0.0, y:0.0, width:actualWidth, height:actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
        UIGraphicsEndImageContext();
        return imageData as NSData!
    }


    func getLocationDeatails(locatonCoordinate: CLLocationCoordinate2D){
        
        let location = CLLocation(latitude: locatonCoordinate.latitude, longitude: locatonCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
               
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
               // print(pm.addressDictionary as Any)
                let locData : NSDictionary = (pm.addressDictionary as? NSDictionary)!
                self.txtFieldCity.text = locData.value(forKey: "City") as! String?
                self.txtFieldState.text = locData.value(forKey: "State") as! String?
                self.txtFieldCountry.text = locData.value(forKey: "Country") as! String?
                self.txtFieldPincode.text = locData.value(forKey: "ZIP") as! String?
                self.txtFieldLatitude.text = String(locatonCoordinate.latitude)
                self.txtFieldLongitude.text = String(locatonCoordinate.longitude)
                self.countryCode = (locData.value(forKey: "CountryCode") as! String?)!
                self.stateCode = (locData.value(forKey: "State") as! String?)!
                
                //self.geoLocationName = (pm.addressDictionary?["FormattedAddressLines"] as! NSArray).componentsJoined(by: ",")
                self.txtViewAddressOne.text = self.geoLocationName
            }else {
               
            }
        })
    }
    
    
    func getGeoLocationDeatails(locationCoordinate: CLLocationCoordinate2D){
        self.txtFieldLatitude.text = String(locationCoordinate.latitude)
        self.txtFieldLongitude.text = String(locationCoordinate.longitude)

        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = String(format: "https://maps.googleapis.com/maps/api/geocode/json?&latlng=%f,%f&language=en-IN",locationCoordinate.latitude,locationCoordinate.longitude)
    
        Alamofire.request(urlPath, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                let resultData: NSArray = (json["results"] as? NSArray)!
                self.parseCurrentLocation(arrayOfLocData: resultData)
            }
        }
    }

    
    
    func parseCurrentLocation(arrayOfLocData: NSArray){
        
        let geoLocationArray = NSMutableArray()
        
        self.geoLocationName = (arrayOfLocData.object(at: 0) as! NSDictionary).value(forKey: "formatted_address") as! String
        let arrayOfAddress = (arrayOfLocData.object(at: 0) as! NSDictionary).value(forKey: "address_components") as! NSArray
        for dictData in arrayOfAddress {
            if ((dictData as! NSDictionary).value(forKey: "types") as! NSArray).count > 0{
                for stringData in ((dictData as! NSDictionary).value(forKey: "types") as! NSArray){
                    if(stringData as! String) == "premise" || (stringData as! String) == "sublocality_level_1" || (stringData as! String) == "sublocality_level_2" || (stringData as! String) == "route" {
                        
                        if ((dictData as! NSDictionary).value(forKey: "long_name")) != nil{
                            if ((dictData as! NSDictionary).value(forKey: "long_name") as! String).characters.count > 0{
                                geoLocationArray.add(((dictData as! NSDictionary).value(forKey: "long_name") as! String))
                            }
                        }
                    }
                    
                    if(stringData as! String) == "locality"{
                        if ((dictData as! NSDictionary).value(forKey: "long_name")) != nil{
                        self.txtFieldCity.text = ((dictData as! NSDictionary).value(forKey: "long_name") as! String)
                        }
                    }
                    if(stringData as! String) == "country"{
                        if ((dictData as! NSDictionary).value(forKey: "long_name")) != nil{
                        self.txtFieldCountry.text = ((dictData as! NSDictionary).value(forKey: "long_name") as! String)
                        }
                        if ((dictData as! NSDictionary).value(forKey: "short_name")) != nil{
                            if ((dictData as! NSDictionary).value(forKey: "short_name") as! String).characters.count > 0{
                                self.countryCode = ((dictData as! NSDictionary).value(forKey: "short_name") as! String)
                            }else{
                                self.countryCode = ((dictData as! NSDictionary).value(forKey: "long_name") as! String)
                            }
                        }else{
                            self.countryCode = ((dictData as! NSDictionary).value(forKey: "long_name") as! String)
                        }
                    }
                    if(stringData as! String) == "administrative_area_level_1"{
                        if ((dictData as! NSDictionary).value(forKey: "long_name")) != nil{
                            self.txtFieldState.text = ((dictData as! NSDictionary).value(forKey: "long_name") as! String)
                        }
                        if ((dictData as! NSDictionary).value(forKey: "short_name")) != nil{
                            
                            if ((dictData as! NSDictionary).value(forKey: "short_name") as! String).characters.count > 0{
                                self.stateCode = ((dictData as! NSDictionary).value(forKey: "short_name") as! String)
                            }else{
                                self.stateCode = ((dictData as! NSDictionary).value(forKey: "long_name") as! String)
                            }
                        }else{
                            self.stateCode = ((dictData as! NSDictionary).value(forKey: "long_name") as! String)
                        }
                    }
                    if(stringData as! String) == "postal_code"{
                        if ((dictData as! NSDictionary).value(forKey: "long_name")) != nil{
                            self.txtFieldPincode.text = ((dictData as! NSDictionary).value(forKey: "long_name") as! String)
                        }
                    }
                }
        }
        
        if geoLocationArray.count > 0{
            self.txtViewAddressOne.text = geoLocationArray.componentsJoined(by: ", ")
            self.txtViewAddressOne.textColor = UIColor.black
        }else{
            self.txtViewAddressOne.text = "Address 1"
            self.txtViewAddressOne.textColor = UIColor.lightGray
        }
    }
    
    }
    
    
    func getCurrentLocation() -> CLLocationCoordinate2D{
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }else{
            var coordinate = CLLocationCoordinate2D()
            coordinate.latitude = 0.0
            coordinate.longitude = 0.0
            return coordinate
        }
        
        return (locationManager.location?.coordinate)!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
    
    @IBAction func onClickAddMapMember(_ sender: UIButton) {
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_TYPE_WISE
            let constant = Constants()
            var parameters = Parameters()
        
        
       
        if SharedManager.shareData().isEditOrCreateLocation == 2{
            parameters = constant.getTypeWiseListJsonData(fieldCode: "ddLocationMapEligibleEmpList",refCode: (SharedManager.shareData().dictForProfileData as NSDictionary).value(forKey: "OfficeID") as! String)
            SharedManager.shareData().officeIDForDetails = (SharedManager.shareData().dictForProfileData as NSDictionary).value(forKey: "OfficeID") as! String
        }else{
            parameters = constant.getTypeWiseListJsonData(fieldCode: "ddLocationMapEligibleEmpList",refCode:  SharedManager.shareData().officeIDForDetails)
        }
        
        
        
            Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                
                if let json = response.result.value as? [String: Any] {
                    let getTypeWiseListResult = json["GetTypeWiseListResult"] as? [String: Any]
                    let errorCode: Int = (getTypeWiseListResult?["ErrorCode"] as? Int)!
                    if errorCode == 0{
                        let resultData: NSArray = (getTypeWiseListResult?["list"] as? NSArray)!
                            if resultData.count > 0{
                                SharedManager.shareData().arrayForMappingMembers = resultData as? NSArray as! [Any]!
                               self.showMappingEmployess()
                            }else{
                                self.showAlert(message: "No Employees")
                        }
                    }else{
                    }
                }
            }
    }
    
    func showMappingEmployess()  {
        SharedManager.shareData().popupFor = "MappingMember"
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: true, completion: nil)

    }
    
    func enableSaveButton(){
        self.saveBtn.isEnabled = true
        self.saveBtn.alpha = 1.0
    }
    
    func disabelSaveButton(){
        self.saveBtn.isEnabled = false
        self.saveBtn.alpha = 0.5
    }
    
    func submitLocation() {
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_LOCATION_UPDATE
        
        let constant = Constants()
        var parameters = Parameters()
        
        let arrayToSend = NSMutableArray()
        for i in (0..<mappingMeberArray.count){
            let dictData = NSMutableDictionary()
            let empCode =  (mappingMeberArray.object(at:i) as! NSDictionary).value(forKey: "Code") as! String
            dictData.setValue(empCode, forKey: "EmpID")
            dictData.setValue("A", forKey: "Flag")
            arrayToSend.add(dictData)
            }
        
        if SharedManager.shareData().isEditOrCreateLocation == 1{
            
            if !isLocationImageValid && isImageCaptured {
                
                let  imageString = imageDataToSend.base64EncodedString(options:NSData.Base64EncodingOptions(rawValue: 0))
                
                 parameters = constant.getUpdateCreateLocationJsonData(officeID: SharedManager.shareData().officeIDForDetails, officeName: txtFieldName.text!, officeType: officeType, officeCode: txtFieldCode.text!, addressOne: txtViewAddressOne.text!, addressTwo: txtViewAddressTwo.text!, city: txtFieldCity.text!, pincode: txtFieldPincode.text!, countryCode: countryCode, stateCode: stateCode, isoCountryCode: countryCode, isoStateCode: stateCode, phoneNumber: txtFieldPhoneNumber.text!, latitude: txtFieldLongitude.text!, longitude: txtFieldLatitude.text!, length: String(format:"%i",imageDataToSend.length), base64Data: imageString, fileName:"location.jpeg", fileExtension: ".jpeg", mappedEmployeeList: arrayToSend, geoLocation: "")
                
            }else{
            parameters = constant.getUpdateCreateLocationJsonData(officeID: SharedManager.shareData().officeIDForDetails, officeName: txtFieldName.text!, officeType: officeType, officeCode: txtFieldCode.text!, addressOne: txtViewAddressOne.text!, addressTwo: txtViewAddressTwo.text!, city: txtFieldCity.text!, pincode: txtFieldPincode.text!, countryCode: countryCode, stateCode: stateCode, isoCountryCode: countryCode, isoStateCode: stateCode, phoneNumber: txtFieldPhoneNumber.text!, latitude: txtFieldLongitude.text!, longitude: txtFieldLatitude.text!, length: "0", base64Data: "", fileName:"", fileExtension: "", mappedEmployeeList: arrayToSend, geoLocation: "")
        
            }
        
        }
       
        else{
            
            if isImageCaptured {
                
                let  imageString = imageDataToSend.base64EncodedString(options:NSData.Base64EncodingOptions(rawValue: 0))
                
                parameters = constant.getUpdateCreateLocationJsonData(officeID: "0", officeName: txtFieldName.text!, officeType: officeType, officeCode: txtFieldCode.text!, addressOne: txtViewAddressOne.text!, addressTwo: txtViewAddressTwo.text!, city: txtFieldCity.text!, pincode: txtFieldPincode.text!, countryCode: countryCode, stateCode: stateCode, isoCountryCode: countryCode, isoStateCode: stateCode, phoneNumber: txtFieldPhoneNumber.text!, latitude: txtFieldLongitude.text!, longitude: txtFieldLatitude.text!, length: String(format:"%i",imageDataToSend.length), base64Data: imageString, fileName:"location.jpeg", fileExtension: ".jpeg", mappedEmployeeList: arrayToSend, geoLocation: geoLocationName)
                
            }else{
                self.enableSaveButton()
                activityIndicatorView.stopAnimating()
                self.showAlert(message: "Please capture Image")
                return
            }
        }
        
    
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            self.enableSaveButton()
             print(response.result)
            if let json = response.result.value as? [String: Any] {
               
                let updateLocationResult = json["UpdateLocationResult"] as? [String: Any]
                let errorCode: Int = (updateLocationResult?["ErrorCode"] as? Int)!
                var message = ""

                if errorCode == 0{
                   message = "Location successfully updated!"
                    self.showAlert(message: message)
                    self.showLocationsView()
                }else{
                    message = (updateLocationResult?["ErrorMessage"] as? String)!
                    self.showAlert(message: message)
                }
            }
        }
    }
    
    
    func showAlert(message: String){
        let refreshAlert = UIAlertController(title: "", message: message , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        }))
        self.present(refreshAlert, animated: true, completion: nil)

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
