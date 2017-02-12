//
//  AppScreenViewController.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class AppScreenViewController: UIViewController {
    
    let appScreenView = AppScreenView()
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(appScreenView)
        appScreenView.layoutSubviews()
        appScreenView.loginButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

extension AppScreenViewController {
    
    func mapButtonTapped() {
        navigationController?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        navigationController?.pushViewController(QueryViewController(), animated: true)
    }
    //
    //    func signupButtonTapped() {
    //        navigationController?.pushViewController(SignupViewController(), animated: true)
    //    }
}
