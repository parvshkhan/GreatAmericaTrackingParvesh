//
//  UserDefaultValidMobileNumber.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 09/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import Foundation


var userDefaultValidMobileNumber: String? {
    get {
        if (UserDefaults.standard.object(forKey: "userDefaultValidMobileNumber") != nil) {
            if let data = UserDefaults.standard.object(forKey: "userDefaultValidMobileNumber") as? String {
                print("🥋",data)
                return data
            } else {
                return nil
            }
        }
        return nil
    }
    set {
        let ud = UserDefaults.standard
        ud.set( newValue, forKey: "userDefaultValidMobileNumber")
        ud.synchronize()
    }
}
var userDefaultOrderId: Int? {
    get {
        if (UserDefaults.standard.object(forKey: "userDefaultOrderId") != nil) {
            if let data = UserDefaults.standard.object(forKey: "userDefaultOrderId") as? Int {
                print("🥋🥋",data)
                return data
            } else {
                return nil
            }
        }
        return nil
    }
    set {
        let ud = UserDefaults.standard
        ud.set( newValue, forKey: "userDefaultOrderId")
        ud.synchronize()
    }
}

var userDefaultIsOTPVerified: Bool? {
    get {
        if (UserDefaults.standard.object(forKey: "userDefaultIsOTPVerified") != nil) {
            if let data = UserDefaults.standard.object(forKey: "userDefaultIsOTPVerified") as? Bool {
                print("🥋",data)
                return data
            } else {
                return nil
            }
        }
        return nil
    }
    set {
        let ud = UserDefaults.standard
        ud.set( newValue, forKey: "userDefaultIsOTPVerified")
        ud.synchronize()
    }
}
