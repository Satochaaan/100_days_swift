//
//  ActionViewController.swift
//  Extension
//
//  Created by TwoStraws on 18/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
	@IBOutlet var script: UITextView!

	var pageTitle = ""
	var pageURL = ""
    var savedScripts = [ScriptSavedForTableView]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                                                barButtonSystemItem: .done,
                                                target: self,
                                                action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                                                barButtonSystemItem: .action,
                                                target: self,
                                                action: #selector(showSavedScriptList))

		let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

		if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
			if let itemProvider = inputItem.attachments?.first {
				itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [unowned self] (dict, error) in
					let itemDictionary = dict as! NSDictionary
					let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary

					self.pageTitle = javaScriptValues["title"] as! String
					self.pageURL = javaScriptValues["URL"] as! String

					DispatchQueue.main.async {
						self.title = self.pageTitle
					}
				}
			}
        }
    }

	@objc func done() {
        let ac = UIAlertController(title: "Please Script Name.", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            self?.saveScriptByURL(scriptName: name)
            self?.scriptSelected(text: self?.script.text ?? "")
        }))
        
        present(ac, animated: true)
	}
    
    func scriptSelected(text: String) {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext!.completeRequest(returningItems: [item])
    }

	@objc func adjustForKeyboard(notification: Notification) {
		let userInfo = notification.userInfo!

        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
			script.contentInset = UIEdgeInsets.zero
		} else {
			script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
		}

		script.scrollIndicatorInsets = script.contentInset

		let selectedRange = script.selectedRange
		script.scrollRangeToVisible(selectedRange)
	}
    
    @objc func showSelectScriptAlert() {
        let ac = UIAlertController(title: "Select Script", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "alert1", style: .default, handler: { [weak self] _ in
            self?.scriptSelected(text: "alert('alert1')")
        }))
        
        ac.addAction(UIAlertAction(title: "alert2", style: .default, handler: { [weak self] _ in
            self?.scriptSelected(text: "alert('alert2')")
        }))
        
        present(ac, animated: true)
    }
    
    @objc func showSavedScriptList() {
        guard let url = URL(string: pageURL) else { return }
        guard let host = url.host else { return }
        
        let defaults = UserDefaults.standard
        if let savedScriptsData = defaults.object(forKey: host) as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                savedScripts = try jsonDecoder.decode([ScriptSavedForTableView].self, from: savedScriptsData)
            } catch {
                print("Failed to load scripts.")
                return
            }
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ScriptTable") as? ScriptTableViewController {
                vc.scripts = savedScripts
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func saveScriptByURL(scriptName: String) {
        guard let url = URL(string: pageURL) else { return }
        guard let host = url.host else { return }
        
        let jsonEncoder = JSONEncoder()
        let defaults = UserDefaults.standard
        
        let script = ScriptSavedForTableView(tableName: scriptName, tableScript: script.text)
        savedScripts.append(script)
        
        if let savedData = try? jsonEncoder.encode(savedScripts) {
            defaults.set(savedData, forKey: host)
        } else {
            print("Failed to save pictures.")
        }
    }
}
