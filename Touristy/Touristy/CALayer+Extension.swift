//
//  CALayer+Extension.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// MARK: - Center Point to CALayer
extension CALayer {
    
    var center: CGPoint {
        get {
            return CGPoint(x: self.frame.midX, y: self.frame.midY)
        }
        set {
            self.frame.origin.x = newValue.x - (self.frame.size.width / 2)
            self.frame.origin.y = newValue.y - (self.frame.size.height / 2)
        }
    }
    
    var width: CGFloat {
        return self.bounds.width
    }
    
    var height: CGFloat {
        return self.bounds.height
    }
    
    var origin: CGPoint {
        return CGPoint(x: self.center.x - (self.width / 2), y: self.center.y - (self.height / 2))
    }
    
}

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
        fadeOut.duration = duration
        fadeOut.autoreverses = false
        fadeOut.fromValue = 1.0
        fadeOut.toValue = 0.6
        fadeOut.fillMode = kCAFillModeBoth
        fadeOut.isRemovedOnCompletion = false
        self.add(fadeOut, forKey: "myanimation")
    }
    
}
