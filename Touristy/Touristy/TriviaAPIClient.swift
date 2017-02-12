//
//  TriviaAPIClient.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias JSONData = [String:Any]

struct APIClient {
    
    let session = URLSession.shared
    
    func createRequest(url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
    
    func startTask(request: URLRequest, handler: @escaping (JSONData) -> ()) {
        session.dataTask(with: request, completionHandler: { data, response, error in
            guard let responseData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! JSONData
                handler(json)
            } catch {
                print(error.localizedDescription)
            }
        }).resume()
    }
    
    func downloadImage(request: URLRequest, handler: @escaping (UIImage) -> ()) {
        session.dataTask(with: request, completionHandler: { data, response, error in
            guard let responseData = data else { return }
            let image = UIImage(data: responseData)!
            handler(image)
        })
    }
}
