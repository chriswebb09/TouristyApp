//
//  MGLMapView+Extension.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Mapbox

extension MGLMapView {
    func addAnotationToMapView(annotation: MGLPointAnnotation) {
        addAnnotation(annotation)
        selectAnnotation(annotation, animated: true)
    }
}
