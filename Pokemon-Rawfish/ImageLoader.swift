//
//  ImageLoader.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/25/21.
//

import UIKit

typealias imageResponse = ((Result<UIImage, Error>) -> ())
class ImageLoader {
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func loadImage(url: URL, completion: imageResponse?)  {
        
        let dataTask = urlSession.dataTask(with: url) {[weak self] (data, urlResponse, error) in
            
            guard let self = self else {return}
           
            let result = self.handleDataResponse(data: data, urlResponse: urlResponse, error: error)
            DispatchQueue.main.async {
                completion?(result)
            }
            
        }
        dataTask.resume()
    }
    
    func handleDataResponse(data: Data?, urlResponse: URLResponse?, error: Error?) -> Result<UIImage, Error> {
       
        if let data = data, let image = UIImage(data: data) {
            
            return .success(image)
        }
        else if let error = error{
            return .failure(error)
        }
        return .failure(ImageLoaderError.imageNotDecoded)
    
    }
    
}

enum ImageLoaderError: Error {
    case unknown
    case imageNotDecoded
    
}
