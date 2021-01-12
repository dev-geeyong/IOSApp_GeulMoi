//
//  LoginViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var idTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경색상
     
        bottomLine(textfiled: idTextField)
        bottomLine(textfiled: passwordTextField)

        // Do any additional setup after loading the view.
    }
    func bottomLine(textfiled: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfiled.frame.height - 1, width: textfiled.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        textfiled.borderStyle = .none
        
        textfiled.layer.addSublayer(bottomLine)
    }
    
    @IBAction func pressLoginButton(_ sender: UIButton) {
        if let email = idTextField.text , let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "goToMainScreen", sender: self)
                }
            }
        }
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
