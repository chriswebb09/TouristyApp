//
//  LineCreator.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol LineMakerProtocol {
    var lineWidth: CGFloat { get set }
    var lineColor: UIColor { get set }
}

class LineCreator: LineMakerProtocol {
    var lineColor: UIColor = .darkGray
    
    var lineWidth: CGFloat = 2
}
