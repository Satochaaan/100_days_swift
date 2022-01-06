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

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                                                barButtonSystemItem: .done,
                                                target: self,
                                                action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                                                barButtonSystemItem: .action,
                                                target: self,
                                                action: #selector(showSelectScriptAlert))

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
        scriptSelected(text: script.text)
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
    
    func saveScriptByURL(script: String, urlString: String) {
        guard let url = URL(string: urlString) else { return }
        guard let host = url.host else { return }
        
        let defaults = UserDefaults.standard
        
        defaults.set(script, forKey: host)
    }
}
