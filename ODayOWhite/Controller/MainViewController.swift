//
//  MainViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit
import SwipeableTabBarController
import Firebase
import SwipeCellKit
import ViewAnimator
import RealmSwift
import Toast_Swift

class MainViewController: UIViewController {
    
    @IBOutlet var bestMessage: UILabel!
    @IBOutlet var bestNickname: UILabel!
    @IBOutlet var bestLike: UILabel!
    
    @IBOutlet var bestImageView: UIImageView!
    
    var imageLoader = ImageLoader()
    var commonImageURL = ""
    let realm = try! Realm()
    var likeArray: Results<LikeMessage>?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    
    //    private let animations = [
    //        AnimationType.vector(CGVector(dx: 0, dy: 5)),
    //
    //
    //    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBestMessage()
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.rowHeight = 170
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        loadMessages()
        
        
        tableView.reloadData()
    }
    func loadBestMessage(){
        db.collection("admin")
            .addSnapshotListener{(querySnapshot, error) in
                if let e = error{
                    print(e,"loadMessages error")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            self.bestMessage.text = data["message"] as? String
                            self.bestNickname.text = data["nickname"] as? String
                            self.bestLike.text = data["like"] as? String
                            
                            let url = URL(string: data["imageURL"] as! String)
                            
                            let urlData = try? Data(contentsOf: url!)
                            
                            self.bestImageView.image = UIImage(data: urlData!)
                            
                            self.commonImageURL = data["commonImage"] as! String
                        }
                    }
                }
            }
    }
    func loadMessages(){
        db.collection("users")
            .order(by: "date")
            .addSnapshotListener{(querySnapshot, error) in
                self.messages = []
                if let e = error{
                    print(e,"loadMessages error")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            
                            if let messageSender = data["nickName"] as? String, let messageBody = data["mesagee"] as? String, let messageEmail = data["email"] as? String, let likeNum = data["likeNum"] as? Int{
                                let newMessage = Message(sender: messageEmail, body: messageBody, name: messageSender, like: true, likeNum: likeNum)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: 0, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
}
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.delegate = self
        imageLoader.obtainImageWithPath(imagePath: commonImageURL) { (image) in
                
                cell.backgroundImageView.image  = image
                
            }
        
        
        
        cell.messageTextLabel.text = message.body
        cell.messageSenderLabel.text = message.name
        cell.messageCountLike.text = "\(message.likeNum)"
        
        return cell
    }
    
}
extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
}
//MARK: - swipetable
extension MainViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let message = messages[indexPath.row]
        let item = LikeMessage()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        
        switch orientation {
        //        let activityVC = UIActivityViewController(activityItems: [self.messages[indexPath.row].body], applicationActivities: nil)
        //        activityVC.popoverPresentationController?.sourceView = self.view
        //        self.present(activityVC, animated: true, completion: nil)
        case .left:
            let thumbsUpAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                let activityVC = UIActivityViewController(activityItems: [self.messages[indexPath.row].body], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
            })
            
            thumbsUpAction.title = "공유하기"
            thumbsUpAction.image = UIImage(systemName: "square.and.arrow.up")
            thumbsUpAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            
            
            
            return [thumbsUpAction]
        
            
        case .right:
            
            let thumbsUpAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                K.TF[indexPath.row] = !K.TF[indexPath.row]
                let body = self.messages[indexPath.row].body
                self.db.collection("users").whereField("mesagee", isEqualTo: body).getDocuments(){(querySnapshot, err) in
                    if let err = err {
                        print(err)
                    }else{
                        
                        let doc = querySnapshot!.documents.first
                        //doc?.reference.delete()
                        if let likenum = doc?.data()["likeNum"]{
                            if K.TF[indexPath.row] == true{
                                doc?.reference.updateData([
                                    
                                    "likeNum": likenum as! Int - 1,
                                    
                                ])
                                tableView.reloadRows(at: [indexPath], with: .fade)
                            }else{
                                doc?.reference.updateData([
                                    
                                    "likeNum": likenum as! Int + 1,
                                    
                                ])
                                tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                        
                    }
                }
            })
            
            
            if K.TF[indexPath.row]==true{
                thumbsUpAction.title = "좋아요"
                thumbsUpAction.image = UIImage(systemName: "hand.thumbsup.fill")
                thumbsUpAction.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                
                
                
            }else{
                thumbsUpAction.title = "좋아요 취소"
                thumbsUpAction.image = UIImage(systemName: "hand.thumbsdown.fill")
                thumbsUpAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                
            }
            //MARK: - 저장하기 스와이프
            let saveAction2 = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                
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
                                    let ary:Array = data["likemessages"] as! Array<String>
                                    for iem in ary {
                                        print(iem)
                                    }
                                    doc.reference.updateData(["likemessages":FieldValue.arrayUnion([message.body])])
                                    self.view.makeToast("저장완료")
                                    tableView.reloadRows(at: [indexPath], with: .none)
                                }else{
                                    self.view.makeToast("fail")
                                    
                                }
                                
//                                doc?.reference.updateData(["likemessage":FieldValue.arrayRemove([message.body])])
                                
                            }
                        }
                    }
                }
                
            })
            saveAction2.title = "저장하기"
            saveAction2.image = UIImage(systemName: "square.and.arrow.down.fill")
            saveAction2.backgroundColor = #colorLiteral(red: 0.03715451062, green: 0.4638677239, blue: 0.9536394477, alpha: 1)
            return [saveAction2, thumbsUpAction]
            
        }
        
    }
    func updateModel(at indexPath: IndexPath){
        if let likeArrayForDeletion = self.likeArray?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(likeArrayForDeletion)
                }
            }catch{
                print("update err")
            }
        }
    }
    func saveMessage(likeMessage: LikeMessage){
        do{
            try realm.write{
                realm.add(likeMessage)
            }
        }catch{
            print("save err")
        }
        //        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .drag
        
        return options
    }
}
