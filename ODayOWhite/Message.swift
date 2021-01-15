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
    let number = Int.random(in: 0...34)
    let ary = ["1","3","4","5","6","7","8","18","10","11","13","16","17","18","19" , "20" , "21" , "22" , "23" , "24" , "25" , "26" , "27" , "28" , "29", "30" , "31" , "32" , "33" , "34" , "35" , "36" , "37" , "38","41"]
}
