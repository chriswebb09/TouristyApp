import UIKit
import CoreLocation

struct DataDefaults {
    
    let defaults = UserDefaults.standard
    
    func hasLoggedIn() {
        let hasLoggedIn = defaults.bool(forKey: "hasLoggedIn")
        let user = defaults.data(forKey: "currentUser")
        if hasLoggedIn {
            print(defaults.description)
            print(defaults.value(forKey: "hasLoggedIn").debugDescription)
        }
    }
}


