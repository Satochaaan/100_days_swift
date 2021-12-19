//
//  ViewController.swift
//  Project16
//
//  Created by Paul Hudson on 31/03/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showSelectMapTypeAlert))

        let london = Capital(title: "London",
                             coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                             info: "https://ja.wikipedia.org/wiki/%E3%83%AD%E3%83%B3%E3%83%89%E3%83%B3")
        let oslo = Capital(title: "Oslo",
                           coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
                           info: "https://ja.wikipedia.org/wiki/%E3%82%AA%E3%82%B9%E3%83%AD")
        let paris = Capital(title: "Paris",
                            coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
                            info: "https://ja.wikipedia.org/wiki/%E3%83%91%E3%83%AA")
        let rome = Capital(title: "Rome",
                           coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
                           info: "https://ja.wikipedia.org/wiki/%E3%83%AD%E3%83%BC%E3%83%9E")
        let washington = Capital(title: "Washington DC",
                                 coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667),
                                 info: "https://ja.wikipedia.org/wiki/%E3%83%AF%E3%82%B7%E3%83%B3%E3%83%88%E3%83%B3D.C.")

        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    @objc func showSelectMapTypeAlert() {
        let ac = UIAlertController(title: "Select Map Type", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .standard
        }))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "MutedStandard", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .mutedStandard
        }))
        ac.addAction(UIAlertAction(title: "HybridFlyover", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .hybridFlyover
        }))
        ac.addAction(UIAlertAction(title: "SatelliteFlyover", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .satelliteFlyover
        }))
        
        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }

        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.pinTintColor = .green

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }

        let vc = DetailViewController()
        vc.webUrl = capital.info
        navigationController?.pushViewController(vc, animated: true)
    }
}

