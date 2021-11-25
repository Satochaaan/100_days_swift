//
//  Picture.swift
//  Project10-12
//
//  Created by 川野智史 on 2021/11/19.
//

import UIKit

class Picture: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
