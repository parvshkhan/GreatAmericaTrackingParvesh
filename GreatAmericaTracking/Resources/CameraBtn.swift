//
//  CameraBtn.swift
//  NXSpot
//   Created by vijayvir Singh (virvijay37@gmail.com)
//  Created by Anupriya on 14/11/17.
//  Copyright © 2017 vijay vir. All rights reserved.
//

import Foundation
import UIKit

let appNameUIPhotosButton = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String

let rootFolder: String = "\(NSTemporaryDirectory())UIMultiplePhoto/"

class UIPhotosButton: UIButton, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    // MARK: Variables
    private var imagePaths = [String]()
    
    // This class have two option to select the images from Camera or Galler  . If isSingle is true It will select the an image and return to the class through delegate  or closure
    @IBInspectable var isSingle: Bool = true
    
    // Use this class to have multiple images .
    public var closureDidFinishPicking: ((_ images: [String]) -> Void)?
    
    // Use this class to have single image.
    public  var closureDidFinishPickingAnImage: ((_ image: [String]) -> Void)?
    
    public  var closureDidImageSize: ((_ imageSize: Int) -> Void)?
    
    public  var closureDidTap: (() -> Void)?
    
    public  var closureDidTapCancel: (() -> Void)?
    
   @IBOutlet var viewControllerFromNib : UIViewController?
    
    // MARK: CLC
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print(UIPhotosButton.photoPath(), NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String, rootFolder)
        
        self.addTarget(self, action: #selector(addPhoto),
                       for: .touchUpInside)
        
    }
    
    // MARK: Actions
    // MARK: Functions
    class func removeCache() {
        let fileManger = FileManager.default
        
        // Delete 'subfolder' folder
        do {
            try fileManger.removeItem(atPath: rootFolder)
        } catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
    }
    
    private class func photoPath() -> String {
        
        let fileManger = FileManager.default
        
        if !fileManger.fileExists(atPath: rootFolder) {
            do {
                try fileManger.createDirectory(atPath: "\(rootFolder)", withIntermediateDirectories: false, attributes: nil)
                
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        } else {
            print("file  exit ")
        }
        
        return rootFolder
    }
    
    @objc private func addPhoto() {
        imagePaths.removeAll()
        
        self.closureDidTap?()
        
        PhotoAlertHelper.alertView(title: appNameUIPhotosButton,
                                   message: "Select image.",
                                   preferredStyle: .actionSheet,
                                   cancelTilte: "Cancel",
                                   otherButtons: "Camera",
                                   comletionHandler: { (index: Swift.Int) in
                                    
                                    print(index)
                                    
                                    if index == 0 {
                                        
                                        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                                            self.camera()
                                          
                                        }
//                                        } else {
//                                            self.gallery()
//
//                                        }
                                        
                                    }
//                                    else if index == 1 {
//                                        self.gallery()
//                                    }
                                    else if index == 2 {
                                       self.closureDidTapCancel?()
                                   }
                                    
        })
        
    }
    
    private func gallery() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        
        imagePicker.sourceType = .photoLibrary
        
        let keywindow = UIApplication.shared.keyWindow
        
        let mainController = keywindow?.rootViewController
        
     
        if  (viewControllerFromNib != nil) {
            viewControllerFromNib?.present(imagePicker, animated: true, completion: nil)
            
        } else if (mainController != nil){
            mainController?.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    private func camera() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        
        imagePicker.sourceType = .camera
       
        let keywindow = UIApplication.shared.keyWindow
        
        let mainController = keywindow?.rootViewController
        
        
        if  (viewControllerFromNib != nil) {
            viewControllerFromNib?.present(imagePicker, animated: true, completion: nil)
            
        } else if (mainController != nil){
            mainController?.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    // MARK: ImagePicker view Delegate
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let filePath = URL(fileURLWithPath: UIPhotosButton.photoPath() + "\(NSUUID().uuidString)").appendingPathExtension("jpg")
        
        imagePaths.append(filePath.path)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
      
        let imageData = image.jpegData(compressionQuality: 0.5)
        let imageSize: Int = imageData!.count
        print("🥚size of image in Mb: %f ", Double(imageSize) / (1024.0*1024.0))
        do {
            try imageData?.write(to: filePath, options: .atomic)
            
            closureDidFinishPickingAnImage?([filePath.path])
             closureDidImageSize?(imageSize)
        } catch {
            print(error)
        }
        
        picker.dismiss(animated: true, completion: { [unowned self] () in
            
            if self.isSingle {
                
                self.closureDidFinishPicking?(self.imagePaths)
                
            } else {
                PhotoAlertHelper.alertView(imagesPath: self.imagePaths, message: "Would you like  to select more pictures ", preferredStyle: .actionSheet,
                                           cancelTilte: "No",
                                           otherButtons: "Camera",
                                           comletionHandler: { [unowned self] (index: Swift.Int) in
                                            
                                            print(index)
                                            
                                            if index == 0 {
                                                
                                                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                                                    self.camera()
                                                    
                                                }
                                                
//                                                else {
//                                                    self.gallery()
//
//                                                }
                                            }
                                            
//                                            else if index == 1 {
//                                                self.gallery()
//                                            }
                                            
                                            else if index == 2 {
                                                self.closureDidFinishPicking?(self.imagePaths)
                                                
                                            }
                })
            }
            
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { [unowned self] () in
            
            self.closureDidFinishPicking?(self.imagePaths)
            
        })
        
    }
    
}

