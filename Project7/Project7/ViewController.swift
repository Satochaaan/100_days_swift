//
//  ViewController.swift
//  Project7
//
//  Created by 川野智史 on 2021/09/28.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showCredit))
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilter))
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    @objc func showCredit() {
        let ac = UIAlertController(title: "credit", message: "white house", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showFilter() {
        let ac = UIAlertController(title: "フィルター", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "検索", style: .default, handler: { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }))
        present(ac, animated: true)
    }
    
    func submit(_ filterWord: String) {
        if filterWord == "" {
            filteredPetitions = petitions
            tableView.reloadData()
            return
        }
        
        self.filteredPetitions.removeAll()
        
        for petition in self.petitions {
            if petition.title.contains(filterWord) || petition.body.contains(filterWord) {
                self.filteredPetitions.append(petition)
            }
        }
        
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

