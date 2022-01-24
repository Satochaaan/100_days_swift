//
//  Memo.swift
//  Project19-21
//
//  Created by 川野智史 on 2022/01/20.
//

import Foundation

class Memo: NSObject, Codable {
    var title: String
    var memo: String
    var date: String
    
    init(title: String, memo:String, date: String) {
        self.title = title
        self.memo = memo
        self.date = date
    }
}
