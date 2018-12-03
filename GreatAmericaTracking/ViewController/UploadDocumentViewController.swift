//
//  UploadDocumentViewController.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 08/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


class UploadDocumentViewController: UIViewController {

    var images: [URL] = []
    var uiImages:[UIImage] = []
    var imageSize:[Int] = []
     var imagePicker = UIImagePickerController()
    var imagePickedBlock: ((UIImage) -> Void)?
    var valueOfSlider: Float?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCamera: UIPhotosButton!
    @IBOutlet weak var btnGallery: UIPhotosButtonFromGallery!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.photoWork()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("🍥\(images.endIndex)")
    }
    
 
    
    @IBAction func actionUpload(_ sender: UIButton) {
        hitApiSendSingleDocument()
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

/*
extension UploadDocumentViewController:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
              print("🔥✴️🔥",image)
            self.imagePickedBlock?(image)
            dismiss(animated: true, completion: nil)
        }
        
        
    }
     
    
    
}   */
extension UploadDocumentViewController{
    func hitApiSendSingleDocument(){
         let parameter = ["orderid":"94"]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
           
            if let data = self.uiImages[0].jpegData(compressionQuality: 0.5) {
                multipartFormData.append(data, withName: "myDocs", fileName: "myDocs.jpeg", mimeType: "image/jpeg")
            }
          
            /*multipartFormData.append(UIImageJPEGRepresentation(self.photoImageView.image!, 0.5)!, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg") */
            for (key, value) in parameter {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: Api.sendDocument.url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    self.valueOfSlider =  Float(Progress.fractionCompleted)
                    self.tableView.reloadData()
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print("💎",response.request)  // original URL request
                    print("🍄",response.response) // URL response
                    print("💫",response.data)     // server data
                    print("🎃",response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
                    if let JSON = response.result.value {
                        print("🔥 JSON: \(JSON)")
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
    }
   /* func hitApiSendDocument(){
        let parameter = ["orderid":"94"]
        print("🌕\(parameter)")
        /*            for i in 0..<self.uiImages.count {
         if let data = self.uiImages[i].jpegData(compressionQuality: 0.5) {
         form.append(data, withName: "myDocs", fileName: "myDocs\(i).jpeg", mimeType: "image/jpeg")
         }
         }*/
        
        Alamofire.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
            
            let count = self.images.count
            
            for i in 0..<count{
                multipartFormData.append(self.images[i], withName: "myDocs[\(i)]", fileName: "myDocs\(i).jpeg", mimeType: "image/jpeg")
                
            }
            for (key, value) in parameter {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            print("💰",multipartFormData)
        }, to: Api.sendDocument.url) { (result) in
          
            switch result {
            case .success(let upload, _ , _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    print("🏐uploding: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("🌕",response)
                    print(response.result)
                    print("🌈",upload.response?.statusCode)
                   /* print(response.result.value!)
                    let resp = response.result.value! as! NSDictionary
                    if resp["status"] as! String == "success"{
                        print(response.result.value!)
                        let alert = UIAlertController(title: "Alert", message: "Image Upload Successful", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    else{
                        
                    }
                    */
                    
                }
                
            case .failure(let encodingError):
                print("failed")
                print(encodingError)
                
            }
        }
     
    }  */
    
    func photoWork(){
        btnGallery.closureDidFinishPicking = { image in
            print("✴️✴️",image)
            let url : URL = URL(fileURLWithPath: image.first!)
            print("🔥",url)
            self.images.append(url)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        btnGallery.closureDidImageSize = {  size in
            print("✴️🔥✴️",size)
            self.imageSize.append(size)
        }
        btnGallery.closureDidFinishPickingUIImage = { image in
            print("⚽️⚽️",image)
            let img : UIImage = image.first!
            self.uiImages.append(img)
        }
        
        btnCamera.closureDidFinishPickingAnImage = { image in
            print("🔥🔥",image)
            
            let url : URL = URL(fileURLWithPath: image.first!)
            print("🔥🔥",url)
            self.images.append(url)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        btnCamera.closureDidImageSize = {  size in
            print("✴️🔥✴️",size)
            self.imageSize.append(size)
        }
    }
    
}
extension UploadDocumentViewController{
    
}



extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension UploadDocumentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :UploadDocumentCell =  tableView.dequeueReusableCell(withIdentifier: UploadDocumentCell.identifier, for: indexPath) as! UploadDocumentCell
        let sizeOfImageMB = Double(self.imageSize[indexPath.row])/(1024*1024)
        //String(format: "%.2f", apiGetPropertyList.roi ?? "NG")
        cell.lblImageName.text! = "\(self.images[indexPath.row])"
        cell.lblImageSize.text! = "\(Double(round(1000*sizeOfImageMB)/1000)) mb"//String(format: "%.2f", sizeOfImageMB )//
        cell.photoView.load(url: self.images[indexPath.row])
        cell.btnDelete.addTarget(self, action: #selector(deleteBtnTapped), for:.touchUpInside)
        cell.btnDelete.tag = indexPath.row
      //  cell.sliderr.setProgress(valueOfSlider, animated: true)
        return cell
    }
    @objc func deleteBtnTapped(sender: UIButton){
          let buttonTag = sender.tag
        images.remove(at:buttonTag)
        imageSize.remove(at:buttonTag)
        self.tableView.reloadData()
    }
    
}

extension UploadDocumentViewController: UITableViewDelegate{
    
}

class UploadDocumentCell : UITableViewCell{
  static let identifier = "UploadDocumentCell"
    
    @IBOutlet weak var sliderr: UIProgressView!
    @IBOutlet weak var lblImageName: UILabel!
    
    @IBOutlet weak var lblImageSize: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
}
