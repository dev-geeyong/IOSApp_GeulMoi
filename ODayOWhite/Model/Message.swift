//
//  Message.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/13.
//

import Foundation

struct Message{
    
    let sender: String
    let body: String
    let name: String
    var like: Bool
    var likeNum: Int = 0
    var TF: [Bool] = Array(repeating: true, count: 100000)
}
