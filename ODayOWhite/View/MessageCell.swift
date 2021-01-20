//
//  MessageCell.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit
import SwipeCellKit
class MessageCell: SwipeTableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var messageTextLabel: UILabel!
    @IBOutlet var messageSenderLabel: UILabel!
    
    @IBOutlet var backgroundBottomView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var messageCountLike: UILabel!
    
    @IBOutlet var messageLikeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
       

        
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = 20.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
