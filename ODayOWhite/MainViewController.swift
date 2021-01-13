//
//  MainViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit
import SwipeableTabBarController
import Firebase

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var messages: [Message] = []
//    var cell: MessageCell
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.rowHeight = 80.0
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        
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
                            if let messageSender = data["nickName"] as? String, let messageBody = data["mesagee"] as? String, let messageEmail = data["email"] as? String{
                                let newMessage = Message(sender: messageEmail, body: messageBody, name: messageSender)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
//                                    let indexPath = IndexPath(row: self.messages.count-1, section: 0)
//                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
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
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        
        cell.messageTextLabel.text = message.body
        cell.messageSenderLabel.text = message.name
        message.like ? cell.messageLikeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal) : cell.messageLikeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        
      
        return cell
    }
    
}
extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        messages[indexPath.row].like = !messages[indexPath.row].like
        
        tableView.reloadData()
    }
}
