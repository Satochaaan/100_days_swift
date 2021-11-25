//
//  ViewController.swift
//  Project10-12
//
//  Created by 川野智史 on 2021/11/18.
//

import UIKit

class ViewController: UITableViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pictures Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
        
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load pictures.")
            }
        }
    }

    func loadSavedImages() {
        // 保存した画像を読み込む
    }
    
    @objc func addNewPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        present(picker, animated: true)
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            UserDefaults.standard.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures.")
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picture = pictures[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.picture = picture
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            do {
                try jpegData.write(to: imagePath)
            } catch {
                print("Error-----jpegWriteFailed-----")
            }
        }
        
        let picture = Picture(name: "Unknown", image: imageName)
        
        let ac = UIAlertController(title: "Picture Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            picture.name = newName
            
            self?.pictures.append(picture)
            self?.save()
            self?.tableView.reloadData()
        }))
        
        dismiss(animated: true) {
            self.present(ac, animated: true)
        }
    }
}

