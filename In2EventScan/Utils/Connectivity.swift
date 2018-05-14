//
//  Connectivity.swift
//  In2EventScan
//
//  Created by Admin on 3/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return APPDELEGATE.reachabilityManager!.isReachable
    }
}
