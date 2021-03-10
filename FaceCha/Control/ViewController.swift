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
    
    var imageManager = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageManager.delegate = self
        uploadedImage.image = UIImage(named: "wj.jpeg")
    }
    
    @IBAction func pressSearch(_ sender: UIButton) {
        imageManager.postData()
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



