//
//  MemoEditViewController.swift
//  Project19-21
//
//  Created by 川野智史 on 2022/01/23.
//

import UIKit

class MemoEditViewController: UIViewController {
    
    @IBOutlet private var memoTextView: UITextView!
    var memo: Memo = Memo(title: "", memo: "", date: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedComplete))
        
        
        memoTextView.text = memo.memo
    }
    
    private func save() {
        
    }

    @objc func tappedComplete() {
        
    }
}
