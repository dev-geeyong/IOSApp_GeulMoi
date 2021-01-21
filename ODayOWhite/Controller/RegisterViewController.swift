//
//  RegisterViewController.swift
//  
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit
import Firebase
import TweeTextField

class RegisterViewController: UIViewController {
    
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.keyboardType = .URL
      
    }
    @IBAction func passwordEditingChanged(_ sender: TweeAttributedTextField) {
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
                sender.showInfo("잘 하셨습니다!", animated: true)
            }
            
        }
    }
    @IBAction func passwordWhileEditing(_ sender: TweeAttributedTextField) {
        
    }
    
    @IBAction func myEmailWhileEditing(_ sender: TweeAttributedTextField) {
        
              if let userInput = sender.text {
                  
                  if userInput.count == 0 {
                      sender.activeLineColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                      sender.hideInfo(animated: true)
                      return
                  }
                  
                  if userInput.isValidEmail == true {
                      sender.infoTextColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                      sender.activeLineColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                      sender.showInfo("이메일 형식 입니다!", animated: true)
                  } else {
                      sender.infoTextColor = .red
                      sender.activeLineColor = .red
                      
                      sender.showInfo("이메일 형식이 아닙니다!", animated: true)
                  }
              }
              
          }
        
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text , let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error {
                    
                    self.view.makeToast("이미 사용 중인 이메일이거나 입력이 잘못됐습니다.")
                    print(e.localizedDescription)
                }
                else{

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
                    UserDefaults.standard.set(email, forKey: "id")
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

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
}
