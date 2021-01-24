//
//  MessageCell.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/12.
//

import UIKit
import Foundation
import SwipeCellKit
class MessageCell: SwipeTableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var messageTextLabel: UILabel!
    @IBOutlet var messageSenderLabel: UILabel!
    
    @IBOutlet var backgroundBottomView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var messageCountLike: UILabel!
    
    @IBOutlet var messageLikeButton: UIButton!
    
//    var feedData: Feed? {
//        didSet{
//            print("MyTableViewCell - didSet / feedData: \(feedData)")
//            
//            if let data = feedData {
//                // 피드 데이터에 따라 쎌의 UI 변경
//
//                messageTextLabel.text = data.content
//            }
//        }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
       

        
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = 20.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
