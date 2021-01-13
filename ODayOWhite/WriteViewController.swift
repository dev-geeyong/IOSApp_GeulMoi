//
//  WriteViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/13.
//

import UIKit
import Firebase

class WriteViewController: UIViewController {
    
    @IBOutlet var whiteView: UIView!
    
    @IBOutlet var inputText: UILabel!
    @IBOutlet var senderNickName: UILabel!
    @IBOutlet var textField: UITextField!
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        //        self.tabBarController?.tabBar.isHidden = true
        textField.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
        
        
        whiteView.backgroundColor = .white
        
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        whiteView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        whiteView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        whiteView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        
        
        if let inputMessaege = inputText.text{
            db.collection("users").addDocument(data: [
                "email" : K.email,
                "nickName" : K.nickName,
                "mesagee" : inputMessaege,
                "date" : 0 - Date().timeIntervalSince1970
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
