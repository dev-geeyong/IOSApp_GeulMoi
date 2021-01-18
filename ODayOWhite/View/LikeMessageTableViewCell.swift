//
//  LikeMessageTableViewCell.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/14.
//

import UIKit
import SwipeCellKit

class LikeMessageTableViewCell: SwipeTableViewCell {

    @IBOutlet var likeMessageNickname: UILabel!
    @IBOutlet var likeMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
