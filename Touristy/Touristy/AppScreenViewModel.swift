//
//  AppScreenViewModel.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

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

