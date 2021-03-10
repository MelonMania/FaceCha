//
//  ViewController.swift
//  FaceCha
//
//  Created by RooZin on 2021/03/10.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    
    @IBOutlet weak var uploadedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressSearch(_ sender: UIButton) {
//        let client_id = "Rc6NtwiN6gAgbiBcw7Lg"
//        let client_secret = "Fx2iP3XydR"
//        let url = URL(string: "https://openapi.naver.com/v1/vision/celebrity")
//
//        var request = URLRequest(url: url!)
//        //request.httpBody = imageWJ
//        request.httpMethod = "POST"
//        request.addValue("multipart/form-data; boundary=\(boundary)}", forHTTPHeaderField: "Content-Type")
//        request.addValue(client_id, forHTTPHeaderField: "X-Naver-Client-Id")
//        request.addValue(client_secret, forHTTPHeaderField: "X-Naver-Client-Secret")
        let apiUrl: URL = URL(string: UserDefaults.standard.getApiURL() + "/api/test")!

        let headers = [
            "client_id" : "Rc6NtwiN6gAgbiBcw7Lg",
            "client_secret" : "Fx2iP3XydR",
            "Content-Type" : "multipart/form-data; boundary=\(boundary)" //application/json, multipart/form-data
        ]

        let escapeContents = self.contents.text.replacingOccurrences(of: "\n", with: "\\n")

        let params: Parameters = [
            "jsonData": "{\"contentData\": {\"text\": \"\(escapeContents)\", \"mentions\": [\(mentionsUser)]},\"feedType\": \"NORMAL\"}"
        ]

        let imageData = UIImageJPEGRepresentation(self.pickImageV.image!, 1.0)

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "file", fileName: "wj.jpeg", mimeType: "image/jpeg")
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: apiUrl, method: .post, headers: headers) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    let json = JSON(response.result.value!)
                    //이후 json 데이터를 처리
                })
            case .failure(let error):
                print(error)
                Toast.long(message: "Network communication is no working.", isWarning: true)
            }//end switch
        }
    }
    
    
    
    
}



