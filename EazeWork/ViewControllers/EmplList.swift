//
//  EmplList.swift
//  EazeWork
//
//  Created by Mohit Sharma on 16/12/17.
//  Copyright © 2017 User1. All rights reserved.
//

import Foundation

class EmpList {
    
    var EmpCode : String?
    var EmpID : String?
    var Name  : String?
    
    //                let errorCode: Int = (getEmpPendingApprovalCountResult?["ErrorCode"] as? Int)!

    init(dict: NSDictionary?) {
        if let dict = dict {
            self.EmpCode = dict.value(forKey: "EmpCode") as? String
           // self.EmpID = dict.value(forKey: "EmpID") as? String
            
            let emp_ID : Int = (dict.value(forKey: "EmpID") as? Int
                )!
            self.EmpID = String(emp_ID)
            
            self.Name = dict.value(forKey: "Name") as? String
            
        }
    }
}
