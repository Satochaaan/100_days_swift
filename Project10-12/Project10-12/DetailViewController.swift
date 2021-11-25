//
//  DetailViewController.swift
//  Project10-12
//
//  Created by 川野智史 on 2021/11/24.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var picture: Picture?
    
    init(picture: Picture) {
        self.picture = picture
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.picture = coder.decodeObject(forKey: "picture") as? Picture
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let picture = self.picture {
            title = picture.name
            let imageFullPath = getDocumentDirectory().appendingPathComponent(picture.image)
            imageView.image = UIImage(contentsOfFile: imageFullPath.path)
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
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
