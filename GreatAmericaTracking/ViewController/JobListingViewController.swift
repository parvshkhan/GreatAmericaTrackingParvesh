//
//  JobListingViewController.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 06/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


class JobListingViewController: UIViewController {

    //MARK:- VARIABLES
    var locationManager:CLLocationManager!
   // var location : CLLOcation
    var apiShipmentListResponse: ApiShipmentListResponse?
    var currentLat: String?
    var currentLong: String?
    var destinationLat: String?
    var destinationLong: String?
    var address: String?
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationItem.hidesBackButton = true
      self.navigationController?.isNavigationBarHidden = true
        tableView.dataSource = self
        tableView.delegate = self
         self.tableView.tableFooterView = UIView(frame: .zero)
        DispatchQueue.main.async {
            self.hitApiShipmentList()
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    self.hidesBottomBarWhenPushed = true
   self.navigationController?.isNavigationBarHidden = true
        DispatchQueue.main.async {
            self.hitApiShipmentList()
            self.tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func actionLogout(_ sender: UIButton) {
        showLogoutAlert(titleMsg: "Log out", alertMsg: "Would you like to log out from this app?")
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

extension JobListingViewController:UITableViewDelegate{
    
}

extension JobListingViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.apiShipmentListResponse?.shipmentList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let row = indexPath.row
         print("🚹 Selected Row: \(row+1)")
        
         let cell: JobListingCell = tableView.dequeueReusableCell(withIdentifier: JobListingCell.identifier , for: indexPath as IndexPath) as! JobListingCell
          let responseDict = apiShipmentListResponse?.shipmentList[indexPath.row]
        
      cell.btnAccept.addTarget(self, action: #selector(acceptBtnTapped), for:.touchUpInside)
        cell.btnView.addTarget(self, action: #selector(viewBtnTapped), for:.touchUpInside)
       cell.btnReject.addTarget(self, action: #selector(rejectBtnTapped), for:.touchUpInside)
        cell.btnUpload.addTarget(self, action: #selector(uploadBtnTapped), for:.touchUpInside)
        
        cell.btnAccept.tag = row
        cell.btnView.tag = row
        cell.btnReject.tag = row
        cell.btnUpload.tag = row
        
        cell.lblDate.text! = responseDict?.deliveryDate ?? "00-00-0000"
        cell.lbliD.text! = "\(responseDict?.orderId! ?? 00)"
        cell.btnUpload.isHidden = true

       //     cell.btnAccept.isUserInteractionEnabled = false
             if  responseDict?.statusId! == 1 {
                if row == 0 {
                    cell.btnAccept.setTitle("ACCEPT", for: .normal)
                    cell.btnAccept.backgroundColor = UIColor.colorGreenAccept
                    cell.viewColor.backgroundColor =  UIColor.colorGreenAccept
                }
             cell.btnAccept.setTitle("UPCOMING", for: .normal)
             cell.btnAccept.backgroundColor = UIColor.colorRedUpcoming
             cell.viewColor.backgroundColor =  UIColor.colorRedUpcoming
             }
            if  responseDict?.statusId! == 2 {
                cell.btnAccept.setTitle("ON THE WAY", for: .normal)
                cell.btnAccept.backgroundColor = UIColor.colorBlueOnTheWay
                cell.viewColor.backgroundColor =  UIColor.colorBlueOnTheWay
                cell.btnReject.isHidden = true
            }
            if  responseDict?.statusId! == 3 {
                cell.btnAccept.setTitle("REACHED", for: .normal)
                cell.btnAccept.backgroundColor = UIColor.colorYellowReached
                cell.viewColor.backgroundColor =  UIColor.colorYellowReached
                cell.btnUpload.isHidden = false
            }
            if  responseDict?.statusId! == 5 {
                cell.btnAccept.setTitle("NEAR BY", for: .normal)
                cell.btnAccept.backgroundColor = UIColor.colorYellowReached
                cell.viewColor.backgroundColor =  UIColor.colorYellowReached
                cell.btnUpload.isHidden = false
            }
        
        return cell
    }
    
    @objc func uploadBtnTapped(sender: UIButton){
        //  let buttonTag = sender.tag
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "UploadDocumentViewController") as! UploadDocumentViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
     @objc func rejectBtnTapped(sender: UIButton){
        let buttonTag = sender.tag
        print("🎂",buttonTag)
        //hitApiRejectOrder
        let indexPath = NSIndexPath(row: buttonTag, section: 0)
        let responseDict = apiShipmentListResponse?.shipmentList[indexPath.row]
         userDefaultOrderId = responseDict?.orderId!
        self.showRejectAlert()
    }
    
   @objc func acceptBtnTapped(sender: UIButton){
      let buttonTag = sender.tag
        print("🎂",buttonTag)
    
    let indexPath = NSIndexPath(row: buttonTag, section: 0)
    let cell = tableView.cellForRow(at: indexPath as IndexPath) as! JobListingCell
    let responseDict = apiShipmentListResponse?.shipmentList[indexPath.row]
     destinationLat = responseDict?.destinationLat
     destinationLong = responseDict?.destinationLng
    
     userDefaultOrderId = responseDict?.orderId!
    print("😭",userDefaultOrderId!)
    cell.btnAccept.setTitle("ON THE WAY", for: .normal)
    cell.btnAccept.backgroundColor = UIColor.colorBlueOnTheWay
    cell.viewColor.backgroundColor =  UIColor.colorBlueOnTheWay
    cell.btnReject.isHidden = true
    self.hitApiCheckStatus()
     self.determineMyCurrentLocation()
    
    //hitOrderTracking
    }
    
    @objc func viewBtnTapped(sender: UIButton){
        let buttonTag = sender.tag
     let dic = apiShipmentListResponse?.shipmentList[buttonTag]
        let orderIdd = dic?.orderId!
        userDefaultOrderId = dic?.orderId!
       // self.hitApiShipperReceiverList(orderId: (dic?.orderId)!)
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShipmentInformationViewController") as! ShipmentInformationViewController
        nextViewController.orderIddd = orderIdd
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

class JobListingCell : UITableViewCell{
    static let identifier = "JobListingCell"
    
    @IBOutlet weak var lbliD: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnReject: UIButton!
}

//MARK:- CLLocationManagerDelegate
extension JobListingViewController: CLLocationManagerDelegate{
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
      
        print("🎯🎯user latitude = \(userLocation.coordinate.latitude)")
        print("🎯🎯user longitude = \(userLocation.coordinate.longitude)")
        self.reverseGeoCode(location: userLocation)
      
        self.currentLat = "\(userLocation.coordinate.latitude)"
        self.currentLong = "\(userLocation.coordinate.longitude)"
         self.calculateDistance(currentLat: self.currentLat!,  currentLongL: self.currentLong!, destLat: self.destinationLat!, destLong: self.destinationLong!)
        
      
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}


//MARK:- FUNCTIONS
extension JobListingViewController{
    func showRejectAlert(){
        let alertController = UIAlertController(title: "Reject", message: "Would you like to reject this shipment?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
            self.hitApiRejectOrder()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    func calculateDistance(currentLat: String, currentLongL: String, destLat: String, destLong: String){
     
        let currentCoordinate = CLLocation(latitude: Double(currentLat)!, longitude: Double(currentLongL)!)
        let destiCoordinate = CLLocation(latitude: Double(destLat)!, longitude: Double(destLong)!)
        
        let distanceInMeters = currentCoordinate.distance(from: destiCoordinate) // result is in meters
          let distanceInKiloMeters = distanceInMeters/1000 // result is in Kilo meters
        print("🌈 \(distanceInMeters) 🌈🌈\(distanceInKiloMeters)")
        if distanceInKiloMeters == 5 {
            //nearby check api as 5 Km left
            self.hitApiNearbyCheck()
        }
        if(distanceInMeters == 100)
        {
           //reached check as 100meters left
            self.hitApiReachedCheck()
        }
        
    }
    
    
    
    func reverseGeoCode(location : CLLocation){
        CLGeocoder().reverseGeocodeLocation(location) { (placeMark, error) in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placeMark?.count)! > 0 {
                
                let pm = placeMark![0].thoroughfare
                
                print("UMBRELLA", pm)
                
                if pm == nil{
                    
                    //MARK: implemet Api Here with Location  = "UnNamed Road"
                    print("🎯🎯🎯 PlaceName \(pm)")
                     // self.address = pm
                    self.hitApiOrderTracking(address: "UnNamed Road")
                }else{
                    // MARK:- Implemet Api locationName = Pm
                        print("🎯🎯🎯 PlaceName \(pm)")
                
                    self.hitApiOrderTracking(address: pm!)
                 
                 
                    }
             }
        }
    }
    
    func showLogoutAlert(titleMsg: String,alertMsg: String){
        let alertController = UIAlertController(title: "\(titleMsg)", message: "\(alertMsg)", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
            //ValidateNumberViewController
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ValidateNumberViewController") as! ValidateNumberViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        })
        
        alertController.addAction(cancelAction)
         alertController.addAction(yesAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlert(titleMsg: String,alertMsg: String){
        let alertController = UIAlertController(title: "\(titleMsg)", message: "\(alertMsg)", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        
        
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension JobListingViewController{
    //MARK:- API FUNCTIONS
    func hitApiReachedCheck(){
        let parameter = ["Orderid":"\(userDefaultOrderId!)"] as [String: Any]
        print("🌕\(parameter)")
        Alamofire.request(Api.reachedCheck.url, method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { (responsee) in
                
                if "\(responsee.result)" == "SUCCESS"{
                    print("hitApiReachedCheck 1️⃣",responsee)
                    
                    let responseDic = responsee.result.value as! [String: Any]
                    let apiStatus = responseDic["isSuccess"] as! Bool
                    let apiMessage = responseDic["message"] as! String
                    
                      print("hitApiReachedCheck apiStatus 1️⃣ \(apiStatus)   and \(apiMessage)")
                }
        }
    }
    
    func hitApiNearbyCheck(){
        let parameter = ["orderid":"\(userDefaultOrderId!)"] as [String: Any]
        print("🌕\(parameter)")
        Alamofire.request(Api.nearbyCheck.url, method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { (responsee) in
                
                if "\(responsee.result)" == "SUCCESS"{
                    print("hitApiNearbyCheck 1️⃣",responsee)
                    
                    let responseDic = responsee.result.value as! [String: Any]
                    let apiStatus = responseDic["isSuccess"] as! Bool
                    let apiMessage = responseDic["message"] as! String
                    
                    
                }
        }
    }
    func hitApiOrderTracking(address : String){
        let parameter = ["orderid":"\(userDefaultOrderId!)","lat":"\(currentLat!)","lng":"\(currentLong!)","address": address] as [String: Any]
        print("🌕\(parameter)")
        Alamofire.request(Api.orderTracking.url, method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { (responsee) in
                
                if "\(responsee.result)" == "SUCCESS"{
                    print("1️⃣🌕1️⃣",responsee)
                    
                    let responseDic = responsee.result.value as! [String: Any]
                    let apiStatus = responseDic["isSuccess"] as! Bool
                    
                    
                }
        }
    }
    
    
    func hitApiCheckStatus(){
        let parameter = ["Orderid":"\(userDefaultOrderId!)"]
        print("🌕🌕🌕🌕\(parameter)")
        Alamofire.request(Api.checkStatus.url, method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { (responsee) in
                
                if "\(responsee.result)" == "SUCCESS"{
                    print("🌕🌕🌕🌕hitApiCheckStatus 1️⃣",responsee)
                   
                    let responseDic = responsee.result.value as! [String: Any]
                    let apiStatus = responseDic["isSuccess"] as! Bool
                    let apiMessage = responseDic["message"] as! String
                    
                     print("hitApiCheckStatus apiStatus 🌕1️⃣ \(apiStatus)   and 🌕1️⃣ \(apiMessage)")
                }
        }
    }
    
    
    func hitApiShipmentList(){
        
        let parameter = ["driverno":"\(userDefaultValidMobileNumber!)"] as [String: Any]
        print("🌕\(parameter)")
        HUD.show(.progress)
        Alamofire.request(Api.shipmentList.url, method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { (responsee) in
                HUD.hide()
                if "\(responsee.result)" == "SUCCESS"{
                    print("1️⃣",responsee)
                    
                    let responseDic = responsee.result.value as! [String: Any]
                    let apiStatus = responseDic["isSuccess"] as! Bool
                    let apiMessage = responseDic["message"] as! String
                    if apiMessage == "No Shipment Left"{
                        self.showAlert(titleMsg: "No Shipment Left", alertMsg: "")
                    }
                    if apiMessage == "Shipment List"{
                        let apiShipmentList = responseDic["Shipment_List"] as! [Any]
                        
                        self.apiShipmentListResponse = ApiShipmentListResponse(response: apiShipmentList as AnyObject)
                        print("🌕1️⃣ \(self.apiShipmentListResponse)")
                        userDefaultOrderId = self.apiShipmentListResponse?.shipmentList[0].orderId!
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
        }
    }
    
    func hitApiRejectOrder(){
        let parameter = ["orderid":"\(userDefaultOrderId!)"] as [String: Any]
        print("🌕\(parameter)")
        Alamofire.request(Api.rejectOrder.url, method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { (responsee) in
                
                if "\(responsee.result)" == "SUCCESS"{
                    print("hitApiRejectOrder 1️⃣",responsee)
                    DispatchQueue.main.async {
                        self.hitApiShipmentList()
                        self.tableView.reloadData()
                    }
                    let responseDic = responsee.result.value as! [String: Any]
                    let apiStatus = responseDic["isSuccess"] as! Bool
                    let apiMessage = responseDic["message"] as! String
                    
                   
                    print("hitApiRejectOrder apiStatus 🌕1️⃣ \(apiStatus)   and 🌕1️⃣ \(apiMessage)")
                }
        }
    }
    
    
}

/*
 
 if row == 0 {
 if  responseDict?.statusId! == 1 {
 cell.btnAccept.setTitle("ACCEPT", for: .normal)
 cell.btnAccept.backgroundColor = UIColor.colorGreenAccept
 cell.viewColor.backgroundColor =  UIColor.colorGreenAccept
 }
 else {
 /* if  responseDict?.statusId! == 1 {
 cell.btnAccept.setTitle("UPCOMING", for: .normal)
 cell.btnAccept.backgroundColor = UIColor.colorRedUpcoming
 cell.viewColor.backgroundColor =  UIColor.colorRedUpcoming
 } */
 if  responseDict?.statusId! == 2 {
 cell.btnAccept.setTitle("ON THE WAY", for: .normal)
 cell.btnAccept.backgroundColor = UIColor.colorBlueOnTheWay
 cell.viewColor.backgroundColor =  UIColor.colorBlueOnTheWay
 //cell.btnReject.isHidden = true
 }
 if  responseDict?.statusId! == 3 {
 cell.btnAccept.setTitle("REACHED", for: .normal)
 cell.btnAccept.backgroundColor = UIColor.colorYellowReached
 cell.viewColor.backgroundColor =  UIColor.colorYellowReached
 cell.btnUpload.isHidden = false
 }
 if  responseDict?.statusId! == 5 {
 cell.btnAccept.setTitle("NEAR BY", for: .normal)
 cell.btnAccept.backgroundColor = UIColor.colorYellowReached
 cell.viewColor.backgroundColor =  UIColor.colorYellowReached
 cell.btnUpload.isHidden = false
 }
 }
 }
 
 */
