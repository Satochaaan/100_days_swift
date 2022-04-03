//
//  DetailViewController.swift
//  Project1
//
//  Created by 川野智史 on 2021/09/05.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = imageName
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let newImage = addHeaderStringWith(image: imageView.image!)
        
        let vc = UIActivityViewController(activityItems: [newImage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func addHeaderStringWith(image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: image.size.width, height: image.size.height))
        
        let img = renderer.image { ctx in
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle]

            let string = "From Storm Viewer."
            string.draw(with: CGRect(x: 32, y: 32, width: image.size.width - 32, height: image.size.height - 32), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }

        return img
    }
}
