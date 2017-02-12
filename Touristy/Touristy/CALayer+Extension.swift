//
//  CALayer+Extension.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension CALayer {
    
    func springToMiddle(withDuration duration: CFTimeInterval, damping: CGFloat, inView view: UIView) {
        let springX = CASpringAnimation(keyPath: "position.x")
        springX.damping = damping
        springX.fromValue = self.position.x
        springX.toValue = view.frame.midX
        springX.duration = duration
        self.add(springX, forKey: nil)
        
        let springY = CASpringAnimation(keyPath: "position.y")
        springY.damping = damping
        springY.fromValue = self.position.y
        springY.toValue = view.frame.midY
        springY.duration = duration
        self.add(springY, forKey: nil)
    }
    
    func centerInView(view: UIView) {
        self.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
    }
    
    func fadeOutWithDuration(duration: CFTimeInterval) {
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        //fadeOut.delegate = self
        fadeOut.duration = duration
        fadeOut.autoreverses = false
        fadeOut.fromValue = 1.0
        fadeOut.toValue = 0.6
        fadeOut.fillMode = kCAFillModeBoth
        fadeOut.isRemovedOnCompletion = false
        self.add(fadeOut, forKey: "myanimation")
    }
    
}
