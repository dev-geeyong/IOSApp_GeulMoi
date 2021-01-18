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
    var ary:Array<String> = []

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        tableView.rowHeight = 80.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LikeMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeMessageCell")
        getMessageData()
    
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getMessageData()
        tableView.reloadData()
        print("will")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidApperar")
        getMessageData()
        
        tableView.reloadData()
//        loadMessages()
        //loadItem()
       
      
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
                        self.ary = data["likemessages"] as! Array<String>
                        
                      
                
                    }else{
         
                    }
                    
//                                doc?.reference.updateData(["likemessage":FieldValue.arrayRemove([message.body])])
                    
                }
            }
        }
            self.tableView.reloadData()
            
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
extension ShowSaveDataViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ary != nil{
            return ary.count
        }
        else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeMessageCell", for: indexPath) as! LikeMessageTableViewCell
        cell.delegate = self
        if ary != nil {
            cell.likeMessage.text = ary[indexPath.row]
  
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
                                        
                                        print(self.ary[indexPath.row])
                                        
                                        doc.reference.updateData(["likemessages":FieldValue.arrayRemove([self.ary[indexPath.row]])])
                                        
                                        self.view.makeToast("삭제완료")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            self.navigationController?.popViewController(animated: true)// your code here
                                        }
                                            
                                       
                                    }else{
                                        self.view.makeToast("fail")
                                        
                                    }
                                    
    //                                doc?.reference.updateData(["likemessage":FieldValue.arrayRemove([cell.likeMessage.text])])
                                    
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
            let deleteAction2 = SwipeAction(style: .default, title: nil, handler: {
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
                                    doc.reference.updateData(["likemessage":FieldValue.arrayRemove([cell.likeMessage.text])])
                                    self.view.makeToast("저장완료")
                                    tableView.reloadRows(at: [indexPath], with: .none)
                                }else{
                                    self.view.makeToast("fail")
                                    
                                }
                                
//                                doc?.reference.updateData(["likemessage":FieldValue.arrayRemove([cell.likeMessage.text])])
                                
                            }
                        }
                    }
                }
            })
        
            deleteAction2.title = "저장하기"
            deleteAction2.image = UIImage(systemName: "square.and.arrow.down.fill")
            deleteAction2.backgroundColor = #colorLiteral(red: 0.03715451062, green: 0.4638677239, blue: 0.9536394477, alpha: 1)
            return [deleteAction2]
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
