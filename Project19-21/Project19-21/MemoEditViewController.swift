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
    var saveMemo: ((Int, Memo) -> Void) = { _, _ in }
    
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
        
        // TextViewのInset設定
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func tappedComplete() {
        memo.title = createTitleByMemo()
        memo.date = createNowDateTime()
        memo.memo = memoTextView.text
        
        saveMemo(index, memo)
        memoTextView.resignFirstResponder()
    }
    
    @objc func newMemo() {
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            memoTextView.contentInset = .zero
        } else {
            memoTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        memoTextView.scrollIndicatorInsets = memoTextView.contentInset

        let selectedRange = memoTextView.selectedRange
        memoTextView.scrollRangeToVisible(selectedRange)
    }
    
    private func createTitleByMemo() -> String {
        guard let memoText = memoTextView.text else { return "No Title." }
        let array = memoText.components(separatedBy: "\n")
        return array[0]
    }
    
    private func createNowDateTime() -> String{
        let f = DateFormatter()
        f.timeStyle = .medium
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        return f.string(from: now)
    }
}
