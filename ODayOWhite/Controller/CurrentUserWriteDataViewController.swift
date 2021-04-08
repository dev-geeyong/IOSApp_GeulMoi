//
//  CurrentUserWriteDataViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/19.
//

import UIKit
import Firebase
import SwipeCellKit

class CurrentUserWriteDataViewController: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet var tableView: UITableView!
    var messages: [CurrentUserMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.register(UINib(nibName: "LikeMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeMessageCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        loadMessages()
        
    }
    //MARK: - 화면이 사라질 때 이전화면으로 돌려놓기.
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - 접속한 사용자가 작성한 글 가져오기
    func loadMessages(){
        DispatchQueue.main.async {
            if let currentEmail = Auth.auth().currentUser?.email{
                self.db.collection("users")
                    .whereField("email", isEqualTo: currentEmail)
                    .addSnapshotListener(){(querySnapshot, err) in
                        if let err = err{
                            print(err)
                        }else{
                            if let snapshotDocuments = querySnapshot?.documents{
                                for doc in snapshotDocuments{
                                    let data = doc.data()
                                    let body = data["mesagee"]
                                    let newMessage = CurrentUserMessage(body: body as! String)
                                    self.messages.append(newMessage)
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    
    
    
}
extension CurrentUserWriteDataViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
}
extension CurrentUserWriteDataViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeMessageCell", for: indexPath) as! LikeMessageTableViewCell
        cell.delegate = self
        cell.likeMessage.text = message.body
        return cell
    }
    
    
}
extension CurrentUserWriteDataViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeMessageCell", for: indexPath) as! LikeMessageTableViewCell
        
        switch orientation {
        
        case .right:
            
            let deleteAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                DispatchQueue.main.async {
                    if let currentEmail = Auth.auth().currentUser?.email{
                        self.db.collection("users")
                            .whereField("email", isEqualTo: currentEmail)
                            .addSnapshotListener(){(querySnapshot, err) in
                                if let err = err {
                                    print(err)
                                }else{
                                    
                                    if let snapshotDocuments = querySnapshot?.documents{
                                        for doc in snapshotDocuments{
                                            let data = doc.data()
                                            if (data["mesagee"] as! String == message.body){
                                                doc.reference.delete()
                                                self.view.makeToast("삭제완료")
                                                
                                                
                                            }
                                        }
                                        
                                        
                                        
                                        
                                        DispatchQueue.main.async() {
                                            
                                            //
                                            self.navigationController?.popViewController(animated: true)
                                            
                                        }
                                        
                                        
                                    }else{
                                        self.view.makeToast("fail")
                                        
                                    }
                                    
                                    
                                }
                            }
                    }
                }
            })
            
            deleteAction.title = "삭제하기"
            deleteAction.image = UIImage(systemName: "trash.fill")
            deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            
            return [deleteAction]
            
            
        case .left:
            let thumbsUpAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                
                
                
                let activityVC = UIActivityViewController(activityItems: [message.body], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                tableView.reloadData()
            })
            
            thumbsUpAction.title = "공유하기"
            thumbsUpAction.image = UIImage(systemName: "square.and.arrow.up")
            thumbsUpAction.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            
            
            
            return [thumbsUpAction]
        }
        
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .drag
        
        return options
    }
    
}
