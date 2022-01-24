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
        
        memoList.append(Memo(title: "title1", memo: "memo1", date: "2022-01-21"))
        memoList.append(Memo(title: "title2", memo: "memo2", date: "2022-01-22"))
        memoList.append(Memo(title: "title3", memo: "memo3", date: "2022-01-23"))
        memoListTableView.reloadData()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(memoList) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "memoList")
        } else {
            print("Failed to save people.")
        }
    }
    
    @objc func newMemo() {
        
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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MemoEdit") as? MemoEditViewController {
            vc.memo = memoList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
