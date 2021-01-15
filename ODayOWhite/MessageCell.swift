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

        let number = Int.random(in: 1...9)
        print(number)
//        backgroundImageView.image = UIImage(named: ary[number])
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}
extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}
