//
//  SearchManager.swift
//  FaceCha
//
//  Created by RooZin on 2021/03/14.
//
protocol SearchManagerDelegate {
    func loadCelebPicture(_ searchData : SearchModel)
    func printLoadError(_ error : Error)
}

import UIKit

struct SearchManager {
    
    var delegate : SearchManagerDelegate?
    var baseURL = "https://openapi.naver.com/v1/search/image"
    
    func fetchURL(_ name : String) {
        
        let url = "\(baseURL)?query=\(name)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    
        requestGet(encodedURL)
    }
 
    func requestGet(_ url : String) {
        let url = URL(string: url)

        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.addValue("Rc6NtwiN6gAgbiBcw7Lg", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("Fx2iP3XydR", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                delegate?.printLoadError(error!)
            }
            if let safeData = data {
                DispatchQueue.main.async {
                    if let searchData = self.parseJSON(data: safeData) {
                        delegate?.loadCelebPicture(searchData)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func parseJSON(data : Data) -> SearchModel? {
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(SearchData.self, from: data)
            
            let imageLink = decodedData.items[0].link
            
            let link = SearchModel(imageLink: imageLink)
            return link
        }
        catch{
            delegate?.printLoadError(error)
            return nil
        }
    }
    
}
