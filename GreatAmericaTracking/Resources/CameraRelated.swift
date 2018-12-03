//
//  CameraRelated.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 19/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import Foundation
import UIKit


class CameraHandler: NSObject{
    static let shared = CameraHandler()
    
    fileprivate var currentVC: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: "Upload", message: "Image from", preferredStyle: .alert)
        
        /*actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        })) */
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}


extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
            print("✴️✴️",image.size)
            currentVC.dismiss(animated: true, completion: nil)
        }
    }
}


/* how to use this on button
 @IBAction func actionProfilePic(_ sender: UIButton) {
 print(" 🎦🎬🎬 Action Profile Tapped 🎦🎬🎬")
 CameraHandler.shared.showActionSheet(vc: self)
 CameraHandler.shared.imagePickedBlock = { (image) in
 print("the picked up image is ",image)
 self.profileImageView.image = image  // here imageView is the view where u want to show the image that is picked
 }
 }
 */
