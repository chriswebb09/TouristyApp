import UIKit
import CoreLocation

extension UserDefaults {
    var firstLogin: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}

struct DataDefaults {
    
    let defaults = UserDefaults.standard
    
    func hasLoggedIn() {
        let hasLoggedIn = defaults.bool(forKey: "hasLoggedIn")
        if hasLoggedIn {
            print(defaults.description)
            print(defaults.value(forKey: "hasLoggedIn").debugDescription)
        }
    }
}


