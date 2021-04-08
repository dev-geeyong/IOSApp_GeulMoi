//
//  MainViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit
import Firebase
import SwipeCellKit
import Toast_Swift
import Kingfisher

import MessageUI



class MainViewController: UIViewController {
    
    @IBOutlet var bestMessage: UILabel!
    @IBOutlet var bestNickname: UILabel!
    @IBOutlet var bestLike: UILabel!
    
    @IBOutlet var bestImageView: UIImageView!
    
    
    var commonImageURL = ""
    var count = 0
    
    var url: URL?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var messages: [Message] = []
    var testArray: [Feed] = []
    
    
    var block: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let blockEmail = UserDefaults.standard.string(forKey: "email"){
            block = blockEmail
        }
        print("메인페이지 viewDidLoad")
        showLoader(true)
        self.loadBestMessage()
        self.loadMessages()
        
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.rowHeight = 200
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
                            self.bestImageView.image = UIImage(named: "22")
                            
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
                    
                    DispatchQueue.global().async {
                        if let snapshotDocuments = querySnapshot?.documents{
                            for doc in snapshotDocuments{
                                //                                self.count += 1
                                //                                if self.count == 5{
                                //                                    break
                                //                                }
                                let data = doc.data()
                                
                                if let messageSender = data["nickName"] as? String, let messageBody = data["mesagee"] as? String, let messageEmail = data["email"] as? String, let likeNum = data["likeNum"] as? Int, let blockcount = data["block"] as? Int{
                                    if  blockcount >= 3{
                                        doc.reference.delete()
                                    }
                                    if data["email"] as! String != self.block{
                                        
                                        let newMessage = Message(sender: messageEmail, body: messageBody, name: messageSender, likeNum: likeNum)
                                        self.messages.append(newMessage)
                                        let test = Feed(likeNum: likeNum, isFavorite: false)
                                        let test2 = Feed(likeNum: 18, isFavorite: false)
                                        if (K.TF == true){
                                            self.testArray.insert(test2, at: 0)
                                            K.TF = false
                                        }
                                        
                                        self.testArray.append(test)
                                    }
                                    
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                        
                                        let indexPath = IndexPath(row: 0, section: 0)
                                        
                                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                    self.showLoader(false)
                    
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
        //        if self.testArray.count > 0 {
        //            cell.messageTextLabel.text = testArray[indexPath.row].content
        //        }
        cell.messageTextLabel.text = message.body
        cell.messageSenderLabel.text = message.name
        cell.messageCountLike.text = "\(message.likeNum)"
        
        
        return cell
    }
    
}
extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}
//MARK: - swipetable
extension MainViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let message = messages[indexPath.row] as Message
        let dataItem = testArray[indexPath.row] as Feed
        
        let cell = tableView.cellForRow(at: indexPath) as! MessageCell
        
        switch orientation {
        
        case .left:
            let thumbsUpAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                
                
                
                let activityVC = UIActivityViewController(activityItems: [self.messages[indexPath.row].body], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                tableView.reloadData()
            })
            
            thumbsUpAction.title = "공유하기"
            thumbsUpAction.image = UIImage(systemName: "square.and.arrow.up")
            thumbsUpAction.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            
            let thumbsUpAction2 = SwipeAction(style: .destructive, title: nil, handler: {
                action, indexPath in
                
                //                print(self.messages[indexPath.row])
                
                
                guard  MFMailComposeViewController.canSendMail() else {
                    self.view.makeToast("연결된 mail이 없습니다 아이폰 기본 mail 어플을 확인해주세요")
                    return
                }
                self.db.collection("users").whereField("email", isEqualTo: self.messages[indexPath.row].sender).getDocuments(){(querySnapshot, err) in
                    if let err = err {
                        print(err)
                    }else{
                        
                        let doc = querySnapshot!.documents.first
                        //doc?.reference.delete()
                        if let currentblock = doc?.data()["block"]{
                            doc?.reference.updateData(["block": currentblock as! Int + 1])
                            let composer = MFMailComposeViewController()
                            composer.mailComposeDelegate = self
                            composer.setToRecipients(["dev.geeyong@gmail.com"])
                            composer.setSubject("신고하기")
                            composer.setMessageBody("신고내용 : \(self.messages[indexPath.row].body) 닉네임 : \(self.messages[indexPath.row].sender)", isHTML: false)
                            UserDefaults.standard.set(self.messages[indexPath.row].sender, forKey: "email")
                            self.block = self.messages[indexPath.row].sender
                            self.present(composer, animated: true)
                            self.messages.remove(at: indexPath.row)
                            tableView.reloadData()
                        }
                        
                    }
                    
                    
                    
                }
                
            })
            
            thumbsUpAction2.title = "신고하기"
            thumbsUpAction2.image = UIImage(systemName: "exclamationmark.bubble")
            thumbsUpAction2.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            
            return [thumbsUpAction2, thumbsUpAction]
            
            
        case .right:
            
            let thumbsUpAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                
                
                let updateedStatus = !dataItem.isFavorite
                dataItem.isFavorite = updateedStatus
                let body = self.messages[indexPath.row].body
                cell.hideSwipe(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    // 현재 스와이프 한 애만 리로드 하기
                    tableView.reloadRows(at: [indexPath], with: .none)
                })
                
                self.db.collection("users").whereField("mesagee", isEqualTo: body).getDocuments(){(querySnapshot, err) in
                    if let err = err {
                        print(err)
                    }else{
                        
                        let doc = querySnapshot!.documents.first
                        //doc?.reference.delete()
                        if let likenum = doc?.data()["likeNum"]{
                            
                            if dataItem.isFavorite == true{
                                
                                doc?.reference.updateData([
                                    
                                    "likeNum": likenum as! Int + 1,
                                    
                                ])
                                self.view.makeToast("좋아요")
                                //tableView.reloadRows(at: [indexPath], with: .fade)
                            }else{
                                
                                doc?.reference.updateData([
                                    
                                    "likeNum": likenum as! Int - 1,
                                    
                                ])
                                self.view.makeToast("좋아요 취소")
                                //tableView.reloadRows(at: [indexPath], with: .fade)
                            }
                        }
                        
                    }
                }
            })
            
            
            thumbsUpAction.title = dataItem.isFavorite ? "좋아요 취소" : "좋아요"
            thumbsUpAction.image =  UIImage(systemName:dataItem.isFavorite ? "hand.thumbsdown.fill" : "hand.thumbsup.fill")
            thumbsUpAction.backgroundColor = dataItem.isFavorite ?  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) : #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)

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
                                        doc.reference.updateData(["likemessages":FieldValue.arrayUnion([message.body])])
                                        self.view.makeToast("저장완료")
                                        tableView.reloadRows(at: [indexPath], with: .fade)
                                    }else{
                                        self.view.makeToast("fail")
                                        
                                    }
                                    
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
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .drag
        
        return options
    }
}
extension MainViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
        }
        
        controller.dismiss(animated: true)
    }
}
