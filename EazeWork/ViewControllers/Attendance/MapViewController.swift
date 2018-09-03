//
//  MapViewController.swift
//  EazeWork
//
//  Created by User1 on 5/17/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SWActivityIndicatorView
import Alamofire
class MapViewController: UIViewController,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewForTopView: UIView!
    @IBOutlet weak var timeInOutBottomView: UIView!
    
    
    @IBOutlet weak var menuButton: JTHamburgerButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var lblTimeInStatus: UILabel!
    @IBOutlet weak var lblLocationName: UILabel!
    
    @IBOutlet weak var viewForCapturedImage: UIView!
    @IBOutlet weak var viewForTimer: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var cameraTopView: UIView!
    @IBOutlet weak var lblTakePicture: UILabel!
    @IBOutlet weak var capturedImgVw: UIImageView!
    @IBOutlet weak var btnSelfieConfirm: UIButton!
    @IBOutlet weak var btnSelfieRetake: UIButton!
    
    @IBOutlet weak var topSpaceTimeInStatus: NSLayoutConstraint!
    
    var locationManager:CLLocationManager!
    var locationDefined: Bool!
    var isLocationTrace: Bool!
    var locationMessage: String!
    var imageDataToSend: NSData!
    var inTime: String!
    var timer: Timer!
    var timerLocTrace: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        viewForCapturedImage.isHidden = true
        
        menuButton.setCurrentModeWithAnimation(JTHamburgerButtonMode.arrow)
        viewForTopView.backgroundColor = SharedManager.shareData().headerBGColor
        timeInOutBottomView.backgroundColor = SharedManager.shareData().headerBGColor
        cameraTopView.backgroundColor = SharedManager.shareData().headerBGColor
        timeInOutBottomView.layer.cornerRadius = 5
        
        
        btnSelfieRetake.backgroundColor = BUTTON_RED_BG_COLOR
        btnSelfieRetake.layer.cornerRadius = 5
        btnSelfieConfirm.backgroundColor = BUTTON_GREEN_BG_COLOR
        btnSelfieConfirm.layer.cornerRadius = 5
        
        lblForTitle.textColor = SharedManager.shareData().headerTextColor
        lblTimeInStatus.textColor = SharedManager.shareData().headerTextColor
        lblLocationName.textColor = SharedManager.shareData().headerTextColor
        lblTakePicture.textColor = SharedManager.shareData().headerTextColor
        
        let locaton = self.determineMyCurrentLocation()
        mapView.camera = GMSCameraPosition.camera(withLatitude: locaton.latitude, longitude: locaton.longitude, zoom: 15.0)
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        
        NSLog("Employee Config---%@", ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary))
        
        self.timeInOutValidate(dictData: ((SharedManager.shareData().dictAttendanceStatus as NSDictionary)))
        
        if ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "GeoFencingYN") as! String == "Y"{
            
            if ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "WorkLocationYN") as! String == "Y"{
                
                if ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "WorkLocation") as! String).characters.count <= 0 {
                    locationDefined = false
                    locationMessage = "Location not defined"
                }else{
                    locationDefined = true
                    locationMessage = String(format:"at %@",(SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "WorkLocation") as! String)
                }
            }else if ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "WorkLocationYN") as! String == "N"{
                if ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "OfficeLocation") as! String).characters.count <= 0 {
                    locationDefined = false
                    locationMessage = "Location not defined"
                }else{
                    locationDefined = true
                    locationMessage = String(format:"at %@",(SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "OfficeLocation") as! String)
                }
            }
        }else{
            locationDefined = false
        }
        

        if ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "GeoFencingYN") as! String == "Y"{
            if locationDefined == true {
                
                if (((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Latitude") as! String).characters.count > 0 && (((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Longitude") as! String).characters.count > 0{
                    
                    var gmsCircle = GMSCircle()
                    var geoFenceLocation = CLLocationCoordinate2D()
                    
                    let geoFenceLatitude = Double(((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Latitude") as! String)
                    geoFenceLocation.latitude = geoFenceLatitude!
                    let geoFenceLongitude = Double(((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Longitude") as! String)
                    geoFenceLocation.longitude = geoFenceLongitude!
                    
                    let geoFenceRadius: Double!
                    
                    if (((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Radius") as! String).characters.count <= 0{
                        geoFenceRadius = 0.00
                    }else{
                        geoFenceRadius = Double(((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Radius") as! String)
                    }
                    gmsCircle = GMSCircle(position: geoFenceLocation, radius: geoFenceRadius)
                    gmsCircle.fillColor = UIColor(white: 0.7, alpha: 0.7)
                    gmsCircle.map = mapView
                    
                    let location1 = CLLocation(latitude: locaton.latitude, longitude: locaton.longitude)
                    let location2 = CLLocation(latitude: geoFenceLocation.latitude, longitude: geoFenceLocation.longitude)
                    let distance : CLLocationDistance = location1.distance(from: location2)
                    
                    if distance <= geoFenceRadius && distance >=  0 {
                        locationDefined = true
                       // self.locationTrace()
                    }else{
                        locationDefined = false
                        locationMessage = "Not at location"
                    }
                }else{
                    locationDefined = false
                    locationMessage = "Location coordinates not defined"
                }
            }
        }else{
            locationDefined = true
            locationMessage = ""
        }
        lblLocationName.text = locationMessage
        
        if (lblLocationName.text?.characters.count)! <= 0 {
            topSpaceTimeInStatus.constant = 16
        }else{
            topSpaceTimeInStatus.constant = 8
        }
    }
    
    func timeInOutValidate(dictData: NSDictionary)  {
        
        viewForTimer.isHidden = true
        
        if !(dictData["InTime"] is NSNull) {
            if !(dictData["OutTime"] is NSNull) {
                
            }else{
                inTime = String(format:"%@ %@",(dictData["InDate"] as? String)!,(dictData["InTime"] as? String)!)
                self.update()
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
                viewForTimer.isHidden = false
                lblTimeInStatus.text = "Time-Out"
                if dictData["ATTLevel"] as? String == "1" {
                }else if dictData["ATTLevel"] as? String == "2"{
                }else if dictData["ATTLevel"] as? String == "3"{
                }
            }
        }else{
            NSLog("No Attendance Today")
            lblTimeInStatus.text = "Time-In"
        }
    }

    @objc func update() {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        let showDate = inputFormatter.date(from: inTime)
        let timeBuffer =  self.timeRemainingString(finishDate: showDate! as NSDate)
        lblTimer.text = timeBuffer.replacingOccurrences(of: "-", with: "")
    }
    
/*
    func locationTrace(){
        isLocationTrace = true
        
        
        if lblTimeInStatus.text == "Time-Out"{
            
            timerLocTrace = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.locationTraceCheck), userInfo: nil, repeats: true);
        }
    }
    
    
    func locationTraceCheck(){

        let location = self.determineMyCurrentLocation()
        
        var geoFenceLocation = CLLocationCoordinate2D()
        
        let geoFenceLatitude = Double(((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Latitude") as! String)
        geoFenceLocation.latitude = geoFenceLatitude!
        let geoFenceLongitude = Double(((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Longitude") as! String)
        geoFenceLocation.longitude = geoFenceLongitude!
        
        let geoFenceRadius: Double!
        
        if (((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Radius") as! String).characters.count <= 0{
            geoFenceRadius = 0.00
        }else{
            geoFenceRadius = Double(((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "Radius") as! String)
        }
       
        let location1 = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let location2 = CLLocation(latitude: geoFenceLocation.latitude, longitude: geoFenceLocation.longitude)
        let distance : CLLocationDistance = location1.distance(from: location2)
        
        if distance <= geoFenceRadius && distance >=  0 {
           
        }else{
            
        }
        
    }
    */
    func timeRemainingString(finishDate date:NSDate) -> String {
        
        let secondsFromNowToFinish = date.timeIntervalSinceNow
        let hours = Int(secondsFromNowToFinish / 3600)
        let minutes = Int((secondsFromNowToFinish - Double(hours) * 3600) / 60)
        let seconds = Int(secondsFromNowToFinish - Double(hours) * 3600 - Double(minutes) * 60 + 0.5)
    
        var stringHour = String(format: "%d",hours)
        stringHour = stringHour.replacingOccurrences(of: "-", with: "")
        if stringHour.characters.count < 2 {
            stringHour = String(format: "0%d",hours)
        }
        
        var stringMinute = String(format: "%d",minutes)
        stringMinute = stringMinute.replacingOccurrences(of: "-", with: "")
        if stringMinute.characters.count < 2 {
            stringMinute = String(format: "0%d",minutes)
        }
        
        var stringSeconds = String(format: "%d",seconds)
        stringSeconds = stringSeconds.replacingOccurrences(of: "-", with: "")
        if stringSeconds.characters.count < 2 {
            stringSeconds = String(format: "0%d",seconds)
        }
        return String(format: "%@:%@:%@", stringHour, stringMinute, stringSeconds)
    }
    
    
    func determineMyCurrentLocation() -> CLLocationCoordinate2D{
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
    
    @IBAction func onClickMyLocation(_ sender: UIButton){
        let locaton = self.determineMyCurrentLocation()
        mapView.camera = GMSCameraPosition.camera(withLatitude: locaton.latitude,
                                                  longitude: locaton.longitude,
                                                  zoom: 15.0)
    }
    
    @IBAction func onClickBack(_ sender: JTHamburgerButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    @IBAction func onClickPlus(_ sender: UIButton) {
        let addStatusViewController: CreateNewPopup? = storyboard?.instantiateViewController(withIdentifier: "CreateNewPopup") as! CreateNewPopup?
        let popupViewController = BIZPopupViewController(contentViewController: addStatusViewController, contentSize: CGSize(width: CGFloat(view.frame.size.width - 70), height: 320))
        present(popupViewController!, animated: false, completion: nil)
    }
    
    @IBAction func onClickTimeIn(_ sender: UIButton) {
        
        if !locationDefined{
            if locationMessage == "Not at location"{
                self.showAlert(title: locationMessage, message: "Please go to Location and try again!")
            }else{
                self.showAlert(title: "", message: locationMessage)
            }
        }else{
            
            if ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "SelfieYN") as! String == "Y"{
                self.openCamera()
            }else{
                
                let refreshAlert = UIAlertController(title:"", message: String(format:"Are you confirm to %@",lblTimeInStatus.text!), preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "cancel", style: .default, handler: { (action: UIAlertAction!) in
                }))
                refreshAlert.addAction(UIAlertAction(title: "confirm", style: .default, handler: { (action: UIAlertAction!) in
                    if self.lblTimeInStatus.text == "Time-In"{
                        self.getLocationName(requestType: "0")
                    }else if self.lblTimeInStatus.text == "Time-Out"{
                        self.getLocationName(requestType: "3")
                    }
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
    func showAlert(title:String, message:String) {
        
        let refreshAlert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    func openCamera(){
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        //imagePicker.cameraOverlayView = nil
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        capturedImgVw.image = image!
//        var imageData = UIImageJPEGRepresentation(image!, 0)
//        image = UIImage(data:imageData!,scale:1.0)
//        let imageSize: Int = imageData!.count
//        print("size of image in KB: %f ", Double(imageSize) / 1024.0)
        viewForCapturedImage.isHidden = true
        
        imageDataToSend = self.compressImage(image: image!)
        self.confirmSelfie()
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
    
    
    func getLocationName(requestType: String){
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        var locationName = ""
        
        let locatonCoordinate = self.determineMyCurrentLocation()
        let location = CLLocation(latitude: locatonCoordinate.latitude, longitude: locatonCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                locationName = ""
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                print(pm.addressDictionary as Any)
                locationName = (pm.addressDictionary?["FormattedAddressLines"] as! NSArray).componentsJoined(by: ",")
            }else {
                locationName = ""
            }
            activityIndicatorView.stopAnimating()
            self.timeInOut(locationName: locationName, requestType: requestType)
        })
    }
    
    func timeInOut(locationName: String, requestType: String ) {
        
        let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.lineWidth = 2
        activityIndicatorView.autoStartAnimating = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = SharedManager.shareData().headerBGColor
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.FILE_GET_MARK_ATTENDANCE
        
        let locCoordinate = self.determineMyCurrentLocation()
        let constant = Constants()
        var parameters = constant.markAttendance(requestType:requestType, attendanceID: "0", latitude: String(format:"%f",locCoordinate.latitude), longitude: String(format:"%f",locCoordinate.longitude), location:locationName)
        
        
        
        
        if ((SharedManager.shareData().dictEmployeeProfile as NSDictionary).value(forKey: "EmpConfig") as! NSDictionary).value(forKey: "SelfieYN") as! String == "Y"{
            
            
          let  imageString = imageDataToSend?.base64EncodedString(options:NSData.Base64EncodingOptions(rawValue: 0))
            parameters = constant.markAttendanceWithSelfie(requestType: requestType, attendanceID: "0", latitude: String(format:"%f",locCoordinate.latitude), longitude: String(format:"%f",locCoordinate.longitude), location: locationName, length:String(format:"%i",imageDataToSend.length), base64Data: imageString!)
        }
        
        
        
        /*
         0=InTime
         1=BreakOut
         2=BreakIn
         3=OutTime
         4=Cancel OutTime
         
         6=Location In
         7=Location Out
         
         {"loginData":{"DeviceID":"JamesBond007","SessionID":"D53ED096-9A91-4A4F-A9E1-FF67FAC76395"}
         ,"attendance" : {"ReqType":"0","MarkSource":"2","ForEmpID":"22281","AttendID":"17421127","PunchTime":"","IPAddress":"","Latitude":"27.87","Longitude":"23.6","Location":"",
         "FileInfo":{"Name":"sample.doc","Extension":".jpg","Length":"0","Base64Data":""}
         }
         }
         */
        
        Alamofire.request(urlPath, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            activityIndicatorView.stopAnimating()
            if (response.result.value as? [String: Any]) != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }
        }
    }

    
    func confirmSelfie(){
         viewForCapturedImage.isHidden = true
        if lblTimeInStatus.text == "Time-In"{
            self.getLocationName(requestType: "0")
        }else if lblTimeInStatus.text == "Time-Out"{
            self.getLocationName(requestType: "3")
        }
    }
    
    @IBAction func onClickConfirmSelfie(_ sender: UIButton) {
        self.confirmSelfie()
    }
    
    @IBAction func onClickRetakeSelfie(_ sender: UIButton) {
        viewForCapturedImage.isHidden = true
        self.openCamera()
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
