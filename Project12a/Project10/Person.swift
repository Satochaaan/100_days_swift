//
//  Person.swift
//  Project10
//
//  Created by 川野智史 on 2021/11/01.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
