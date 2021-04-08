//
//  ShowSaveDataViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/18.
//

import UIKit
import Firebase
import SwipeCellKit

class ShowSaveDataViewController: UIViewController {
    let db = Firestore.firestore()
    var ary:Array<String>? = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LikeMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeMessageCell")
        getMessageData()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getMessageData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        getMessageData()
        
        
    }
    func loadMessages(){
        DispatchQueue.main.async {
            if self.ary != nil{
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }else{
                print("loadMessage error")
            }}
    }
    
    func getMessageData(){
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
                                self.ary = data["likemessages"] as? Array<String>
                                
                                
                                
                            }else{
                                
                            }
                            
                        }
                    }
            }
            self.tableView.reloadData()
            
        }
    }
    
    
}
extension ShowSaveDataViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ary != nil{
            return ary!.count
        }
        else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeMessageCell", for: indexPath) as! LikeMessageTableViewCell
        cell.delegate = self
        if ary != nil {
            cell.likeMessage.text = ary![indexPath.row]
            
        }
        return cell
    }
    
    
}
extension ShowSaveDataViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeMessageCell", for: indexPath) as! LikeMessageTableViewCell
        
        switch orientation {
        
        case .right:
            
            let deleteAction = SwipeAction(style: .default, title: nil, handler: {
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
                                        
                                        doc.reference.updateData(["likemessages":FieldValue.arrayRemove([self.ary![indexPath.row]])])
                                        
                                        self.view.makeToast("삭제완료")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
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
                
                
                
                let activityVC = UIActivityViewController(activityItems: [self.ary![indexPath.row]], applicationActivities: nil)
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
extension ShowSaveDataViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
}
