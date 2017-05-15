//
//  NavigationRoute.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 5/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxGeocoder
import RealmSwift

class Router {
    let directions = Directions(accessToken: Secrets.mapKey)
    var initialLocationAnnotation: MGLAnnotation?
    var tourDestinationAnnotation: MGLAnnotation?
    var startLocation: Annotation?
    var end: Annotation?
    var startCoordinates = CLLocation()
    var tourStops: [MGLAnnotation] = []
    let locationStore = TourDataStore.shared
    let locationService = LocationService.sharedInstance
    var stops: [TourStop] = TourStop.stops
    
    @discardableResult
    func path(completion: @escaping ([Waypoint]?, [Route]?, NSError?) -> Void) -> String {
        addAnnotationsToMap()
        let time: String = ""
        let stops = tourStops
        initialLocationAnnotation = stops[0]
        tourDestinationAnnotation = stops[2]
        guard let startingLocation = initialLocationAnnotation,
            let destination = tourDestinationAnnotation else { return time }
        let tourStopWayPoints = locationStore.setWaypointsFromStops(startingCoordinate: startingLocation, endCoordinate: destination, tourStops:  stops)
        
        let options = RouteOptions(waypoints: tourStopWayPoints, profileIdentifier: MBDirectionsProfileIdentifier.walking)
        options.includesSteps = true
        options.routeShapeResolution = .full
        
        var new = directions.calculate(options) { waypoints, routes, error in
            completion(waypoints, routes, error)
            
            guard error == nil else { print("Error getting directions: \(error!)"); return }
            if let routes = routes , let route = routes.first {
                
            }
        }
        return "TEST"
    }
    
    func setStartPoint(controller: TourMapViewController, mapView: MGLMapView, startPoint: Annotation) {
        if let start = startLocation { mapView.removeAnnotation(start) }
        startLocation = startPoint
        mapView.addAnnotation(startPoint)
        mapView.setCenter(startPoint.coordinate, animated: true)
    }
    
    func setLocation() {
        guard let lastLocation = locationService.lastLocation else { return }
        startCoordinates = lastLocation
    }
    
    
    func createAnnotations(location: CLLocation, locationName: String) -> MGLPointAnnotation {
        let annotation = MGLPointAnnotation()
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = locationName
        return annotation
    }
    
    
    func addAnnotationsToMap() {
        let range = 1...3
        for i in range {
            let stop = stops[i]
            let location = stop.location
            let locationName = location.locationName
            let latitude = location.coordinates.latitude
            let longitude = location.coordinates.longitude
            let newlocation = CLLocation(latitude: latitude, longitude: longitude)
            let tourAnnotation = createAnnotations(location: newlocation, locationName: "\(i). \(locationName)")
            tourStops.append(tourAnnotation)
        }
    }
}
