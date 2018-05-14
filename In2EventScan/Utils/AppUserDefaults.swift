//
//  AppUserDefaults.swift
//  Spankrr
//
//  Created by Kangtle on 1/15/18.
//  Copyright © 2018 Kangtle. All rights reserved.
//

import UIKit

class AppUserDefaults {

    static let HAS_RUN_BEFORE = "HAS_RUN_BEFORE"
    static let LOGIN_CODE = "LOGIN_CODE"
    static let ACCESS_TOKEN = "ACCESS_TOKEN"

    static let event_dates = "event_dates"
    static let event_logo = "event_logo"
    static let event_name = "event_name"
    static let event_city = "event_city"

    static let IS_LOGGED_IN = "IS_LOGGED_IN"
    static let CACHED_BARCODES = "CACHED_BARCODES"

    static func isFirstLunch() -> Bool {
        let isFirstLunch = !USERDEFAULTS.bool(forKey: HAS_RUN_BEFORE)
        if isFirstLunch {
            USERDEFAULTS.set(true, forKey: HAS_RUN_BEFORE)
        }
        return isFirstLunch
    }
    
    static var loginCode: String {
        get{
            return USERDEFAULTS.string(forKey: LOGIN_CODE) ?? ""
        }
        set{
            USERDEFAULTS.set(newValue, forKey: LOGIN_CODE)
        }
    }

    static var accessToken: String {
        get{
            return USERDEFAULTS.string(forKey: ACCESS_TOKEN) ?? ""
        }
        set{
            USERDEFAULTS.set(newValue, forKey: ACCESS_TOKEN)
        }
    }
    
    static var eventDates: String {
        get{
            return USERDEFAULTS.string(forKey: event_dates) ?? ""
        }
        set{
            USERDEFAULTS.set(newValue, forKey: event_dates)
        }
    }
    
    static var eventLogo: String {
        get{
            return USERDEFAULTS.string(forKey: event_logo) ?? ""
        }
        set{
            USERDEFAULTS.set(newValue, forKey: event_logo)
        }
    }
    
    static var eventName: String {
        get{
            return USERDEFAULTS.string(forKey: event_name) ?? ""
        }
        set{
            USERDEFAULTS.set(newValue, forKey: event_name)
        }
    }

    static var eventCity: String {
        get{
            return USERDEFAULTS.string(forKey: event_city) ?? ""
        }
        set{
            USERDEFAULTS.set(newValue, forKey: event_city)
        }
    }

    static var isLoggedin: Bool {
        get{
            return USERDEFAULTS.bool(forKey: IS_LOGGED_IN)
        }
        set{
            USERDEFAULTS.set(newValue, forKey: IS_LOGGED_IN)
        }
    }
    
    static var queuedBarcodes: [String] {
        get {
            return USERDEFAULTS.array(forKey: CACHED_BARCODES) as? [String] ?? []
        }
        set {
            USERDEFAULTS.set(newValue,forKey: CACHED_BARCODES)
        }
    }
}
