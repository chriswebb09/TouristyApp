//
//  CLLocation+Extension.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import CoreLocation

extension CLLocation {
    static func midpointCoordinates(origin: CLLocation, destination: CLLocation) -> CLLocation {
        let centerLatitidue = (origin.coordinate.latitude + destination.coordinate.latitude) / 2
        let centerLongitude = (origin.coordinate.longitude + destination.coordinate.longitude) / 2
        return CLLocation(latitude: centerLatitidue, longitude: centerLongitude)
    }
    
    static func getClosestDestination(locations: [CLLocation]) -> CLLocation {
        var totalLat = 0.0
        var totalLong = 0.0
        let numberOfLocations = Double(locations.count)
        locations.forEach { location in
            totalLat = totalLat + location.coordinate.latitude
            totalLong = totalLong + location.coordinate.longitude
        }
        return CLLocation(latitude: totalLat/numberOfLocations, longitude: totalLong/numberOfLocations)
    }
}
