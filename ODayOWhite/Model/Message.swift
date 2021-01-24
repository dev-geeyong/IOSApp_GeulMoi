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
    //var like: Bool
    var likeNum: Int = 0
    var TF: Bool = false
    //Message(sender: messageEmail, body: messageBody, name: messageSender, likeNum: likeNum)
    init(sender: String, body: String, name: String, likeNum: Int){
        self.sender = sender
        self.body = body
        self.name = name
        self.likeNum = likeNum
    }
}
