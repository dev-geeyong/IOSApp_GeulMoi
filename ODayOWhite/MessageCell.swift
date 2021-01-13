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
    
    @IBOutlet var messageCountLike: UILabel!
    
    @IBOutlet var messageLikeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}
