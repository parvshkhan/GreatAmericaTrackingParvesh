//
//  ApiShipperReceiverListResponse.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 10/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import Foundation

struct ApiShipperListResponse{

        var shipperListResponse: [ShipperListResponse] = []

        struct ShipperListResponse {
            var shipperListAddress: String?
            var shipperListId: Int?
            var shipperListLat: String?
            var shipperListLng: String?
            var shipperListLoadnumber: String?
            var shipperListName: String?
            var shipperListOrderId: Int?
            var shipperListPhoneNumber: String?
            var shipperListPickupDate: String?
            var shipperListReceiverNote: String?
            
            
            init(dictionary: NSDictionary) {
                shipperListAddress = dictionary["address"] as? String
                shipperListId = dictionary["id"] as? Int
                shipperListLat = dictionary["lat"] as? String
                shipperListLng = dictionary["lng"] as? String
                shipperListLoadnumber = dictionary["loadnumber"] as? String
                shipperListName = dictionary["name"] as? String
                shipperListOrderId = dictionary["orderid"] as? Int
                shipperListPhoneNumber = dictionary["phonenumber"] as? String
                shipperListPickupDate = dictionary["pickup_date"] as? String
                shipperListReceiverNote = dictionary["shippernote"] as? String
            }
        }
        
    init(response: AnyObject){
            if let categoryList = response as? [Any] // shipmentList data
            {
                for object in categoryList
                {
                    let someList = ShipperListResponse(dictionary: (object as? NSDictionary)!)
                    shipperListResponse.append(someList)
                    print("🍄🍄🍄 allEvents 🍄🍄🍄",shipperListResponse)
                    print("🚠🚠🚠 someList 🚠🚠🚠",someList)
                }
            }
         
    }
  
}






struct ApiReceiverListResponse{
    
     var receiverListResponse: [ReceiverListResponse] = []
    
    struct ReceiverListResponse {
        var receiverListAddress: String?
        var receiverListDeliveryDate: String?
        var receiverListId: Int?
        var receiverListLat: String?
        var receiverListLng: String?
        var receiverListName: String?
        var receiverListOrderId: Int?
        var receiverListPhoneNumber: String?
        var receiverListPickupNumber: String?
        var receiverListReceiverNote: String?
        
        
        init(dictionary: NSDictionary) {
            receiverListAddress = dictionary["address"] as? String
            receiverListDeliveryDate = dictionary["delivery_date"] as? String
            receiverListId = dictionary["id"] as? Int
            receiverListLat = dictionary["lat"] as? String
            receiverListLng = dictionary["lng"] as? String
            receiverListName = dictionary["name"] as? String
            receiverListOrderId = dictionary["orderid"] as? Int
            receiverListPhoneNumber = dictionary["phonenumber"] as? String
            receiverListPickupNumber = dictionary["pickup_number"] as? String
            receiverListReceiverNote = dictionary["receiver_note"] as? String
        }
    }
    
    
    init(response: AnyObject)
    {
        if let categoryList = response as? [Any] // shipmentList data
        {
            for object in categoryList
            {
                let someList = ReceiverListResponse(dictionary: (object as? NSDictionary)!)
                receiverListResponse.append(someList)
                print("🍄🍄🍄 allEvents 🍄🍄🍄",receiverListResponse)
                print("🚠🚠🚠 someList 🚠🚠🚠",someList)
            }
        }
    }
}
