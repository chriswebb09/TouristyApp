//
//  TourAnnotation.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/20/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Mapbox

class Annotation: MGLPointAnnotation {
    
    enum AnnotationType {
        case origin, POI, tourStop, error
    }
    
    var type: AnnotationType
    
    init(typeSelected: AnnotationType) {
        self.type = typeSelected
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = .tourStop
        fatalError("init(coder:) has not been implemented")
    }
    
    var annotationColor: UIColor {
        switch type {
        case .origin:
            return UIColor.purple
        case .tourStop:
            return UIColor.red
        case .POI:
            return UIColor.blue
        default:
            return UIColor.lightGray
        }
    }
}
