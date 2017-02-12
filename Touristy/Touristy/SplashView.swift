//
//  SplashView.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import SnapKit

typealias completion = () -> Void

class SplashView: UIView {
    
    var animationDuration: Double = 0.8
    let splashViewModel = SplashViewModel(splashImage: UIImage(), animationDuration: 20)
    
    var splashImageView: UIImageView {
        let splashView = UIImageView(image: UIImage())
        return splashView
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(splashImageView)
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        splashImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        splashImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        splashImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        splashImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

extension SplashView {
    
    func zoomAnimation(_ handler: completion? = nil) {
        let duration: TimeInterval = animationDuration * 0.5
        UIView.animate(withDuration: duration, animations:{ [weak self] in
            if let zoom = self?.zoomOut() {
                self?.splashImageView.transform = zoom
            }
            self?.alpha = 0
            }, completion: { finished in
                DispatchQueue.main.async {
                    let appScreenVC = UINavigationController(rootViewController:HomeViewController())
                    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.window?.rootViewController = appScreenVC
                }
                handler?()
        })
    }
    
    fileprivate func zoomOut() -> CGAffineTransform {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 05, y: 05)
        return zoomOutTranform
    }
}
