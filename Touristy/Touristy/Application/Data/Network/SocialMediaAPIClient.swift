//
//  SocialMediaAPIClient.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/20/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

struct SocialMediaAPIClient {
    
    func getFourSquareData(params: [String: String], handler: @escaping (JSON?) -> ()) {
        Alamofire.request(URL(string:"https://www.google.com")!, method: .get, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { response in
            guard let data = response.data, let responseJSON = JSON(data:data).dictionary?["response"] else {
                handler(nil)
                return
            }
            handler(responseJSON)
        }
    }
}

