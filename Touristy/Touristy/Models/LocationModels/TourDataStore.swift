//
//  TourDataStore.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/20/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox

class TourDataStore {
    
    static let shared = TourDataStore()
    
    var initialLocation: CLLocation?
    var tourDestination: CLLocation?
    
    func setLocations(initialLocation: CLLocation, tourDestination: CLLocation) {
        self.initialLocation = initialLocation
        self.tourDestination = tourDestination
    }
    
    var totalDistance: Double {
        let distance: Double = (initialLocation != nil) && (tourDestination != nil) ? initialLocation!.distance(from: tourDestination!) : 0
        return distance
    }
    
    var searchRadius: Double {
        return totalDistance/2
    }
    
}
