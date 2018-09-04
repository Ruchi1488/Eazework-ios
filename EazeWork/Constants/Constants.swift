//
//  Constants.swift
//  EazeWork
//
//  Created by User1 on 5/4/17.
//  Copyright © 2017 User1. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class Constants {
    
    // MARK: Default Colors
    static let Primary_Blue =  UIColor(red: (0/255.0), green: (0/255.0), blue: (139/255.0), alpha: 1.0)
    static let Primary_Blue_Light =  UIColor(red: (26/255.0), green: (167/255.0), blue: (183/255.0), alpha: 1.0)
    static let Primary_Pink =  UIColor(red: (255/255.0), green: (170/255.0), blue: (185/255.0), alpha: 1.0)
    static let Primary_Dark =  UIColor(red: (195/255.0), green: (0/255.0), blue: (10/255.0), alpha: 1.0)
    static let Cal_Top = UIColor(red: (136/255.0), green: (136/255.0), blue: (136/255.0), alpha: 1.0)
    static let Cal_Cell_Gray = UIColor(red: (204/255.0), green: (204/255.0), blue: (204/255.0), alpha: 1.0)

    // MARK: Restrictions For View's
    
  //  let App_Version = "2ß"
    let App_Version = "2"
    let OS_Version = "2"

    
    static let VALID_FOR_ATTENDANCE = "M0001"
    static let VALID_FOR_LEAVE = "M0002"
    static let VALID_FOR_PAYSLIP = "M0003"
    static let VALID_FOR_LEAVE_REQUEST = "M0004"
    static let VALID_FOR_APPROVAL = "M0005"
    static let VALID_FOR_ATTENDANCE_MARK = "M0006"
    static let VALID_FOR_TOUR_REQUEST = "M0007"
    static let VALID_FOR_WORK_FROM_HOME = "M0008"
    static let VALID_FOR_OD_REQUEST = "M0009"
    static let VALID_FOR_CREATE_EMPLOYEE = "M0010"
    static let VALID_FOR_EMPLOYEE_APPROVAL = "M0011"
    static let VALID_FOR_LOCATIONS = "M0012"
    static let VALID_FOR_CREATE_LOCATION = "M0013"
    static let VALID_FOR_EDIT_LOCATION = "M0014"
    static let VALID_FOR_TEAM = "M0015"
    static let VALID_FOR_VIEW_PROFILE = "M0016"
    static let VALID_FOR_EDIT_PROFILE = "M0017"

    // MARK: WebAPI's
    static let TEST_MODE = "http://www.eazework.net/test/"
    static let STAGING_MODE = "http://www.eazework.com/stage/"
    static let PRODUCTION_MODE = "https://www.eazework.com/"
    
    static let FILE_WCF_SERVICE = "WCFService/"
   // static let FILE_WCF_SERVICE = "EWAPI/"

    
    static let FILE_GET_TYPE_WISE = "CommonService.svc/GetTypeWiseList"
    static let FILE_GET_HOME_DATA =  FILE_WCF_SERVICE + "CommonService.svc/GetHomeData"
    static let FILE_UPLOAD_PROFILE_PIC =  FILE_WCF_SERVICE + "EmployeeService.svc/UploadProfilePic"
    
    static let FILE_LOGIN = "WCFService/LoginService.svc/LogInUser"
     //static let FILE_LOGIN = FILE_WCF_SERVICE + "LoginService.svc/LogInUser"
    static let FILE_VALIDATE_LOGIN = "WCFService/LoginService.svc/ValidateLogIn"
     //static let FILE_VALIDATE_LOGIN = FILE_WCF_SERVICE + "LoginService.svc/ValidateLogIn"
    
    //Sunaina
    static let FILE_LOGIN_GOOGLE = "WCFService/LoginService.svc/LoginUserWithGoogle"
    
    //
    
    static let FILE_GET_LOGOUT = "LoginService.svc/LogOutUser"
    static let FILE_CHANGE_PASSWORD = "LoginService.svc/ChangePassword"
    static let FILE_GET_VALIDATE_PASSWORD = "LoginService.svc/ValidatePassword"
    static let FILE_GET_MENU_DATA = "LoginService.svc/GetMenuData"
    static let FILE_GET_PROFILE = "WCFService/TeamService.svc/GetEmployeeDetails"
    static let FILE_GET_EMPLOYEE_PROFILE = "LoginService.svc/EmpProfile"
    static let FILE_GET_ProfilePic_Upload =  FILE_WCF_SERVICE + "EmployeeService.svc/UploadProfilePic"
    static let FILE_GET_LEAVE_BALANCES = "WCFService/LeaveService.svc/GetEmpLeaveBalances"
    static let FILE_GET_LEAVE_REQUESTS = "WCFService/LeaveService.svc/GetEmpLeaveRequests"
    static let FILE_LEAVE_UPDATE = "WCFService/LeaveService.svc/UpdateEmpPendingReq"
    static let FILE_GET_EMPLOYEE_LEAVES = "WCFService/LeaveService.svc/GetEmpLeaves"
    static let FILE_GET_LEAVE_TYPE_BALANCE = "WCFService/LeaveService.svc/GetEmpLeaveBalance"
    static let FILE_GET_RH_LEAVES = "WCFService/LeaveService.svc/GetEmpRHLeaves"
    static let FILE_GET_LEAVE_REQUEST_TOTAL_DAYS = "WCFService/LeaveService.svc/GetLeaveReqTotalDays"
    static let FILE_GET_SAVE_LEAVE_REQUEST = "WCFService/LeaveService.svc/SaveLeaveReq"
    static let FILE_GET_LEAVE_APPROVALS = "LeaveService.svc/GetEmpPendingApprovalReqs"
    
    static let FILE_GET_ATTENDANCE_STATUS = "AttendanceService.svc/AttendanceStatus"
    static let FILE_GET_ATTENDANCE_HISTORY = "AttendanceService.svc/GetEmpAttendanceCalendarStatus"
    static let FILE_GET_ATTENDANCE_TIME_LINE = "AttendanceService.svc/GetAttendanceTimeLine"
    static let FILE_GET_MARK_ATTENDANCE = "AttendanceService.svc/MarkAttendance"
    
    static let FILE_GET_SALARY_SLIP_MONTHS = "SalarySlipService.svc/SalaryMonth"
    static let FILE_GET_SALARY_SLIP = "SalarySlipService.svc/SalarySlipData"
    
    static let FILE_GET_COMMON_SERVICE_PENDING_APPROVAL_COUNT = "CommonService.svc/GetEmpPendingApprovalCount"
    
    static let FILE_GET_LOCATION_LIST = "LocationService.svc/GetLocationList"
    static let FILE_GET_LOCATION_DETAILS = "LocationService.svc/GetLocationDetails"
    static let FILE_GET_LOCATION_UPDATE = "LocationService.svc/UpdateLocation"
    
    static let FILE_GET_TEAM_MEMBER_LIST = "TeamService.svc/GetTeamMemberList"
    static let FILE_GET_MEMBER_REQUEST_INPUT_FIELDS = "TeamService.svc/GetMemberReqInputFields"
    static let FILE_GET_CREATE_EMPLOYEE_PROFILE = "TeamService.svc/UpdateMemberReqInputFields"
    static let FILE_GET_EDIT_EMPLOYEE_PROFILE = "TeamService.svc/UpdateEmployeeDetails"
    static let FILE_GET_EMP_APPROVALS = "TeamService.svc/GetPendingMemberReqList"
    static let FILE_GET_EMP_UPDATE_APPROVE_REJECT = "TeamService.svc/UpdateMemberApprovalRejection"
     static let GetCorpEmpParam = "CommonService.svc/GetCorpEmpParam"
      static let LeaveServiceParam = "LeaveService.svc/GetLeaveEmpList"
    
    

    // MARK: Constants Methods
    
    func getLoginJsonData(corpURL: String, username: String, password: String) -> Parameters{
        
        let systemVersion = UIDevice.current.systemVersion
            //NSLog("systemVersion = %@", systemVersion)
        //NSLog("systemVersion = %@", String(systemVersion))

        
        
         let parameters: Parameters = [
         "loginCred": [
         "CorpUrl":corpURL,
         "Login": username,
         "Password": password,
         "DeviceID":SharedManager.shareData().deviceID!,
         "SessionID":"27AD20EC-C4CC-4EF4-9FBA-7D848FBE751A",
         "OSVersion": systemVersion,
         "AppVersion": App_Version,
         "OS":OS_Version
         ]
         ]
        return parameters
    }
    
    
    func getLoginGoogleJsonData(corpURL: String, gmailToken: String, fcmToken: String) -> Parameters{
        
        let systemVersion = UIDevice.current.systemVersion
        //NSLog("systemVersion = %@", systemVersion)
        //NSLog("systemVersion = %@", String(systemVersion))
        
        
        
        let parameters: Parameters = [
            "token":gmailToken,
            "loginCred": [
                "CorpUrl":corpURL,
                "Login": "",
                "Password": "",
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":"27AD20EC-C4CC-4EF4-9FBA-7D848FBE751A",
                "OSVersion": systemVersion,
                "AppVersion": App_Version,
                "OS":OS_Version,
                "FCMToken":fcmToken
            ]
        ]
        return parameters
    }
    
    func getValidateLoginJsonData() -> Parameters{
        let parameters: Parameters = [
            "loginCred": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ]
        ]
        return parameters
    }
    
    func getValidatePasswordJsonData(password: String) -> Parameters {
        
        let parameters: Parameters = [
            "loginCred": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!,
                "Password":password
            ],
            ]
        return parameters
    }
    
    func getChangePasswordJsonData(currentPassword: String, newPassword: String) -> Parameters {
        let parameters: Parameters = [
            "loginCred": [
                "Password":currentPassword,
                "NewPassword":newPassword,
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            ]
        
        return parameters
    }
//    func UploadProfilePic() -> Parameters {
//        let parameters: Parameters = [
//            "loginData": [
//                "DeviceID":SharedManager.shareData().deviceID!,
//                "SessionID":SharedManager.shareData().sessionID!
//                "FileInfo":
//            ],
//            ]
//        return parameters
//    }

    func getMenuJsonData() -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            ]
        return parameters
    }

    func getTypeWiseListJsonData(fieldCode: String,refCode: String) -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "CorpUrl":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "CorpUrl") as! String),
                "Login":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Login") as! String),
                "Password":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Password") as! String),
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "ParamType":fieldCode,
            "RefCode":refCode
        ]
    
        return parameters
    }
    
    func getProfileJsonData(empID: String) ->  Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "ForEmpID":empID
        ]
        return parameters
    }
    
    func getLeaveBalanceJsonData() -> Parameters
    {
          var EmpID : String?
        
        if SharedManager.shareData().isOnBehalfLeaveApplied {
            EmpID = SharedManager.shareData().onBehalfEmpID
        }
        else
        {
            EmpID = String(SharedManager.shareData().employeeID)

        }
        
        
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "empID":EmpID ?? SharedManager.shareData().employeeID

           // "empID":SharedManager.shareData().employeeID
        ]
        return parameters
    }
    
    func getAttendanceStatusJsonData() -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "attendance" : [
                "ForEmpID":SharedManager.shareData().employeeID
            ]
        ]
        return parameters
    }
    
    func getAttendanceHistoryJsonData(fromDate: String, toDate: String, orderBy: String, forEmpID: String) -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "CorpUrl":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "CorpUrl") as! String),
                "Login":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Login") as! String),
                "Password":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Password") as! String),
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "forEmpID":forEmpID,
            "dateFrom":fromDate,
            "dateTo":toDate,
            "sortOrder":orderBy
        ]
        return parameters
    }
    
    func getTimeLineJsonData(markDate: String, empID: String) -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "request":[
                "ForEmpID":empID,
                "AttendID":"0",
                "MarkDate":markDate
            ]
        ]
        return parameters
    }
    
    func getTeamCountJsonData(subLevel: String, empID: String) -> Parameters{
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "subLevel":subLevel,
            "forEmpID":empID
        ]
        
        return parameters
    }
    
    func getLocationsJsonData() -> Parameters {

        let systemVersion = UIDevice.current.systemVersion

        let parameters: Parameters = [
            "loginData": [
                "CorpUrl":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "CorpUrl") as! String),
                //"Login":"Sunaina",
                "Login":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Login") as! String),
                "Password":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Password") as! String),
               // "Password":"a12345",
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!,
                "OSVersion": systemVersion,
                "AppVersion": App_Version,
                "OS":OS_Version
                
            ],
            ]
        return parameters
    }
    
    func getLocationDetailsJsonData(officeID: String) -> Parameters{

       // let parametersData = self.getLocationsJsonData()
        let parameters: Parameters = [
            "loginData": [
            "CorpUrl":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "CorpUrl") as! String),
            "Login":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Login") as! String),
            "Password":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Password") as! String),
            "DeviceID":SharedManager.shareData().deviceID!,
            "SessionID":SharedManager.shareData().sessionID!
            ],
            "officeID":officeID]
        return parameters
    }

    
    func getUpdateCreateLocationJsonData (officeID: String, officeName: String, officeType: String, officeCode: String, addressOne: String, addressTwo: String, city: String, pincode: String,
                                          countryCode: String, stateCode: String, isoCountryCode: String, isoStateCode: String, phoneNumber: String, latitude: String, longitude: String, length: String, base64Data: String, fileName: String, fileExtension: String ,mappedEmployeeList: NSMutableArray, geoLocation: String)  -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "locationDetail": [
                "OfficeID": officeID,
                "OfficeName": officeName,
                "OfficeType": officeType,
                "OfficeCode": officeCode,
                "Address1": addressOne,
                "Address2": addressTwo,
                "City": city,
                "PinCode": pincode,
                "CountryCode": countryCode,
                "StateCode": stateCode,
                "StateOther": "",
                "ISOCodeCountry": isoCountryCode,
                "ISOCodeState": isoStateCode,
                "PhoneNo": phoneNumber,
                "Latitude": latitude,
                "Longitude": longitude,
                "GeoLocation": geoLocation,
                "FileInfo": [
                    "Name": fileName,
                    "Extension": fileExtension,
                    "Length": length,
                    "Base64Data": base64Data
                ],
                "MappedEmployeeList": mappedEmployeeList
            ]        ]
        
        return parameters
    }
    
    
    func getLeaveRequestsJsonData(toDate: String, fromDate: String, flag: String) -> Parameters{
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "dateFrom":toDate,
            "dateTo":fromDate,
            "flag":flag
        ]
        return parameters
    }
    
    func getLeaveUpdateJsonData(requestID: String, status: String, approvalLevel: String, action: String) -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "reqID":requestID,
            "status":status,
            "approvalLevel":approvalLevel,
            "action":action
        ]
        return parameters
    }
    
    func getLeaveTypeBalanceJsonData(leaveID: Any) -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "empID":SharedManager.shareData().employeeID,
            "leaveID":leaveID
        ]
        return parameters
    }
    
    func getLeaveTypeRHLeaves() -> Parameters {
        return self.getLeaveBalanceJsonData()
    }
    
    
    func getLeaveRequestTotalDays(leaveID: Any, leaveStartDate: String, leaveEndDate: String) ->  Parameters{
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "leaveReqDetail": [
                "ForEmpID":SharedManager.shareData().employeeID,
                "LeaveID":leaveID,
                "StartDate":leaveStartDate,
                "EndDate":leaveEndDate
            ],
            ]
        return parameters
    }
    
    func getSaveLeaveRequestJsonData(leaveID: Any, leaveStartDate: String, leaveEndDate: String, totalDays: String, remarks: String, reqID: String) -> Parameters {
        
        var EmpID : String?
        
        if SharedManager.shareData().isOnBehalfLeaveApplied {
            EmpID = SharedManager.shareData().onBehalfEmpID
        }
        else
        {
            EmpID = String(SharedManager.shareData().employeeID)
            
        }
        
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "leaveReqDetail": [
//                "ForEmpID":SharedManager.shareData().employeeID,
                "ForEmpID":EmpID!,
                "LeaveID":leaveID,
                "StartDate":leaveStartDate,
                "EndDate":leaveEndDate,
                "ReqID": reqID,
                "TotalDays": totalDays,
                "Remarks": remarks
            ],
            ]
        
        print(parameters)
        return parameters
    }
    
    func getInputRequestFieldsJsonData() -> Parameters {
        let parameters: Parameters = [
            "loginData": ["CorpUrl":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "CorpUrl") as! String),
                          "Login":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Login") as! String),
                          "Password":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Password") as! String),
                          "DeviceID":SharedManager.shareData().deviceID!,
                          "SessionID":SharedManager.shareData().sessionID!
            ],
            "ReqID":"0"
        ]
        return parameters
    }
    
    
    func getEditProfileJsonData(empID: String, managerID: String, workLocationID: String) -> Parameters{
        let parameters: Parameters = [
            "loginData": ["CorpUrl":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "CorpUrl") as! String),
                          "Login":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Login") as! String),
                          "Password":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Password") as! String),
                          "DeviceID":SharedManager.shareData().deviceID!,
                          "SessionID":SharedManager.shareData().sessionID!
            ],
            "employeeData": ["EmpID":empID,
                            "ManagerID":managerID,
                            "WorkLocationID":workLocationID
            ]
        ]
        return parameters
    }
    
    
    func getPayslipJsonData(month: String) -> Parameters {
        
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "month": month
        ]
        return parameters
    }
    
    
    func markAttendance(requestType: String, attendanceID: String, latitude: String, longitude: String, location: String) -> Parameters{

        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "attendance":[
                "ReqType":requestType,
                "MarkSource":"2",
                "ForEmpID":SharedManager.shareData().employeeID,
                "AttendID":attendanceID,
                "PunchTime":"",
                "IPAddress":"",
                "Latitude":latitude,
                "Longitude":longitude,
                "Location":location,
            ]
        ]
        return parameters
    }
    
    func markAttendanceWithSelfie(requestType: String, attendanceID: String, latitude: String, longitude: String, location: String, length: String, base64Data: String) -> Parameters{
        
        
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

        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "attendance":[
                "ReqType":requestType,
                "MarkSource":"2",
                "ForEmpID":SharedManager.shareData().employeeID,
                "AttendID":attendanceID,
                "PunchTime":"",
                "IPAddress":"",
                "Latitude":latitude,
                "Longitude":longitude,
                "Location":location,
                "FileInfo":[
                    "Name":"sample..jpeg",
                    "Extension":".jpeg",
                    "Length":length,
                    "Base64Data":base64Data
                ]
            ]
        ]
        
        return parameters
    }
    
    
    func getEmpApprovalUpdateJsonData(requestID: String, status: String, approvalLevel: String, action: String) -> Parameters {
        let parameters: Parameters = [
            "loginData": [
                "CorpUrl":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "CorpUrl") as! String),
                "Login":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Login") as! String),
                "Password":(((SharedManager.shareData().dictForUserData as NSDictionary).value(forKey: "loginCred") as! NSDictionary).value(forKey: "Password") as! String),
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "reqID":requestID,
            "reqStatus":status,
            "approvalLevel":approvalLevel,
            "action":action
        ]
        return parameters
    }
    
  
    
    func getCorpEmpParam() ->  Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ]
        ]
        return parameters
    }
    
    func getLeaveParam(str: String) ->  Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "fromCount" : "1",
            "toCount": "-1",
            "matchStr": str
        ]
        return parameters
    }
    func UploadProfile(name:String , extention: String,length: String, base64Data: String) ->  Parameters {
        let parameters: Parameters = [
            "loginData": [
                "DeviceID":SharedManager.shareData().deviceID!,
                "SessionID":SharedManager.shareData().sessionID!
            ],
            "FileInfo":[
                "Name":"sample..jpeg",
                "Extension":".jpeg",
                "Length":length,
                "Base64Data":base64Data
            ]
        ]
        return parameters
    }
}




