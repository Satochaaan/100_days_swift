//: Playground - noun: a place where people can play

import UIKit

extension Int {
	mutating func plusOne() {
		self += 1
	}
}

extension String {
    func withPrefix(prefix: String) -> String {
        if !self.hasPrefix(prefix) {
            return prefix + self
        }
        return self
    }
    
    var isNumeric: Bool {
        let num = Double(self)
        if num == nil {
            return false
        }
        
        return true
    }
    
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

var hoge = "hogehoge"
hoge.withPrefix(prefix: "hage")
hoge.isNumeric

var stringNumeric = "123.45"
stringNumeric.isNumeric

var newLineString = "this\nis\na\ntest"
newLineString.lines

var myInt = 0
myInt.plusOne()
myInt


// THIS EXTENDS ONLY INT
//extension Int {
//	func squared() -> Int {
//		return self * self
//	}
//}

// THIS EXTENDS ALL INTEGER TYPES
extension BinaryInteger {
	func squared() -> Self {
		return self * self
	}
}

let i: Int = 8
print(i.squared())


var str = "  Hello  "
str = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)


let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSMutableAttributedString(string: string)
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

