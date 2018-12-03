//
//  VerificationCodeViewController.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 06/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import UIKit
import Alamofire

class VerificationCodeViewController: UIViewController {
    
    var number: String?
    var otpString: String?
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtSecond: UITextField!
    @IBOutlet weak var txtThird: UITextField!    
    @IBOutlet weak var txtFourth: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNumber.text = "Please enter the verificatio code sent to \(number!)"
        print("🍯\(number!) \(userDefaultValidMobileNumber!)")
        self.txtFirst.delegate = self
        self.txtSecond.delegate = self
        self.txtThird.delegate = self
        self.txtFourth.delegate = self
         // Do any additional setup after loading the view.
    }
  /*  override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    } */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func actionVerifyOTP(_ sender: UIButton) {
        if txtFirst.text?.isBlank == true || txtSecond.text?.isBlank == true  ||  txtThird.text?.isBlank == true  ||  txtFourth.text?.isBlank == true{
            self.showAlert(titleMsg: "Empty", alertMsg: "Please enter the OTP")
        }
        if txtFirst.text?.isBlank == false && txtSecond.text?.isBlank == false && txtThird.text?.isBlank == false &&   txtFourth.text?.isBlank == false{
             otpString = txtFirst.text! + txtSecond.text! + txtThird.text! + txtFourth.text!
            if otpString?.isBlank  == false{
                self.hitApiValidateOTP(mobNumber: number!, otp: otpString!)
            }
        }
    }
}

extension VerificationCodeViewController {
    // MARK:- FUNCTIONS
    func hitApiValidateOTP(mobNumber: String , otp: String){
        let parameter = ["driverno":"\(number!)" ,"otp":"\(otpString!)"] as [String:Any]
        print("🌕\(parameter)")
       Alamofire.request(Api.validateOTP.url, method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { (responsee) in
                
                if "\(responsee.result)" == "SUCCESS"{
                    print("1️⃣",responsee)
                    let responseDic = responsee.result.value as! [String: Any]
                    let apiStatus = responseDic["isSuccess"] as! Bool
                    let apiMessage = responseDic["message"] as! String
                    
                    if apiMessage == "Valid OTP"{
                        userDefaultIsOTPVerified = true
                        
                        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "JobListingViewController") as! JobListingViewController
                   self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                    
                    if apiMessage == "Invalid OTP"{
                        let responseDic = responsee.result.value as! [String: Any]
                        let apiMessage = responseDic["message"] as! String
                        
                        self.showAlert(titleMsg: "\(apiMessage)", alertMsg: "")
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



extension VerificationCodeViewController: UITextFieldDelegate{
    // MARK:- UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if((textField.text?.count)!<1) && (string.count>0)
        {
            if(textField==txtFirst)
            {
                txtFirst.backgroundColor  = UIColor.colorBrownReject
                txtFirst.layer.borderWidth = 2.0
                txtFirst.layer.cornerRadius = 5.0
                txtFirst.layer.borderColor = UIColor.white.cgColor
                txtFirst.textColor = UIColor.white
                txtSecond.becomeFirstResponder()
            }
            else if(textField==txtSecond)
            {
                txtSecond.backgroundColor  = UIColor.colorBrownReject
                txtSecond.layer.borderWidth = 2.0
                txtSecond.layer.cornerRadius = 5.0
                txtSecond.layer.borderColor = UIColor.white.cgColor
                txtSecond.textColor = UIColor.white
                txtThird.becomeFirstResponder()
            }
            else if(textField==txtThird)
            {
                txtThird.backgroundColor  = UIColor.colorBrownReject
                txtThird.layer.borderWidth = 2.0
                txtThird.layer.cornerRadius = 5.0
                txtThird.layer.borderColor = UIColor.white.cgColor
                txtThird.textColor = UIColor.white
                txtFourth.becomeFirstResponder()
            }
            else if(textField==txtFourth)
            {
                txtFourth.backgroundColor  = UIColor.colorBrownReject
                txtFourth.layer.borderWidth = 2.0
                txtFourth.layer.cornerRadius = 5.0
                txtFourth.layer.borderColor = UIColor.white.cgColor
                txtFourth.textColor = UIColor.white
                
               //hit api here
            }
          
            textField.text = string
            return false
        }
            
        else if((textField.text?.count)!>=1) && (string.count==0)
        {
            if(textField==txtSecond)
            {
                txtSecond.backgroundColor  = UIColor.white
                txtSecond.layer.borderWidth = 3.0
                txtSecond.layer.cornerRadius = 5.0
                txtSecond.layer.borderColor = UIColor.gray.cgColor
                txtSecond.textColor = UIColor.colorBrownReject
                txtFirst.becomeFirstResponder()
            }
            else if(textField==txtThird)
            {
                txtThird.backgroundColor  = UIColor.white
                txtThird.layer.borderWidth = 3.0
                txtThird.layer.cornerRadius = 5.0
                txtThird.layer.borderColor = UIColor.gray.cgColor
                txtThird.textColor = UIColor.colorBrownReject
                txtSecond.becomeFirstResponder()
            }
            else if(textField==txtFourth)
            {
                txtFourth.backgroundColor  = UIColor.white
                txtFourth.layer.borderWidth = 3.0
                txtFourth.layer.cornerRadius = 5.0
                txtFourth.layer.borderColor = UIColor.gray.cgColor
                txtFourth.textColor = UIColor.colorBrownReject
                
                txtThird.becomeFirstResponder()
                
            }
          
            else if(textField==txtFirst)
            {
                txtFirst.backgroundColor  = UIColor.white
                txtFirst.layer.borderWidth = 3.0
                txtFirst.layer.cornerRadius = 5.0
                txtFirst.layer.borderColor = UIColor.gray.cgColor
                txtFirst.textColor = UIColor.colorBrownReject
                
                txtFirst.resignFirstResponder()
            }
            
            textField.text = ""
            return false
            
        }
        else if((textField.text?.count)!>=1)
        {
            textField.text = string
            return false
        }
        return true;
        
    }
}
