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


class MainViewController: UIViewController {

    let realm = try! Realm()
    var likeArray: Results<LikeMessage>?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var messages: [Message] = []
    var TF = Array(repeating: true, count: 100000)

//    private let animations = [
//        AnimationType.vector(CGVector(dx: 0, dy: 5)),
//
//
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.rowHeight = 80.0
        
        
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        loadMessages()
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
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    [weak self] in
                                    guard let self = self else{return}
                                    self.tableView.reloadData()
//                                    UIView.animate(views: self.tableView.visibleCells, animations: self.animations)
                                })
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.delegate = self
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
            
        case .right, .left:
            print("right")
            let thumbsUpAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                self.TF[indexPath.row] = !self.TF[indexPath.row]
                    let body = self.messages[indexPath.row].body
                    self.db.collection("users").whereField("mesagee", isEqualTo: body).getDocuments(){(querySnapshot, err) in
                            if let err = err {
                                print(err)
                            }else{
                                let doc = querySnapshot!.documents.first
                                if let likenum = doc?.data()["likeNum"]{
                                    if self.TF[indexPath.row] == true{
                                        doc?.reference.updateData([
                                            
                                            "likeNum": likenum as! Int - 1,
                                            
                                        ])
                                    }else{
                                        doc?.reference.updateData([
                                            
                                            "likeNum": likenum as! Int + 1,
                                            
                                        ])
                                    }
                                }
   
                            }
                        }
            })
            
            if TF[indexPath.row]==true{
                thumbsUpAction.title = "좋아요"
                thumbsUpAction.image = UIImage(systemName: "hand.thumbsup.fill")
                thumbsUpAction.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                item.message = messages[indexPath.row].body
                item.nickName = message.name
                saveMessage(likeMessage: item)
                
            }else{
                thumbsUpAction.title = "좋아요 취소"
                thumbsUpAction.image = UIImage(systemName: "hand.thumbsdown.fill")
                thumbsUpAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                item.message = ""
                item.nickName = ""
                saveMessage(likeMessage: item)
            }
            
            
            
        return [thumbsUpAction]
            
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
        options.expansionStyle = .selection
        options.transitionStyle = .drag
        
        return options
    }
}
