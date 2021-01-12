//
//  MessageCell.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet var messageTextLabel: UILabel!
    @IBOutlet var messageSenderLabel: UILabel!
    

    var bRec:Bool = true
    @IBOutlet var messageLikeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //heart
    
    @IBAction func touchUpLikeButton(_ sender: UIButton) {//heart.fill
        bRec = !bRec
            if bRec {
                //messageLikeButton.setImage(UIImage(named: "heart"), for: .normal)
                messageLikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                print(messageTextLabel.text)
            } else {
                messageLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
