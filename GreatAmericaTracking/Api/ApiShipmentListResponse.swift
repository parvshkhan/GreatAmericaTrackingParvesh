//
//  ApiShipmentListResponse.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 09/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import Foundation

struct ApiShipmentListResponse {
    struct ShipmentList {
        // 6 values
        var orderId: Int?
        var statusId: Int?
        var destinationLat: String?
        var destinationLng: String?
        var receiverId: Int?
        var deliveryDate: String?
        

        init(dictionary: NSDictionary) {
            orderId = dictionary["orderid"] as? Int
            statusId = dictionary["statusid"] as? Int
            destinationLat = dictionary["DestinationLat"] as? String
            destinationLng = dictionary["DestinationLng"] as? String
            receiverId = dictionary["ReceiverId"] as? Int
            deliveryDate = dictionary["delivery_date"] as? String
        }
    }
    
    var shipmentList: [ShipmentList] = []
     init(response: AnyObject)
    {
        if let categoryList = response as? [Any] // shipmentList data
        {
            for object in categoryList
            { 
                let someList = ShipmentList(dictionary: (object as? NSDictionary)!)
                shipmentList.append(someList)
                print("🍄🍄🍄 allEvents 🍄🍄🍄",shipmentList)
                print("🚠🚠🚠 someList 🚠🚠🚠",someList)
            }
        }
    }
    
}
