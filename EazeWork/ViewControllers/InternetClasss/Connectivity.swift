//
//  Connectivity.swift
//  EazeWork
//
//  Created by Mohit Sharma on 19/12/17.
//  Copyright © 2017 User1. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
