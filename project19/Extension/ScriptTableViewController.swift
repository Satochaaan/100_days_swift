//
//  ScriptTableViewController.swift
//  Extension
//
//  Created by 川野智史 on 2022/01/06.
//  Copyright © 2022 Paul Hudson. All rights reserved.
//

import UIKit
import MobileCoreServices

class ScriptTableViewController: UITableViewController {
    
    var scripts = [ScriptSavedForTableView]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for: indexPath)
        cell.textLabel?.text = scripts[indexPath.row].tableName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // JS実行
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": scripts[indexPath.row].tableScript!]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext!.completeRequest(returningItems: [item])

    }
}
