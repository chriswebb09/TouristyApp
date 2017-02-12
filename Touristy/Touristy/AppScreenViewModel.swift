import UIKit

struct AppScreenViewModel {
    
    var signupButtonColor: UIColor = {
        return Constants.Color.backgroundColor
    }()
    
    var signupButtonText: String = {
        return "Register Now"
    }()
    
    var viewDividerBackgroundColor: UIColor = {
        return UIColor.lightGray
    }()
}

