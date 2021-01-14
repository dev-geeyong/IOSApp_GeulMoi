//
//  LikeMessage.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/14.
//

import Foundation
import RealmSwift

class LikeMessage: Object{
    @objc dynamic var message: String = ""
    @objc dynamic var nickName: String = ""
}
