//
//  RegisterViewController.swift
//  
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameTextField.addUnderLine()
        emailTextField.addUnderLine()
        
        passwordTextField.addUnderLine()
    }
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text , let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error {
                    
                    
                    print(e.localizedDescription)
                }
                else{
//                    if let inputMessaege = inputText.text{
//
//                        db.collection("users").addDocument(data: [
//                            "email" : K.email,
//                            "nickName" : K.nickName,
//                            "mesagee" : inputMessaege,
//                            "date" : 0 - Date().timeIntervalSince1970,
//                            "likeNum" : 0
//                        ]){(error) in
//                            if let e = error {
//                                print(e)
//                            }else{
//
//                                print( Auth.auth().currentUser?.email ?? "sucsee")
//                            }
//                        }
//                    }
                    if let nickname = self.nickNameTextField.text {
                        K.email = email
                        K.nickName = nickname
                        self.db.collection("usersData").addDocument(data: [
                            "likemessages" : [],
                            "email" : email,
                            "nickname" : K.nickName
                        ]){(error) in
                            if let e = error{
                                print(e)
                            }else{
                                print("sucsee")
                            }
                        }
                    }
                    self.performSegue(withIdentifier: "goToMain", sender: self)
                }
            }
        }
        
    }
}
extension UITextField {
    
    func addUnderLine () {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height - 10, width: self.bounds.width, height: 1.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
}

