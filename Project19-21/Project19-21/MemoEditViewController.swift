//
//  MemoEditViewController.swift
//  Project19-21
//
//  Created by 川野智史 on 2022/01/23.
//

import UIKit

class MemoEditViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private var memoTextView: UITextView!
    var memo: Memo
    var index: Int
    
    // closure
    var saveMemo: ((Int, Memo) -> Void)!
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(coder: NSCoder, index: Int, memo: Memo) {
        self.index = index
        self.memo = memo
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationBar設定
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedComplete))
        
        // toolbar設定
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
        delete.tintColor = .systemRed
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let newMemo = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMemo))
        toolbarItems = [delete, spacer, newMemo]
        
        navigationController?.toolbar.tintColor = .systemYellow
        navigationController?.isToolbarHidden = false
        
        memoTextView.text = memo.memo
    }

    @objc func tappedComplete() {
        
    }
    
    @objc func newMemo() {
        
    }
}
