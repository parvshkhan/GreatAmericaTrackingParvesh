//
//  Api.swift
//  influencerNetwork
//
//  Created by Shubham on 17/08/18.
//  Copyright © 2018 Shubham. All rights reserved.
//
//http://192.168.0.61/InfluencerAPI/Register
//https://docs.google.com/spreadsheets/d/1YX4oEHjMBjM_HQAYmJYyYKSdbTdMgoPqw76IyGPDBLg/edit?ts=5b7ec21b#gid=0

import Foundation
import UIKit
enum Server{
    //type of server where the link can be accessed
    case siv
    case local
    case sandBox
    case live
    // we just have to change the current type to change the URL
    static let current: Server = .local //.live
    static let baseRoot = "driverapp/"
    static var path = current.base + baseRoot
    var base: String{
        switch  self {
        case .siv:
            return ""
            
        case .local:
            return "http://greatamericatracking.com/"
            
        case .sandBox:
            return ""
            
        case .live:
            return "http://greatamericatracking.com/"
            
        }
    }
}

enum Api{
    //this contains the number of Api u will be using
    //MARK:- 10 Api'S
    case validateNumber
    case validateOTP
    case shipmentList
    case getShipperReceiverList
    case checkStatus
    case reachedCheck
    case orderTracking
    case sendDocument
    case nearbyCheck
    case rejectOrder
    
    var url: URL {
        switch self {
        //this contains the URL of the cases that are there
        case .validateNumber: return URL(string: Server.path + "ValidateNumber")!
        case .validateOTP: return URL(string: Server.path + "validateOTP")!
        case .shipmentList: return URL(string: Server.path + "ShipmentList")!
        case .getShipperReceiverList: return URL(string: Server.path + "getShipperReceiverList")!
       case .checkStatus: return URL(string: Server.path + "CheckStatus")!
       case .reachedCheck: return URL(string: Server.path + "reachedCheck")!
       case .orderTracking: return URL(string: Server.path + "orderTracking")!
       case .sendDocument: return URL(string: Server.path + "sendDocument")!
       case .nearbyCheck: return URL(string: Server.path + "nearbyCheck")!
       case .rejectOrder: return URL(string: Server.path + "RejectOrder")!
        }
    }
    
}


func isApiSuccess(response: AnyObject) -> Bool {
    if let isSuccess = response["isSuccess"] as? Bool? {
        print("🌳🌳🌳 isApiSussess function called")
        return isSuccess!
    }
    return false
}



func apiResponseMesssage(response: AnyObject) -> String{
    var message: String?
    if let msg = response["message"] as? String? {
        print("📝📝📝 apiResponseMessage is called",msg!)
        message = msg
    }
    return message!
}


