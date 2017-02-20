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

