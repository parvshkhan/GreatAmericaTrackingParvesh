//
//  ShipmentInformationViewController.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 08/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import UIKit
import Alamofire

class ShipmentInformationViewController: UIViewController {

    var orderIddd: Int?
    
    var apiReceiverListResponse: ApiReceiverListResponse?
    var apiShipperListResponse: ApiShipperListResponse?
    
    @IBOutlet weak var lblPickerName: UILabel!
    @IBOutlet weak var lblPickerAddress: UILabel!
    @IBOutlet weak var lblPickerDate: UILabel!
    @IBOutlet weak var lblPickUpNumber: UILabel!
    @IBOutlet weak var lblShipperNote: UILabel!
    @IBOutlet weak var lblPickerShipperNumber: UILabel!
    
    
    
    @IBOutlet weak var lblReceiverName: UILabel!
    @IBOutlet weak var lblReceiverAddress: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var lblDeliveryNumber: UILabel!
    @IBOutlet weak var lblReceiverNote: UILabel!
    @IBOutlet weak var lblReceiverPhoneNumber: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      hitApiShipperReceiverList(orderId: orderIddd!)
   
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




extension ShipmentInformationViewController{
    
    
    
    func hitApiShipperReceiverList(orderId: Int){
        let parameter = ["orderid":"\(orderIddd!)"] as [String: Any]
        print("🌕\(parameter)")
        
        Alamofire.request(Api.getShipperReceiverList.url,  method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { (responsee) in
                
                if "\(responsee.result)" == "SUCCESS"{
                    print("🛢🛢🛢",responsee)
                    let responseDic = responsee.result.value as! [String: Any]
                    let apiStatus = responseDic["isSuccess"] as! Bool
                    let apiMessage = responseDic["message"] as! String
                    let apiReceiverList = responseDic["ReceiverList"] as! [Any]
                    let apiShipperList = responseDic["ShipperList"] as! [Any]
                    print("🎲", apiReceiverList)
                    print("1️⃣", apiShipperList)
                    self.apiReceiverListResponse = ApiReceiverListResponse(response: apiReceiverList as AnyObject)
                    self.apiShipperListResponse = ApiShipperListResponse(response: apiShipperList as AnyObject)
                    print("🎲", self.apiReceiverListResponse)
                    print("1️⃣", self.apiShipperListResponse)
                      DispatchQueue.main.async {
                        self.fillDataInLbl()
                    }
                }
        }
    }
    
    
    
    func fillDataInLbl(){
      //  if self.apiReceiverListResponse != nil && self.apiShipperListResponse != nil{
            let responseReceiverDict = apiReceiverListResponse?.receiverListResponse[0]
          let responseShipperDict = apiShipperListResponse?.shipperListResponse[0]
            
            
            lblPickerName.text! = (responseShipperDict?.shipperListName)!
            lblPickerAddress.text! =  (responseShipperDict?.shipperListAddress)!
            lblPickerDate.text! =  (responseShipperDict?.shipperListPickupDate)!
             lblPickUpNumber.text! =   (responseShipperDict?.shipperListLoadnumber)!
             lblShipperNote.text! = (responseShipperDict?.shipperListReceiverNote)!
            lblPickerShipperNumber.text! =   (responseShipperDict?.shipperListPhoneNumber)!
            
            
            lblReceiverName.text! = (responseReceiverDict?.receiverListName)!
            lblReceiverAddress.text! = (responseReceiverDict?.receiverListAddress)!
             lblDeliveryDate.text! = (responseReceiverDict?.receiverListDeliveryDate)!
             lblDeliveryNumber.text! =  (responseReceiverDict?.receiverListPickupNumber)!
             lblReceiverNote.text! = (responseReceiverDict?.receiverListReceiverNote)!
            lblReceiverPhoneNumber.text! = (responseReceiverDict?.receiverListPhoneNumber)!
       // }
    }
}
