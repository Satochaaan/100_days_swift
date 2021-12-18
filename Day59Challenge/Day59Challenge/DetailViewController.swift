//
//  DetailViewController.swift
//  Day59Challenge
//
//  Created by 川野智史 on 2021/12/18.
//

import UIKit

class DetailViewController: UITableViewController {
    var detailItem: Country?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detail"
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Country Name"
            cell.detailTextLabel?.text = detailItem?.name
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Population"
            cell.detailTextLabel?.text = detailItem?.population
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Area"
            cell.detailTextLabel?.text = detailItem?.area
        }
        
        return cell
    }
}
