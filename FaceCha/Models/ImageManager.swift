//
//  ImageManager.swift
//  FaceCha
//
//  Created by RooZin on 2021/03/11.
//

import UIKit

protocol ImageManagerDelegate {
    func didUpdateResembleCeleb(_ data : ImageModel)
    func didFailWithError(_ error : Error)
}

struct ImageManager{
    var delegate : ImageManagerDelegate?
    
    let image = UIImage(imageLiteralResourceName: "wj.jpeg")
    let url = URL(string: "https://openapi.naver.com/v1/vision/celebrity")
    
    func postData() {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("oops")
            return
        }
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        let uuid = UUID().uuidString
        let CRLF = "\r\n"
        let fileName = uuid + ".jpg"
        let formName = "image"
        let type = "image/jpeg"     // file type
        let boundary = String(format: "----iOSURLSessionBoundary.%08x%08x", arc4random(), arc4random())
        var body = Data()
        // file data //
        body.append(("--\(boundary)" + CRLF).data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(formName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append(("Content-Type: \(type)" + CRLF + CRLF).data(using: .utf8)!)
        body.append(imageData as Data)
        body.append(CRLF.data(using: .utf8)!)
        // footer //
        body.append(("--\(boundary)--" + CRLF).data(using: .utf8)!)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Rc6NtwiN6gAgbiBcw7Lg", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("Fx2iP3XydR", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        request.httpBody = body
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                delegate?.didFailWithError(error!)
            }
            if let safedata = data{
                DispatchQueue.main.async {
                    if let faceData = self.parseJSON(data: safedata){
                        delegate?.didUpdateResembleCeleb(faceData)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func parseJSON(data : Data) -> ImageModel? {
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(ImageData.self, from: data)
            
            let name = decodedData.faces[0].celebrity.value
            
            let image = ImageModel(celebrityName: name)
            return image
        }
        catch{
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
