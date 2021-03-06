//
//  ViewController.swift
//  Project21
//
//  Created by TwoStraws on 18/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {


	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
	}

	@objc func registerLocal() {
		let center = UNUserNotificationCenter.current()

		center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
			if granted {
				print("Yay!")
			} else {
				print("D'oh")
			}
		}
	}

    @objc func scheduleLocal() {
		registerCategories()

		let center = UNUserNotificationCenter.current()

		// not required, but useful for testing!
		center.removeAllPendingNotificationRequests()

		let content = UNMutableNotificationContent()
		content.title = "Late wake up call"
		content.body = "The early bird catches the worm, but the second mouse gets the cheese."
		content.categoryIdentifier = "alarm"
		content.userInfo = ["customData": "fizzbuzz"]
		content.sound = UNNotificationSound.default

		var dateComponents = DateComponents()
		dateComponents.hour = 12
		dateComponents.minute = 16
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)
	}
    
    // 24時間後に再通知
    func remindLocal(content: UNNotificationContent) {
        let center = UNUserNotificationCenter.current()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (86400), repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

	func registerCategories() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self

		let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .foreground)
		let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [])

		center.setNotificationCategories([category])
	}

	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		// pull out the buried userInfo dictionary
		let userInfo = response.notification.request.content.userInfo

		if let customData = userInfo["customData"] as? String {
			print("Custom data received: \(customData)")

			switch response.actionIdentifier {
			case UNNotificationDefaultActionIdentifier:
				// the user swiped to unlock; do nothing
				print("Default identifier")
                showAlertController(title: "Notification Open", message: "Default Identifier")

			case "show":
				print("Show more information…")
                showAlertController(title: "Notification Open", message: "Show Identifier")
            
            case "remind":
                print("Remind me later…")
                remindLocal(content: response.notification.request.content)
                showAlertController(title: "Notification Open", message: "Remind Identifier")

			default:
                showAlertController(title: "Notification Open", message: "Unknown Identifier")
				break
			}
		}

		// you need to call the completion handler when you're done
		completionHandler()
	}
    
    func showAlertController(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .default))
        present(ac, animated: true)
    }
}

