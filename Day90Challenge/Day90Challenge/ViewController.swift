//
//  ViewController.swift
//  Day90Challenge
//
//  Created by 川野智史 on 2022/04/08.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet private var imageView: UIImageView!
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func tappedTopText(_ sender: Any) {
        guard let image = imageView.image else { return }
        
        let ac = UIAlertController(title: "top text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?.first?.placeholder = "Input Text"
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: image.size.width, height: image.size.height))
            
            let img = renderer.image { ctx in
                image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center

                let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!,
                             NSAttributedString.Key.paragraphStyle: paragraphStyle]

                guard let string = ac.textFields?.first?.text, !string.isEmpty else { return }
                string.draw(with: CGRect(x: 32, y: 32, width: image.size.width - 32, height: image.size.height - 32), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            }
            
            self?.imageView.image = img
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @IBAction private func tappedImportButton(_ sender: Any) {
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @IBAction private func tappedBottomText(_ sender: Any) {
        guard let image = imageView.image else { return }
        
        let ac = UIAlertController(title: "bottom text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?.first?.placeholder = "Input Text"
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: image.size.width, height: image.size.height))
            
            let img = renderer.image { ctx in
                image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center

                let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!,
                             NSAttributedString.Key.paragraphStyle: paragraphStyle]

                guard let string = ac.textFields?.first?.text, !string.isEmpty else { return }
                string.draw(with: CGRect(x: 32, y: image.size.height - 64, width: image.size.width - 32, height: image.size.height - 32), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            }
            
            self?.imageView.image = img
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView?.image = image
        } else {
            print("Error")
        }
        
        self.dismiss(animated: true)
    }
}

