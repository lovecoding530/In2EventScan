//
//  AppContent.swift
//  Spankrr
//
//  Created by Kangtle on 1/15/18.
//  Copyright © 2018 Kangtle. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftyJSON

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
let USERDEFAULTS = UserDefaults.standard
let LOC_MANAGER = CLLocationManager()

//Colors
let BACKGROUND_COLOR_1 = UIColor.white

let RED_COLOR = UIColor.init(rgb: 0xD0021B)
let LIGHT_GRAY = UIColor.init(rgb: 0xF1F2F6)
let LIGHT_GREEN = UIColor.green
let GREEN = UIColor.init(rgb: 0x2EB872)
let YELLOW = UIColor.init(rgb: 0xFCB000)

//APP

struct Contents {
    struct Api {
        static let root = "http://workers.hetsysteem.com/api/1" //demo server
//        static let root = "https://api.in2event.com/api/1" //production server
        static let authorize = "\(root)/authorize"
        static let barcodes = "\(root)/barcodes"
    }
    
    struct Barcode {
        static let barcode = "barcode"
        static let scannedDateTime = "scan_datetime"
        static let message = "message"
        static let customer = "customer"
        static let scanStatus = "scan_status"
        static let product = "product"
        static let success = "success"
        static let response = "response"
    }
    
    static var cachedBarcodes = [JSON]()
    static var scannedBarcodes = [String]()
}
