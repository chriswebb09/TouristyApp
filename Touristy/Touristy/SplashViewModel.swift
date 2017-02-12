//
//  SplashViewModel.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

struct SplashViewModel {
    
    var splashImage: UIImage
    var animationDuration: Double
    
    init(splashImage: UIImage, animationDuration: Double) {
        self.splashImage = splashImage
        self.animationDuration = animationDuration
    }
    
    
}
