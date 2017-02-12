//
//  QueryView.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class QueryView: UIView {
    
    var questionLabel: UILabel = {
        var questionLabel = UILabel()
        return questionLabel
    }()
    
    var firstChoiceButton: UIButton = {
        var firstButton = UIButton()
        return firstButton
    }()
    
    var secondChoiceButton: UIButton = {
        var secondChoiceButton = UIButton()
        return secondChoiceButton
    }()
    
    var thirdChoiceButton: UIButton = {
        var thirdChoiceButton = UIButton()
        return thirdChoiceButton
    }()
    
    var views = [UIView]()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.views = [questionLabel, firstChoiceButton, secondChoiceButton, thirdChoiceButton]
        setupConstraints()
    }
    
    func addSubviewsToView(subview: UIView) {
        addSubviewsToView(subview: subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.widthAnchor.constraint(equalTo: widthAnchor, constant: self.bounds.width * Constants.Login.loginFieldWidth)
        subview.heightAnchor.constraint(equalTo: heightAnchor, multiplier: self.bounds.height * Constants.Login.loginFieldHeight)
    }
    
    func setupConstraints() {
        views.forEach { view in
            addSubviewsToView(subview: view)
        }
    }
}
