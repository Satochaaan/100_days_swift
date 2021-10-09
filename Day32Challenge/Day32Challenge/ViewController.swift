//
//  ViewController.swift
//  Day32Challenge
//
//  Created by 川野智史 on 2021/09/27.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showEnterItemName))
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTable))
    }


    @objc func showEnterItemName() {
        let ac = UIAlertController(title: "商品名入力", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "決定", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        shoppingList.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func refreshTable() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Items", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
}

