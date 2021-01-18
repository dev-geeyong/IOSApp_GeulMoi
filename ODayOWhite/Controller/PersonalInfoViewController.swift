//
//  LikeViewViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/13.
//

import UIKit
import Firebase
import RealmSwift


class PersonalInfoViewController: UIViewController  {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var curruntEmail: UILabel!
    @IBOutlet var curruntNickname: UILabel!
    
    
    let db = Firestore.firestore()
    var ary:Array<String> = []
    
    override func viewDidLoad() {
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
                        
    //                                doc?.reference.updateData(["likemessage":FieldValue.arrayRemove([message.body])])
                        
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
//        getMessageData()
//        tableView.rowHeight = 80.0
//        loadItem()
//        tableView.dataSource = self
//        tableView.delegate = self
//        // Do any additional setup after loading the view.
//        tableView.register(UINib(nibName: "LikeMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeMessageCell")
//        tableView.reloadData()
//
    }
//    func loadItem(){
//        likeArray = realm.objects(LikeMessage.self)
//        tableView.reloadData()
//        
//        
//    }

    func getMessageData(){
        DispatchQueue.main.async {
        if let currentEmail = Auth.auth().currentUser?.email{
            self.db.collection("users")
                .whereField("email", isEqualTo: currentEmail)
                .whereField("realdata", isEqualTo: true)
                .getDocuments(){(querySnapshot, err) in
                if let err = err {
                    print(err)
                }else{
                    
                    if let doc = querySnapshot!.documents.first{
                        let data = doc.data()
                        self.ary = data["likemessages"] as! Array<String>
                      
                
                    }else{
         
                    }
                    
//                                doc?.reference.updateData(["likemessage":FieldValue.arrayRemove([message.body])])
                    
                }
            }
        }
    }
    }
    override func viewWillAppear(_ animated: Bool) {
        //getMessageData()
        //tableView.reloadData()
       // print("will")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidApperar")
        //getMessageData()
        //tableView.reloadData()
        //loadItem()
       
      
    }
    
    @IBAction func touchUpLogoutButton(_ sender: UIButton) {
        
        let auth = Auth.auth()
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
//            let defaults = UserDefaults.standard
//            defaults.set(false, forKey: "isUserSignedIn")
//            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
//            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "goToLogin", sender: self)
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

//extension LikeViewViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if ary != nil{
//            return ary.count}
//        else{
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeMessageCell", for: indexPath) as! LikeMessageTableViewCell
//        if ary != nil{
//            cell.likeMessage.text = ary[indexPath.row]
//        }
//
//
////            cell.likeMessage.text = likeArray?[indexPath.row].message
////            cell.likeMessageNickname.text = "test"
//
//
//
//
//        return cell
//
//        }
//
//
//
//    }
//
//
//
//extension LikeViewViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        tableView.reloadData()
//
//    }
//}