class PhotoAlertHelper: UIAlertController {
    // make sure you have navigation  view controller
    class func alertView(imagesPath: [String], message: String, preferredStyle: UIAlertController.Style, cancelTilte: String, otherButtons: String ..., comletionHandler: ((Swift.Int) -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n", message: message, preferredStyle: preferredStyle)
        
        let margin: CGFloat = 10.0
        
        let height: CGFloat = 120.0
        
        let rect = CGRect(x: margin, y: margin, width: alert.view.bounds.size.width - margin * 4.0, height: height)
        let customView = UIView(frame: rect)
        
        // customView.backgroundColor = .green
        alert.view.addSubview(customView)
        
        let rectofScrollView = CGRect(x: 0, y: 0, width: customView.bounds.size.width, height: customView.bounds.size.height)
        let scrollView = UIScrollView(frame: rectofScrollView)
        scrollView.backgroundColor = .gray
        customView.addSubview(scrollView)
        
        for (index, filepath) in imagesPath.enumerated() {
            
            let imagev = UIImageView(frame: CGRect(x: height * CGFloat(index) + (margin * CGFloat(index + 1)), y: margin, width: height, height: height - (2 * margin)))
            
            imagev.image = UIImage(named: filepath)
            
            scrollView.addSubview(imagev)
            
        }
        
        // 4
        scrollView.contentSize = CGSize(width: CGFloat(imagesPath.count) * height + (margin * CGFloat(imagesPath.count + 1)), height: height)
        
        print("images path are ", imagesPath)
        
        for i in otherButtons {
            print(UIApplication.gallerytopViewController() ?? i)
            
            alert.addAction(UIAlertAction(title: i, style: UIAlertAction.Style.default,
                                          handler: { (action: UIAlertAction!) in
                                            
                                            comletionHandler?(alert.actions.index(of: action)!)
                                            
            }
            ))
            
        }
        if (cancelTilte as String?) != nil {
            alert.addAction(UIAlertAction(title: cancelTilte, style: UIAlertAction.Style.destructive,
                                          handler: { (action: UIAlertAction!) in
                                            
                                            comletionHandler?(alert.actions.index(of: action)!)
                                            
            }
            ))
        }
        
        UIApplication.gallerytopViewController()?.present(alert, animated: true, completion: {
            
        })
        
    }
    
    class func alertView(title: String, message: String, preferredStyle: UIAlertController.Style, cancelTilte: String, otherButtons: String ..., comletionHandler: ((Swift.Int) -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for i in otherButtons {
            print(UIApplication.gallerytopViewController() ?? i)
            
            alert.addAction(UIAlertAction(title: i, style: UIAlertAction.Style.default,
                                          handler: { (action: UIAlertAction!) in
                                            
                                            comletionHandler?(alert.actions.index(of: action)!)
                                            
            }
            ))
            
        }
        if (cancelTilte as String?) != nil {
            alert.addAction(UIAlertAction(title: cancelTilte, style: UIAlertAction.Style.destructive,
                                          handler: { (action: UIAlertAction!) in
                                            
                                            comletionHandler?(alert.actions.index(of: action)!)
                                            
            }
            ))
        }
        
        UIApplication.gallerytopViewController()?.present(alert, animated: true, completion: {
            
        })
        
    }
    
}

extension UIApplication {
    class func gallerytopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return gallerytopViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return gallerytopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return gallerytopViewController(controller: presented)
        }
        
        // need R and d
        //        if let top = UIApplication.shared.delegate?.window??.rootViewController
        //        {
        //            let nibName = "\(top)".characters.split{$0 == "."}.map(String.init).last!
        //
        //            print(  self,"    d  ",nibName)
        //
        //            return top
        //        }
        return controller
    }
}
 
