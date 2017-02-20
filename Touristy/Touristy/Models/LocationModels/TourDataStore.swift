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
import MapboxDirections

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
    
    func setWaypointsFromStops(tourStops: [MGLAnnotation]) -> [Waypoint] {
        var waypoints = [Waypoint]()
        for waypoint in tourStops {
            let waypoint = Waypoint(coordinate: waypoint.coordinate)
            waypoints.append(waypoint)
        }
        return waypoints
    }
    
    func sortWaypoints(origin: MGLAnnotation, waypoints: [Waypoint]) {
        var waypoints = waypoints
        if let origin = initialLocation {
            let current = CLLocation(latitude: origin.coordinate.latitude, longitude: origin.coordinate.longitude)
            waypoints.sort { loc1, loc2 in
                let loc1 = CLLocation(latitude: loc1.coordinate.latitude, longitude: loc1.coordinate.longitude)
                let loc2 = CLLocation(latitude: loc2.coordinate.latitude, longitude: loc2.coordinate.longitude)
                return current.distance(from: loc1) < current.distance(from: loc2)
            }
        }
    }
    
    
    
}