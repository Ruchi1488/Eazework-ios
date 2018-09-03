//
//  CreateProfileViewController.swift
//  EazeWork
//
//  Created by User1 on 5/5/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import Alamofire
import SWActivityIndicatorView
class CreateProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblForTitle: UILabel!
    
    @IBOutlet weak var txtFieldFName: UITextField!
    @IBOutlet weak var txtFieldLName: UITextField!
    @IBOutlet weak var txtFieldGender: UITextField!
    @IBOutlet weak var txtFieldDateOfJoin: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldMobile: UITextField!
    @IBOutlet weak var txtFieldPANNumber: UITextField!
    @IBOutlet weak var txtFieldAdharNumber: UITextField!
    @IBOutlet weak var txtFieldWorkLocation: UITextField!
    
    @IBOutlet weak var btnEducationRecord: UIButton!
    @IBOutlet weak var btnAddressProof: UIButton!
    @IBOutlet weak var btnEmployeePhoto: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblEducationRecord: UILabel!
    @IBOutlet weak var lblAddressProof: UILabel!
    @IBOutlet weak var lblEmployeePhoto: UILabel!
    

    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    var txtFieldTemp: UITextField!
    
    var myCollectionView: UICollectionView!
    var cameraTagValue = Int()
    var arrayForReqInputFields = NSMutableArray()
    var arrayForCollectionVwData = NSMutableArray()
    var arrayForImages = NSMutableArray()
    var button: UIButton!
    var buttonTemp: UIButton!
    
    
    var isEmployeePhotoCaptured = Bool()
    var buttonClickedFrom = Bool()
    var indexValueForImage = NSInteger()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEmployeePhotoCaptured = false
        definesPresentationContext = true
        self.hiddenAllTextFields()
        self.getInputRequestFields()
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
       /*
        self.editTextField(textField: txtFieldFName)
        self.editTextField(textField: txtFieldLName)
        self.editTextField(textField: txtFieldGender)
        self.editTextField(textField: txtFieldDateOfJoin)
        self.editTextField(textField: txtFieldEmail)
        self.editTextField(textField: txtFieldMobile)
        self.editTextField(textField: txtFieldPANNumber)
        self.editTextField(textField: txtFieldAdharNumber)
        self.editTextField(textField: txtFieldWorkLocation)
         */
        let name:NSNotification.Name = NSNotification.Name("GenderSelected")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationCallback(_:)),
                                               name: name,
                                               object: nil)
        btnEducationRecord.isHidden = true
        btnAddressProof.isHidden = true
        btnEmployeePhoto.isHidden = true
        
        lblEducationRecord.isHidden = true
        lblAddressProof.isHidden = true
        lblEmployeePhoto.isHidden = true
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationCallbackForDate(_:)),
                                               name: NSNotification.Name(rawValue: "DateSelected"),
                                               object: nil)
}
    
    @objc func notificationCallbackForDate(_ notification: NSNotification){
        
        if notification.name.rawValue == "DateSelected"{
            let userInfo = notification.userInfo as NSDictionary? as! [String:Any]?
            NSLog("%@", (userInfo! as NSDictionary))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let fromDate = formatter.string(from: (userInfo! as NSDictionary).value(forKey: "date") as! Date)
            buttonTemp.setTitle(fromDate, for: UIControlState.normal)
            buttonTemp.setTitleColor(UIColor.black, for: UIControlState.normal)
            let indexValue: NSInteger = buttonTemp.tag
            self.changeValuesInArray(index: indexValue, value: fromDate,valueForTitle:"")
        }
    }
    
    // MARK: - TextField
    
    func hiddenAllTextFields(){
        txtFieldFName.isHidden = true
        txtFieldLName.isHidden = true
        txtFieldGender.isHidden = true
        txtFieldDateOfJoin.isHidden = true
        txtFieldEmail.isHidden = true
        txtFieldMobile.isHidden = true
        txtFieldPANNumber.isHidden = true
        txtFieldAdharNumber.isHidden = true
        txtFieldWorkLocation.isHidden = true
    }
    
    func editTextField(textField : UITextField){
        textField.isHidden = true
        textField.backgroundColor = UIColor.clear
        textField.tintColor = SharedManager.shareData().headerBGColor
        textField.delegate = self
        let imgVw: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 30))
        imgVw.contentMode = UIViewContentMode.scaleAspectFit;
        textField.leftView = imgVw
        textField.leftViewMode = UITextFieldViewMode.always
        textField.addTarget(self, action: #selector(UIResponder.resignFirstResponder), for: UIControlEvents.editingDidEndOnExit)
        textField.autocorrectionType = UITextAutocorrectionType.no
        self.setTextFieldBottomLine(txtField: textField, lineColor: UIColor.lightGray)
    }

    func editDynamicTextField(textField : UITextField){
        textField.backgroundColor = UIColor.clear
        textField.tintColor = TOP_COLOR
        textField.delegate = self
        let imgVw: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 30))
        imgVw.contentMode = UIViewContentMode.scaleAspectFit;
        textField.leftView = imgVw
        textField.leftViewMode = UITextFieldViewMode.always
        textField.addTarget(self, action: #selector(UIResponder.resignFirstResponder), for: UIControlEvents.editingDidEndOnExit)
        textField.autocorrectionType = UITextAutocorrectionType.no
        self.setTextFieldBottomLine(txtField: textField, lineColor: UIColor.lightGray)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        self.setTextFieldBottomLine(txtField: textField, lineColor: TOP_COLOR)
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setTextFieldBottomLine(txtField: textField, lineColor: UIColor.lightGray)
        let indexValue: NSInteger = (textField.placeholderText! as NSString).integerValue
        buttonClickedFrom = false
        self.changeValuesInArray(index: indexValue, value: textField.text!,valueForTitle:"")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        self.setTextFieldBottomLine(txtField: textField, lineColor: UIColor.lightGray)
        let indexValue: NSInteger = (textField.placeholderText! as NSString).integerValue
        buttonClickedFrom = false
        self.changeValuesInArray(index: indexValue, value: textField.text!,valueForTitle:"")
        
        return true
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
    
    func showGenderOptions(){
        
        SharedManager.shareData().popupFor = "Gender"
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
    }
    
    //MARK: -
    
    @IBAction func onClickSaveButton(_ sender: UIButton) {
        
        self.view.endEditing(true)
        btnSave.isEnabled = false
        btnSave.alpha = 0.5
        var boolValueForMandatoryFields = Bool()
        boolValueForMandatoryFields = false
        var dataNeedToSend = NSString()
        for i in (0..<self.arrayForReqInputFields.count){
            let dict = (self.arrayForReqInputFields[i] as? NSDictionary)!

            if (dict.value(forKey: "CompulsoryYN") as! NSString) == "Y"{
                if (dict.value(forKey: "FieldValue") as! NSString).length <= 0 {
                    boolValueForMandatoryFields = false
                   dataNeedToSend = String(format:"Please Enter %@",(dict.value(forKey: "FieldLabel") as! NSString)) as NSString
                    break
                }else{
                    boolValueForMandatoryFields = true
                }
            }
        }

        
        if boolValueForMandatoryFields{
            for i in (0..<self.arrayForCollectionVwData.count){
                let dict = (self.arrayForCollectionVwData[i] as? NSDictionary)!
                
                if (dict.value(forKey: "CompulsoryYN") as! NSString) == "Y"{
                    
                    if ((arrayForCollectionVwData[i] as? NSDictionary)!.value(forKey: "Image") != nil){
                         boolValueForMandatoryFields = true
                    }else{
                        boolValueForMandatoryFields = false
                        dataNeedToSend = String(format:"Please Select %@",(dict.value(forKey: "FieldLabel") as! NSString)) as NSString
                        
                        break
                    }
                }
            }
        }
        
        
        if boolValueForMandatoryFields{
            self.constructInputJson()
        }else{
            btnSave.isEnabled = true
            btnSave.alpha = 1.0
            let refreshAlert = UIAlertController(title: "", message:dataNeedToSend as String , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickCancelButton(_ sender: UIButton) {
        self.showTeamListView()
    }
    
    
    func showTeamListView(){
        
        SharedManager.shareData().teamCount = 1
        let arrayForEmpID = NSMutableArray()
        arrayForEmpID.add(SharedManager.shareData().employeeID)
        SharedManager.shareData().arrayForEmpID = arrayForEmpID
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "TeamListVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    
    //MARK: - Camera Snap
    
    @IBAction func onClickEducationRecord(_ sender: UIButton) {
        cameraTagValue = sender.tag
        self.openCamera()
    }
    
    @IBAction func onClickAddressProof(_ sender: UIButton) {
        cameraTagValue = sender.tag
        self.openCamera()
    }
    
    @IBAction func onClickEmployeePhoto(_ sender: UIButton) {
        cameraTagValue = sender.tag
        self.openCamera()
    }
    
    func openCamera(){
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage

        let imageData = UIImageJPEGRepresentation(image!, 0)
        image = UIImage(data:imageData!,scale:1.0)
        
        arrayForImages.replaceObject(at: indexValueForImage, with: image as Any)
        
        let dictData = (arrayForCollectionVwData[indexValueForImage] as? NSDictionary)!
        let changedDictData = dictData.mutableCopy() as! NSMutableDictionary
        changedDictData.setValue(image, forKey: "Image")
       // changedDictData.setValue(valueForTitle, forKey: "FieldLabel")
        arrayForCollectionVwData.replaceObject(at: indexValueForImage, with: changedDictData)
        
        myCollectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK: -
    

    func changeValuesInArray(index: NSInteger, value: String, valueForTitle: String){
      
        if  buttonClickedFrom{
            let dictData = (self.arrayForCollectionVwData[index] as? NSDictionary)!
            let changedDictData = dictData.mutableCopy() as! NSMutableDictionary
            changedDictData.setValue(value, forKey: "FieldValue")
            changedDictData.setValue(valueForTitle, forKey: "FieldLabel")
            arrayForCollectionVwData.replaceObject(at: index, with: changedDictData)
            myCollectionView.reloadData()
            
        }else{
            let dictData = (self.arrayForReqInputFields[index] as? NSDictionary)!
            let changedDictData = dictData.mutableCopy() as! NSMutableDictionary
            changedDictData.setValue(value, forKey: "FieldValue")
            arrayForReqInputFields.replaceObject(at: index, with: changedDictData)
        }
    }
    
    @IBAction func onClickGender(_ sender: UIButton) {
        
//        SharedManager.shareData().popupFor = "Gender"
//        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
//        
//        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
//        present(popupViewController!, animated: false, completion: { _ in })
        
    }
    
    @objc func notificationCallback(_ notification: NSNotification){
        
        let userInfo = notification.userInfo as NSDictionary? as! [String:Any]?
        let indexValue: NSInteger = buttonTemp.tag
        
        if buttonClickedFrom {
             self.changeValuesInArray(index: indexValue, value: ((userInfo! as NSDictionary).value(forKey: "Code") as! String),valueForTitle:((userInfo! as NSDictionary).value(forKey: "Value") as! String))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.indexValueForImage = indexValue
                self.openCamera()
            })
            
        }else{
            
            buttonTemp.setTitle(((userInfo! as NSDictionary).value(forKey: "Value") as! String), for: UIControlState.normal)
            buttonTemp.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.changeValuesInArray(index: indexValue, value: ((userInfo! as NSDictionary).value(forKey: "Code") as! String),valueForTitle:"")
        }
    }
    
    @IBAction func onClickDateOfJoining(_ sender: UIButton) {
    }
    
    
    func getInputRequestFields(){
    
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor

        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_MEMBER_REQUEST_INPUT_FIELDS
        
        let constant = Constants()
        let parameters = constant.getInputRequestFieldsJsonData()
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if let json = response.result.value as? [String: Any] {
                print(json)
                let getMemberReqInputFieldsResult = json["GetMemberReqInputFieldsResult"] as? [String: Any]
                let errorCode: Int = (getMemberReqInputFieldsResult?["ErrorCode"] as? Int)!
                if errorCode == 0{
                    var resultData: NSArray = (getMemberReqInputFieldsResult?["ReqFields"] as? NSArray)!
                
                    self.arrayForReqInputFields = resultData.mutableCopy() as! NSMutableArray
        
                    for i in (0..<self.arrayForReqInputFields.count){
                        var seqIntNo: NSInteger = 0
                        let dictData = (self.arrayForReqInputFields[i] as? NSDictionary)!
                        let seqNo: NSString = dictData.value(forKey: "SeqNo") as! NSString
                        seqIntNo = seqNo.integerValue
                        let changedDictData = dictData.mutableCopy() as! NSMutableDictionary
                        changedDictData.setValue(seqIntNo, forKey: "SeqNo")
                        self.arrayForReqInputFields.replaceObject(at: i, with: changedDictData)
                    }
        
                    resultData = self.arrayForReqInputFields
                    let sortDescriptor = NSSortDescriptor(key: "SeqNo", ascending: true)
                    resultData = resultData.sortedArray(using: [sortDescriptor]) as NSArray
                    self.arrayForReqInputFields = resultData.mutableCopy() as! NSMutableArray
                    self.createUIFields()
            
                }else{

                    let errorMessage: String = (getMemberReqInputFieldsResult?["ErrorMessage"] as? String)!
                    let refreshAlert = UIAlertController(title: "", message:errorMessage , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
        }
    }

    
    func createUIFields(){
        
        /*
         FieldTypeID value:
         1=String
         2=Number
         3=Date
         4=Table
         5=List
         */
        
        
        let imageTypeArray = NSMutableArray()
        let indexSet = NSMutableIndexSet()
        
        for i in (0..<self.arrayForReqInputFields.count){
            let dict = (self.arrayForReqInputFields[i] as? NSDictionary)!
            let fieldTypeID: NSString = (dict.value(forKey: "FieldTypeID") as! NSString)
            if fieldTypeID.integerValue == 99 || fieldTypeID.integerValue == 4 || fieldTypeID.integerValue == 66 {
                imageTypeArray.add(dict)
                indexSet.add(i)
            }
        }
        
        arrayForCollectionVwData = imageTypeArray
        self.arrayForReqInputFields.removeObjects(at: indexSet as IndexSet)
    
        var textField = UITextField()
       
        var contentHeight = Float()
        for i in (0..<self.arrayForReqInputFields.count){
            
            let dictData = (self.arrayForReqInputFields[i] as? NSDictionary)!
            let fieldLabel: NSString = dictData.value(forKey: "FieldLabel") as! NSString
            let frame = CGRect(x: 16, y: 10 + 50 * CGFloat(i), width: self.view.frame.size.width-32, height: 40);
             let fieldTypeID: NSString = (dictData.value(forKey: "FieldTypeID") as! NSString)
            
 
            if fieldTypeID.integerValue == 3 || fieldTypeID.integerValue == 5 {

                button = UIButton(frame: frame)
                button.setTitle(fieldLabel as String, for: UIControlState.normal)
                button.contentHorizontalAlignment = .left
                button.titleEdgeInsets = UIEdgeInsetsMake(10,20,10,10)
                button.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.titleLabel?.textColor = UIColor.lightGray
                button.tag = i
                button.addTarget(self, action: #selector(CreateProfileViewController.handleRegister(sender:)), for:.touchUpInside)
                contentView.addSubview(button)
                let border = CALayer()
                let width = CGFloat(1.0)
                border.borderColor = UIColor.lightGray.cgColor
                border.frame = CGRect(x: 10, y: button.frame.size.height - width, width:  button.frame.size.width-20, height: button.frame.size.height)
                border.borderWidth = width
                button.layer.addSublayer(border)
                button.layer.masksToBounds = true
            }else{
                textField.tag = i
                if fieldTypeID.integerValue == 2 {
                    textField.keyboardType = UIKeyboardType.numberPad
                }else{
                    textField.keyboardType = UIKeyboardType.asciiCapable
                }
               
                textField.font =   UIFont.systemFont(ofSize: 15)
                textField = UITextField(frame: frame)
                self.editDynamicTextField(textField: textField)
                textField.placeholder = fieldLabel as String
                textField.placeholderText = String(format:"%i",i)
                textField.shouldHidePlaceholderText = true
                textField.delegate = self
                contentView.addSubview(textField)
            }
            contentHeight = 10.0 + 50.0 * Float(i)
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: self.view.frame.size.width/2-40, height: 100)
        layout.scrollDirection = .vertical
        let frame = CGRect(x: 0, y: Int(contentHeight + 75) , width: Int(CGFloat(self.view.frame.size.width)), height: 100 * arrayForCollectionVwData.count)
        
        myCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(ButtonsCustomCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor = UIColor.white
        contentView.addSubview(myCollectionView)
        
        
        
        for i in (0..<self.arrayForCollectionVwData.count){
             let image = UIImage(named: "camera")! as UIImage
            arrayForImages.add(image)
        }
        
        contentViewHeight.constant = CGFloat(contentHeight) +  CGFloat(100 * arrayForCollectionVwData.count) + 30.0
    }
    
    
    @objc func handleRegister(sender: UIButton){
    
        buttonClickedFrom = false
        buttonTemp = sender
        let dictData = (self.arrayForReqInputFields[sender.tag] as? NSDictionary)!
        let fieldValue: NSInteger = (dictData.value(forKey: "FieldTypeID") as! NSString).integerValue
        
        if fieldValue == 5 {
            SharedManager.shareData().dictForGetTypeWiseList = dictData as NSDictionary? as! [AnyHashable : Any]!
             SharedManager.shareData().popupFor = "Gender"
            self.showGenderOptions()
        }else if fieldValue == 3 {
            self.showCalendar()
        }
    }
    
    func showCalendar(){
        SharedManager.shareData().calendarForLeave = 2
        let addStatusViewController: CalendarViewController? = storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarViewController?
        
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 30), height: 312))
        present(popupViewController!, animated: false, completion: nil)
    }

    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayForCollectionVwData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! ButtonsCustomCell
        cell.profileImageButton.backgroundColor = UIColor.lightGray
        let dictData = (arrayForCollectionVwData[indexPath.row] as? NSDictionary)
        cell.nameLabel.text =  (dictData?.value(forKey: "FieldLabel") as! NSString) as String
        cell.profileImageButton.addTarget(self, action: #selector(CreateProfileViewController.imageButton(sender:)), for:.touchUpInside)
        cell.profileImageButton.tag = indexPath.row
        
        if arrayForImages.count > 0{
//            let image = UIImage(named: "camera")! as UIImage
            
            let fieldTypeID: NSString = (dictData?.value(forKey: "FieldTypeID") as! NSString)
            
            if fieldTypeID.integerValue == 99 && !isEmployeePhotoCaptured{
                cell.profileImageButton.backgroundColor = UIColor(red: (216/255.0), green: (2/255.0), blue: (12/255.0), alpha: 1.0)
                cell.profileImageButton.setImage(UIImage(named: "photo"), for: UIControlState.normal)
                cell.profileImageButton.setBackgroundImage(UIImage(named: ""), for: UIControlState.normal)
            }else{
                cell.profileImageButton.setBackgroundImage(arrayForImages[indexPath.row] as? UIImage, for: UIControlState.normal)
                cell.profileImageButton.setImage(UIImage(named: ""), for: UIControlState.normal)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width/2-40, height: 70)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
 
    @objc func imageButton(sender: UIButton){

        buttonClickedFrom = true
        let dictData = (self.arrayForCollectionVwData[sender.tag] as? NSDictionary)!
        let fieldValue: NSInteger = (dictData.value(forKey: "FieldTypeID") as! NSString).integerValue
        buttonTemp = sender
        if fieldValue == 4 {
            SharedManager.shareData().dictForGetTypeWiseList = dictData as NSDictionary? as! [AnyHashable : Any]!
            self.showGenderOptions()
        }else{
         
            if fieldValue == 99{
                isEmployeePhotoCaptured = true
            }
            
            indexValueForImage = sender.tag
            self.openCamera()
        }
    }

    func constructInputJson(){

        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor

        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let arrayTemp = NSMutableArray()
      
        let dict = NSMutableDictionary();
        
        for i in (0..<arrayForReqInputFields.count){
            let dictData = NSMutableDictionary()
            dictData.setValue((arrayForReqInputFields[i] as? NSDictionary)!.value(forKey: "FieldCode") as! String, forKey: "FieldCode")
            dictData.setValue((arrayForReqInputFields[i] as? NSDictionary)!.value(forKey: "FieldValue") as! String, forKey: "FieldValue")
            dictData.setValue("0", forKey: "TranID")
            arrayTemp.add(dictData)
        }

        
        for i in (0..<arrayForCollectionVwData.count){
            
            let dictData = NSMutableDictionary()
            dictData.setValue((arrayForCollectionVwData[i] as? NSDictionary)!.value(forKey: "FieldCode") as! String, forKey: "FieldCode")
            
             let strFieldValue: NSString =  (arrayForCollectionVwData[i] as? NSDictionary)!.value(forKey: "FieldValue") as! NSString
            
            if strFieldValue.length<=0{
                dictData.setValue("0", forKey: "FieldValue")
            }else{
                dictData.setValue((arrayForCollectionVwData[i] as? NSDictionary)!.value(forKey: "FieldValue") as! String, forKey: "FieldValue")
            }
            dictData.setValue("0", forKey: "TranID")
            
            let imgDictData = NSMutableDictionary()
            if ((arrayForCollectionVwData[i] as? NSDictionary)!.value(forKey: "Image") != nil){
                
                
                let strName: NSString =  (arrayForCollectionVwData[i] as? NSDictionary)!.value(forKey: "FieldLabel") as! NSString
                let trimmedStringName = strName.trimmingCharacters(in: .whitespaces)
                imgDictData.setValue(String(format:"%@.jpeg",trimmedStringName), forKey: "Name")
                imgDictData.setValue(".jpeg", forKey: "Extension")
                
                let imageData: NSData = UIImageJPEGRepresentation(arrayForImages[i] as! UIImage, 0)! as NSData
                let strBase64 = imageData.base64EncodedString(options:NSData.Base64EncodingOptions(rawValue: 0))
                imgDictData.setValue(strBase64, forKey: "Base64Data")
                imgDictData.setValue(imageData.length, forKey: "Length")
                
            }else{
                imgDictData.setValue("", forKey: "Name")
                imgDictData.setValue("", forKey: "Extension")
                imgDictData.setValue("", forKey: "Base64Data")
                imgDictData.setValue("0", forKey: "Length")
            }
            
            dictData.setValue(imgDictData, forKey: "FileInfo")
            arrayTemp.add(dictData)
           
        }
        dict.setValue("0", forKey: "ReqID")
        dict.setValue("", forKey: "ReqStatus")
        dict.setValue(arrayTemp, forKey: "Fields")
        
        
        let loginDictData = NSMutableDictionary()
        
        loginDictData.setValue((((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "CorpUrl") as! String), forKey: "CorpUrl")
        
        loginDictData.setValue((((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Login") as! String), forKey: "Login")
        
        loginDictData.setValue((((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Password") as! String), forKey: "Password")
        
        loginDictData.setValue(SharedManager.shareData().deviceID!, forKey: "DeviceID")
        
        loginDictData.setValue(SharedManager.shareData().sessionID!, forKey: "SessionID")
        
        let dic = NSMutableDictionary()
        dic.setValue(loginDictData, forKey: "loginData")
        dic.setValue(dict, forKey: "requestData")

        let parameters: Parameters = [
            "loginData": loginDictData,
            "requestData":dict
        ]
        print(parameters)
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_CREATE_EMPLOYEE_PROFILE
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            self.btnSave.isEnabled = true
            self.btnSave.alpha = 1.0
            if let json = response.result.value as? [String: Any] {
                let getLocationListResult = json["UpdateMemberReqInputFieldsResult"] as? [String: Any]
                let errorCode: Int = (getLocationListResult?["ErrorCode"] as? Int)!
                var message: String = ""
                if errorCode == 0{
                    message = "Employee Created"
                    
                    let refreshAlert = UIAlertController(title: "", message:message , preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController

                }else{
                    message = (getLocationListResult?["ErrorMessage"] as? String)!
                    let refreshAlert = UIAlertController(title: "", message:message , preferredStyle: UIAlertControllerStyle.alert)
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
