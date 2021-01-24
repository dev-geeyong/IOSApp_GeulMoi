//
//  Feed.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/24.
//

import Foundation
class Feed {
    let likeNum : Int
    var isFavorite : Bool  // 하트
    
    // 생성자
    init(likeNum: Int , isFavorite: Bool) {
        self.likeNum = likeNum
        self.isFavorite = isFavorite
    }
}
