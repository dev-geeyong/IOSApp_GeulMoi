//
//  WriteViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/13.
//

import UIKit
import Firebase
import YPImagePicker

class WriteViewController: UIViewController {
    
    @IBOutlet var whiteView: UIView!
    
    
    @IBOutlet var testimagevieww: UIImageView!
    @IBOutlet var topView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var inputText: UILabel!
    @IBOutlet var senderNickName: UILabel!
    @IBOutlet var textField: UITextField!
    
    let db = Firestore.firestore()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        //        self.tabBarController?.tabBar.isHidden = true
        textField.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        
        
        if let inputMessaege = inputText.text{
        
            db.collection("users").addDocument(data: [
                "email" : K.email,
                "nickName" : K.nickName,
                "mesagee" : inputMessaege,
                "date" : 0 - Date().timeIntervalSince1970,
                "likeNum" : 0
            ]){(error) in
                if let e = error {
                    print(e)
                }else{
                    
                    print( Auth.auth().currentUser?.email ?? "sucsee")
                }
            }
        }
       self.tabBarController?.selectedIndex = 0
        
        
        
    }
   
    @IBAction func imagePicker(_ sender: UIButton){
        let image = topView.snapshot()
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
//        @IBAction func save(_ sender: AnyObject) {
//                UIImageWriteToSavedPhotosAlbum(imageTake.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//            }
        
//        var config = YPImagePickerConfiguration()
//        config.screens = [.library, .photo]
//        config.targetImageSize = YPImageSize.cappedTo(size: 400)
//        let picker = YPImagePicker(configuration: config)
//
//        picker.didFinishPicking { [unowned picker] items, _ in
//            if let photo = items.singlePhoto {
//                print(photo.fromCamera) // Image source (camera or library)
//                print(photo.image) // Final image selected by the user
//                print(photo.originalImage) // original image selected by the user, unfiltered
//                print(photo.modifiedImage) // Transformed image, can be nil
//                print(photo.exifMeta) // Print exif meta data of original image.
//
//                self.imageView.image = photo.image
//                self.imageView.layer.cornerRadius = 10
//                self.imageView.clipsToBounds = true
//            }
//            picker.dismiss(animated: true, completion: nil)
//        }
//        present(picker, animated: true, completion: nil)
    }
    
}
extension WriteViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            if let currentEmail = Auth.auth().currentUser?.email{
                self.db.collection("users").whereField("email", isEqualTo: currentEmail).getDocuments(){(querySnapshot, err) in
                    if let err = err {
                        print(err)
                    }else{
                        for doc in querySnapshot!.documents{
                            let data = doc.data()
                            if let nickname = data["nickName"]{
                                self.senderNickName.text = nickname as? String
                                K.nickName = nickname as! String
                                K.email = currentEmail
                            }
                        }
                    }
                }
            }
        }
        senderNickName.text = K.nickName
        inputText.text = textField.text
        textField.resignFirstResponder ()
        textField.text = ""
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            if let currentEmail = Auth.auth().currentUser?.email{
                self.db.collection("users").whereField("email", isEqualTo: currentEmail).getDocuments(){(querySnapshot, err) in
                    if let err = err {
                        print(err)
                    }else{
                        for doc in querySnapshot!.documents{
                            let data = doc.data()
                            if let nickname = data["nickName"]{
                                self.senderNickName.text = nickname as? String
                                K.nickName = nickname as! String
                                K.email = currentEmail
                            }
                        }
                    }
                }
            }
        }
        senderNickName.text = K.nickName
        inputText.text = textField.text
        textField.resignFirstResponder ()
        textField.text = ""
        
    }
}
extension UIView {

    /// Create image snapshot of view.
    ///
    /// - Parameters:
    ///   - rect: The coordinates (in the view's own coordinate space) to be captured. If omitted, the entire `bounds` will be captured.
    ///   - afterScreenUpdates: A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated. Specify the value false if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes. Defaults to `true`.
    ///
    /// - Returns: The `UIImage` snapshot.

    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
}
