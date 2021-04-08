//
//  WriteViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/13.
//

import UIKit
import Firebase
import YPImagePicker
import TweeTextField
import ChameleonFramework

class WriteViewController: UIViewController {
    
    @IBOutlet var whiteView: UIView!
    
    
    @IBOutlet var captureView: UIView!
    @IBOutlet var testimagevieww: UIImageView!
    @IBOutlet var topView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var inputText: UILabel!
    @IBOutlet var senderNickName: UILabel!
    @IBOutlet var textField: UITextField!
    var photoImage: UIImage!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        textField.becomeFirstResponder()
        imageView.layer.cornerRadius = 10
        submitButton.layer.cornerRadius = 20
        submitButton.clipsToBounds = true
        leftButton.layer.cornerRadius = 20
        leftButton.clipsToBounds = true
        rightButton.layer.cornerRadius = 20
        rightButton.clipsToBounds = true
        imageView.clipsToBounds = true
        textField.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        submitButton.isEnabled = false
        textField.becomeFirstResponder()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        textField.text = ""
    }
    //글쓰기버튼
    @IBAction func pressButton(_ sender: UIButton) {
        
        
        if let inputMessaege = inputText.text{
            
            db.collection("users").addDocument(data: [
                "email" : K.email,
                "nickName" : K.nickName,
                "mesagee" : inputMessaege,
                "date" : 0 - Date().timeIntervalSince1970,
                "likeNum" : 0,
                "block" : 0
            ]){(error) in
                if let e = error {
                    print(e)
                }else{
                    
                    print( Auth.auth().currentUser?.email ?? "sucsee")
                }
            }
        }
        K.TF = true
        self.tabBarController?.selectedIndex = 0
        
        
        
        
    }
    
    @IBAction func textfieldChanged(_ sender: TweeAttributedTextField) {
        if let userInput = sender.text {
            if userInput.count == 0{
                sender.activeLineColor = #colorLiteral(red: 0.03715451062, green: 0.4638677239, blue: 0.9536394477, alpha: 1)
                sender.hideInfo(animated: true)
            }else if userInput.count < 6{
                sender.infoTextColor = .red
                sender.activeLineColor = .red
                sender.showInfo("6글자 이상 입력하세요!", animated: true)
            }else{
                sender.infoTextColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                sender.activeLineColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                sender.hideInfo(animated: true)
            }
            
        }
    }
    //MARK: - 이미지 변경하기 (카메라, 라이브러리)
    @IBAction func changeImage(_ sender: UIButton) {
        
        
        var config = YPImagePickerConfiguration()
        config.screens = [.photo , .library]
        config.targetImageSize = YPImageSize.cappedTo(size: 400)
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.imageView.image = photo.image
                self.photoImage = photo.image
                self.imageView.layer.cornerRadius = 10
                self.imageView.clipsToBounds = true
                let colur = AverageColorFromImage(photo.image)
                self.inputText.textColor = ContrastColorOf(colur, returnFlat: true)
                self.senderNickName.textColor = ContrastColorOf(colur, returnFlat: true)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    //MARK: - 이미지 캡쳐 저장
    @IBAction func imagePicker(_ sender: UIButton){
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = false
        let image = captureView.snapshot()
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        self.view.makeToast("사진을 저장했습니다.")
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
    }
    
}
extension WriteViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            if let currentEmail = Auth.auth().currentUser?.email{
                self.db.collection("usersData").whereField("email", isEqualTo: currentEmail).getDocuments(){(querySnapshot, err) in
                    if let err = err {
                        print(err)
                    }else{
                        for doc in querySnapshot!.documents{
                            let data = doc.data()
                            if let nickname = data["nickname"]{
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
        if textField.text! != ""{
            inputText.text = textField.text
        }
        if(textField.text!.count > 5){
            print(textField.text!.count)
            submitButton.isEnabled = true
        }
        else{
            submitButton.isEnabled = false
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            if let currentEmail = Auth.auth().currentUser?.email{
                self.db.collection("usersData").whereField("email", isEqualTo: currentEmail).getDocuments(){(querySnapshot, err) in
                    if let err = err {
                        print(err)
                    }else{
                        for doc in querySnapshot!.documents{
                            let data = doc.data()
                            if let nickname = data["nickname"]{
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
        if textField.text! != ""{
            inputText.text = textField.text
            
        }
        if(textField.text!.count > 5){
            print(textField.text!.count)
            submitButton.isEnabled = true
        }else{
            submitButton.isEnabled = false
        }
        
        
        
    }
}
extension UIView {
    
    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
}
