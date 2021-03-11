//
//  ViewController.swift
//  FaceCha
//
//  Created by RooZin on 2021/03/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var celebrityName: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    var imageManager = ImageManager()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageManager.delegate = self
        imagePicker.delegate = self
        
        searchButton.layer.cornerRadius = 10
        selectButton.layer.cornerRadius = 20
        uploadedImage.image = UIImage(named: "wj.jpeg")
    }
    
    @IBAction func pressSearch(_ sender: UIButton) {
        if let image = uploadedImage.image {
            imageManager.postData(image)
        }
    }
    
}
//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func pressSelect(_ sender: UIButton) {
        let alert =  UIAlertController(title: "SELECT", message: "닮은꼴을 찾을 사진을 선택해주세요", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
        self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: false, completion: nil)
        }
        else {
            print("Camera Not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            uploadedImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - ImageManagerDelegate

extension ViewController : ImageManagerDelegate {
    
    func didUpdateResembleCeleb(_ data: ImageModel ) {
        celebrityName.text = data.celebrityName
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}



