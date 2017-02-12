//
//  QueryView.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class QueryView: UIView {
    
    var questions = Queries()
    
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
    
    var queryViews = [UIView]()

    override func layoutSubviews() {
        super.layoutSubviews()
        frame = UIScreen.main.bounds
        backgroundColor = .white
        self.queryViews = [questionLabel, firstChoiceButton, secondChoiceButton, thirdChoiceButton]
        setupConstraints()
    }
    
    func addSubviewsToView(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.widthAnchor.constraint(equalTo: widthAnchor, constant: self.bounds.width * Constants.Login.loginFieldWidth)
        subview.heightAnchor.constraint(equalTo: heightAnchor, multiplier: self.bounds.height * Constants.Login.loginFieldHeight)
    }
    
    func setupConstraints() {
        queryViews.forEach { view in
            addSubviewsToView(subview: view)
        }
        questionLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        questionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.01).isActive = true
        questionLabel.text = questions.queryOne.questionText
        
        firstChoiceButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        firstChoiceButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.2).isActive = true
        firstChoiceButton.setTitle("Hell yeah", for: .normal)
    }
}
