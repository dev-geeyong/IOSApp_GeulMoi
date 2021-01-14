//
//  LikeViewViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/13.
//

import UIKit
import Firebase
import RealmSwift

class LikeViewViewController: UIViewController  {

    @IBOutlet var tableView: UITableView!
    let realm = try! Realm()
    var likeArray: Results<LikeMessage>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        loadItem()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "LikeMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeMessageCell")
    }
    func loadItem(){
        likeArray = realm.objects(LikeMessage.self)
        tableView.reloadData()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        loadItem()
      
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
extension LikeViewViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeMessageCell", for: indexPath) as! LikeMessageTableViewCell
        
        if likeArray?[indexPath.row].message == ""{
            
        }
        else{
            cell.likeMessage.text = likeArray?[indexPath.row].message
            cell.likeMessageNickname.text = likeArray?[indexPath.row].nickName
        }
            
            
        
        return cell
          
        }
        
        

    }
    
    

extension LikeViewViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        tableView.reloadData()
                        
    }
}

