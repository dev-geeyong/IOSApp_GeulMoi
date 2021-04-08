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
    
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("첫화면 viewDidLoad")
        if let userID = UserDefaults.standard.string(forKey: "id"){
            
            self.performSegue(withIdentifier: "LoginToMain", sender: self)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("첫화면 viewDidAppear")
        if let userID = UserDefaults.standard.string(forKey: "id"){
            
            self.performSegue(withIdentifier: "LoginToMain", sender: self)
        }
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser(){
            let vc = storyboard?.instantiateViewController(identifier: "welcome2") as! GuideViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    @IBAction func pressLoginButton(_ sender: UIButton) {
        if let email = idTextField.text , let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    self.view.makeToast("맞지 않는 메일 주소(비밀번호)입니다. 다시 입력해 주세요.")
                }else{
                    UserDefaults.standard.set(email, forKey: "id")
                    print("저장")
                    self.performSegue(withIdentifier: "LoginToMain", sender: self)
                }
            }
        }
    }
}
class Core {
    
    static let shared = Core()
    
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    func setIsNotNewUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
