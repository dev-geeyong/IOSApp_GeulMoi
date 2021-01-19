//
//  LoginViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit
import Firebase
import TweeTextField

class LoginViewController: UIViewController {

    @IBOutlet var idTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func pressLoginButton(_ sender: UIButton) {
        if let email = idTextField.text , let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    self.view.makeToast("맞지 않는 메일 주소(비밀번호)입니다. 다시 입력해 주세요.")
                }else{
                    UserDefaults.standard.set(email, forKey: "email")
                    self.performSegue(withIdentifier: "LoginToMain", sender: self)
                }
            }
        }
    }
    

}
