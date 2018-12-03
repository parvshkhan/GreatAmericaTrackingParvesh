//
//  ViewController.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 06/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import UIKit
import Alamofire

class ValidateNumberViewController: UIViewController {
    
    var finalNumber: String?
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var txtCountryCode: CountryPickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func actionSendOTP(_ sender: UIButton) {
  
        if (txtMobileNumber.text?.isPhoneNumber) == true{
            print("⚽️ isPhoneNumber")
            print("✴️ \(txtMobileNumber.text!) \(txtCountryCode.text!)")
            let cCode = fetchCountryCode(pickerDate: txtCountryCode.text!)
            finalNumber = "\(cCode)\(txtMobileNumber.text!)"
            print("⚽️ \(finalNumber!)")
           
            self.hitValidateNumber(driverNumber: finalNumber!)
        }
        if (txtMobileNumber.text?.isBlank) == true{
             print("⚽️ isBlank")
            self.showAlert(titleMsg: "Empty", alertMsg: "Please enter a  number")
        }
        if (txtMobileNumber.text?.isPhoneNumber) == false{
            print("⚽️ isPhoneNumber false")
            self.showAlert(titleMsg: "Invalid", alertMsg: "Please enter a valid number")
        }
        
    }
    
}

extension ValidateNumberViewController{
    //MARK :- FUNCTIONS
    func fetchCountryCode(pickerDate: String)-> String{
        let separatedData = pickerDate.components(separatedBy: " ")
        print("🔥",separatedData[2])
        return "\(separatedData[2])"
    }
    
    func hitValidateNumber(driverNumber: String){
        let parameter = ["driverno":"\(driverNumber)"] as [String:Any]
        Alamofire.request(Api.validateNumber.url, method: .post, parameters: parameter, encoding: JSONEncoding.default)
        .responseJSON { (responsee) in
           
                if "\(responsee.result)" == "SUCCESS"{
                     print("🔥",responsee)
                    let responseDic = responsee.result.value as! [String: Any]
                    let apiStatus = responseDic["isSuccess"] as! Bool
                    let apiMessage = responseDic["message"] as! String
                    if apiMessage == "Valid Number"{
                        userDefaultValidMobileNumber = self.finalNumber
                    }
                    
                    if apiStatus == false {
                        self.showAlert(titleMsg: "Unregistered", alertMsg: "\(apiMessage)")
                    }
                    if apiStatus == true{
                        // do required things
                    let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerificationCodeViewController") as! VerificationCodeViewController
                        
                        nextViewController.number = self.finalNumber!
                  self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
            }
        }

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
extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.characters.count>=6 && self.characters.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
   
}
