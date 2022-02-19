//
//  ViewController.swift
//  Project22
//
//  Created by TwoStraws on 19/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import CoreLocation
import UIKit

struct Const {
    static let uuid1 = "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"
    static let uuid2 = "74278BDA-B644-4520-8F0C-720EAF059935"
    
    static let circleImmediate: CGFloat = 1.0
    static let circleUnknown: CGFloat = 0.001
    static let circleFar: CGFloat = 0.25
    static let circleNear: CGFloat = 0.5
}

class ViewController: UIViewController, CLLocationManagerDelegate {
	@IBOutlet var distanceReading: UILabel!
    @IBOutlet var distanceReading2: UILabel!
    @IBOutlet var circleView: UIView!
    @IBOutlet var circleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var circleViewWidthConstraint: NSLayoutConstraint!
    
    var locationManager: CLLocationManager!
    var isFirstDetected: Bool = false

	override func viewDidLoad() {
		super.viewDidLoad()

		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
        
        circleView.layer.cornerRadius = 128

		view.backgroundColor = UIColor.gray
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					startScanning()
				}
			}
		}
	}

	func startScanning() {
        let uuid = UUID(uuidString: Const.uuid1)!
		let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
		locationManager.startMonitoring(for: beaconRegion)
		locationManager.startRangingBeacons(in: beaconRegion)
        
        let uuid2 = UUID(uuidString: Const.uuid2)!
        let beaconRegion2 = CLBeaconRegion(uuid: uuid2, major: 123, minor: 456, identifier: "MyBeacon2")
        locationManager.startMonitoring(for: beaconRegion2)
        locationManager.startRangingBeacons(in: beaconRegion2)
	}

    func update(uuid: UUID?, distance: CLProximity) {
		UIView.animate(withDuration: 0.8) { [unowned self] in
			switch distance {
			case .unknown:
				self.view.backgroundColor = UIColor.gray
                if uuid?.uuidString == Const.uuid1 {
                    self.distanceReading.text = "UNKNOWN"
                } else if uuid?.uuidString == Const.uuid2 {
                    self.distanceReading2.text = "UNKNOWN"
                } else {
                    self.distanceReading.text = "UNKNOWN"
                    self.distanceReading2.text = "UNKNOWN"
                }
                
                let transform = CGAffineTransform(scaleX: Const.circleUnknown, y: Const.circleUnknown)
                UIView.animate(withDuration: 1.0) {
                    self.circleView.transform = transform
                }

			case .far:
				self.view.backgroundColor = UIColor.blue
                if uuid?.uuidString == Const.uuid1 {
                    self.distanceReading.text = "FAR"
                } else if uuid?.uuidString == Const.uuid2 {
                    self.distanceReading2.text = "FAR"
                }
                let transform = CGAffineTransform(scaleX: Const.circleFar, y: Const.circleFar)
                UIView.animate(withDuration: 1.0) {
                    self.circleView.transform = transform
                }

			case .near:
				self.view.backgroundColor = UIColor.orange
                if uuid?.uuidString == Const.uuid1 {
                    self.distanceReading.text = "NEAR"
                } else if uuid?.uuidString == Const.uuid2 {
                    self.distanceReading2.text = "NEAR"
                }
                let transform = CGAffineTransform(scaleX: Const.circleNear, y: Const.circleNear)
                UIView.animate(withDuration: 1.0) {
                    self.circleView.transform = transform
                }

			case .immediate:
				self.view.backgroundColor = UIColor.red
                if uuid?.uuidString == Const.uuid1 {
                    self.distanceReading.text = "RIGHT HERE"
                } else if uuid?.uuidString == Const.uuid2 {
                    self.distanceReading2.text = "RIGHT HERE"
                }
                let transform = CGAffineTransform(scaleX: Const.circleImmediate, y: Const.circleImmediate)
                UIView.animate(withDuration: 1.0) {
                    self.circleView.transform = transform
                }
			}
		}
	}

	func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
			let beacon = beacons[0]
            update(uuid: beacon.uuid, distance: beacon.proximity)
            
            // 初回アラート
            if !isFirstDetected {
                isFirstDetected = true
                
                let f = DateFormatter()
                f.timeStyle = .full
                f.dateStyle = .full
                f.locale = Locale(identifier: "ja_JP")
                let now = Date()
                let nowString = f.string(from: now)
                
                let ac = UIAlertController(title: "Detected!", message: nowString, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            }
		} else {
//            update(uuid: nil, distance: .unknown)
		}
	}
}

