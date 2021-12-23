//
//  DetailViewController.swift
//  Project1
//
//  Created by 川野智史 on 2021/09/05.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(selectedImage != nil)
        
        title = imageName
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
        saveCounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    func saveCounts() {
        guard let imageName = selectedImage else { return }
        
        var count = 0
        let defaults = UserDefaults.standard
        
        count = defaults.integer(forKey: imageName)
        count += 1
        
        defaults.set(count, forKey: imageName)
        print(imageName + ": " + String(count) + "--------")
    }
}
