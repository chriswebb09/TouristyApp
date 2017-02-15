//
//  UserLocationData.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import CoreLocation


struct UserLocationData {
    
    var origin: CLLocation
    var destination: CLLocation
    
    init(origin: CLLocation, destination: CLLocation) {
        self.origin = origin
        self.destination = destination
    }
    
    var totalDistance: Double {
        return origin.distance(from: destination)
    }
    
    var searchRadius: Double {
        return totalDistance/2
    }
    
    func midpointCoordinates() -> CLLocation {
        let centerLatitidue = (origin.coordinate.latitude + destination.coordinate.latitude) / 2
        let centerLongitude = (origin.coordinate.longitude + destination.coordinate.longitude) / 2
        return CLLocation(latitude: centerLatitidue, longitude: centerLongitude)
    }
    
}
