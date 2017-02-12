//
//  HomeView.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    var logoImageView: UIImageView {
        let logoView = UIImageView()
        return logoView
    }
    
    var newTourButton: UIButton {
        let tourButton = UIButton()
        return tourButton
    }
    
    var signInButton: UIButton {
        let signInButton = UIButton()
        return signInButton
    }
    
    var views = [UIView]()
    
    override func layoutSubviews() {
        self.views = [logoImageView, newTourButton, signInButton]
    }
}
