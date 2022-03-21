//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import PlaygroundSupport

// MARK: - Day80-81
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

// MARK: - Day82 Challenge

// challenge1
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

let uiview = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
uiview.backgroundColor = .blue
PlaygroundPage.current.liveView = uiview
uiview.bounceOut(duration: 10)

// challenge2
extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            closure()
        }
    }
}

let timesNum = 4
timesNum.times {
    print("hogehoge")
}

// challenge3
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

var numbers = [1, 2, 3, 4, 5]
numbers.remove(item: 3)
