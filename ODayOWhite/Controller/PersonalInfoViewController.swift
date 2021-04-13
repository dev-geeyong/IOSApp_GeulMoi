//
//  LikeViewViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/13.
//

import UIKit
import Firebase
import MessageUI
import SafariServices
class PersonalInfoViewController: UIViewController  {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var curruntEmail: UILabel!
    @IBOutlet var curruntNickname: UILabel!
    
    @IBOutlet var saveTextButton: UIButton!
    @IBOutlet var writeTextButton: UIButton!
    @IBOutlet var topView: UIView!
    
    let db = Firestore.firestore()
    var ary:Array<String> = []
    
    override func viewDidLoad() {
        topView.layer.cornerRadius = 10
        saveTextButton.layer.cornerRadius = 10
        writeTextButton.layer.cornerRadius = 10
        writeTextButton.clipsToBounds = true
        saveTextButton.clipsToBounds = true
        topView.clipsToBounds = true
        if let currentEmail = Auth.auth().currentUser?.email{
            curruntEmail.text = currentEmail
            
            DispatchQueue.main.async {
                if let currentEmail = Auth.auth().currentUser?.email{
                    self.db.collection("usersData")
                        .whereField("email", isEqualTo: currentEmail)
                        .getDocuments(){(querySnapshot, err) in
                            if let err = err {
                                print(err)
                            }else{
                                
                                if let doc = querySnapshot!.documents.first{
                                    let data = doc.data()
                                    self.curruntNickname.text = data["nickname"] as! String
                                    
                                }else{
                                    
                                }
                                
                            }
                        }
                }
                
                
            }
            
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage() //remove pesky 1 pixel line
        
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //getMessageData()
        //tableView.reloadData()
        // print("will")
    }
    override func viewDidAppear(_ animated: Bool) {
        
        //getMessageData()
        //tableView.reloadData()
        //loadItem()
        
        
    }
    
    @IBAction func contactButtonAction(_ sender: UIButton) {
        
        showMailComposer()
    }
    func showMailComposer(){
        guard  MFMailComposeViewController.canSendMail() else {
            self.view.makeToast("연결된 mail이 없습니다 아이폰 기본 mail 어플을 확인해주세요")
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["dev.geeyong@gmail.com"])
        composer.setSubject("신고 / 문의")
        composer.setMessageBody("", isHTML: false)
        
        present(composer, animated: true)
        
    }
    
    @IBAction func touchUpLogoutButton(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
                       },
                       completion: { Void in()  }
        )
        do {
            
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.removeObject(forKey: "id")
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        //            self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    
    
}
extension PersonalInfoViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
        }
        
        controller.dismiss(animated: true)
    }
}
