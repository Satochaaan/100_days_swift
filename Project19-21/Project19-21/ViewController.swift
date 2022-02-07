//
//  ViewController.swift
//  Project19-21
//
//  Created by 川野智史 on 2022/01/19.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var memoListTableView: UITableView!
    private var memoList: [Memo] = [Memo]()
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "メモ"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let newMemo = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMemo))
        toolbarItems = [spacer, newMemo]
        
        navigationController?.toolbar.tintColor = .systemYellow
        navigationController?.isToolbarHidden = false
        
        loadMemo()
    }
    
    // MARK: - Function
    func loadMemo() {
        let defaults = UserDefaults.standard
        
        if let savedMemos = defaults.object(forKey: "memoList") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                memoList = try jsonDecoder.decode([Memo].self, from: savedMemos)
                memoListTableView.reloadData()
            } catch {
                print("Failed to load memos.")
            }
        }
        
        memoListTableView.reloadData()
    }
    
    func saveMemo(index: Int, editedMemo: Memo) {
        guard index < memoList.count else { return }
        
        let jsonEncoder = JSONEncoder()
        
        memoList[index] = editedMemo
        
        if let savedData = try? jsonEncoder.encode(memoList) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "memoList")
            memoListTableView.reloadData()
        } else {
            print("Failed to save memo.")
        }
    }
    
    func deleteMemo(index: Int) {
        guard index < memoList.count else { return }
        
        memoList.remove(at: index)
        
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(memoList) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "memoList")
            memoListTableView.reloadData()
        } else {
            print("Failed to delete memo.")
        }
    }
    
    @objc func newMemo() {
        let newMemo = Memo(title: "", memo: "", date: "")
        let index = memoList.count
        
        memoList.append(newMemo)
        memoListTableView.reloadData()
        
        if let vc = storyboard?.instantiateViewController(identifier: "MemoEdit", creator: { coder in
            MemoEditViewController(coder: coder, index: index, memo: self.memoList[index])
        }) {
            vc.saveMemo = self.saveMemo
            vc.deleteMemo = self.deleteMemo
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)
        cell.textLabel?.text = memoList[indexPath.row].title
        cell.detailTextLabel?.text = memoList[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "MemoEdit", creator: { coder in
            MemoEditViewController(coder: coder, index: indexPath.row, memo: self.memoList[indexPath.row])
        }) {
            vc.saveMemo = self.saveMemo
            vc.deleteMemo = self.deleteMemo
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
