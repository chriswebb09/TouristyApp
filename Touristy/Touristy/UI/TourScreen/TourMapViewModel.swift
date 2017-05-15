//
//  TourMapViewModel.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/22/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Mapbox
import SnapKit
import MapboxDirections
import MapboxGeocoder

struct TourMapViewModel {
    
    var lineCreator = LineCreator()
    var showAnnotation: Bool = true
    var geocoder = Geocoder(accessToken: Secrets.mapKey)
    let directions = Directions(accessToken: Secrets.mapKey)
    var router = Router()
    
    func setLocation(controller: TourMapViewController) {
        guard let lastLocation = controller.locationService.lastLocation else { return }
        controller.startCoordinates = lastLocation
    }
    
    func setCenterCoordinateOnMapView(controller: TourMapViewController) {
        let longitude = controller.startCoordinates.coordinate.longitude
        let latitude = controller.startCoordinates.coordinate.latitude
        let downtownManhattan = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        controller.mapView.setCenter(downtownManhattan, zoomLevel: 15, direction: 25.0, animated: false)
    }
    
    func tapCalloutAcessory(controller: TourMapViewController, annotation: MGLAnnotation) {
        controller.mapView.deselectAnnotation(annotation, animated: false)
        guard let selectedAnnotation = annotation as? Annotation else { return }
        
        if controller.createMode && controller.currentStage == .waypoints {
            
            if containsWaypoint(tourPoints: controller.tourPoints, waypoint: selectedAnnotation) {
                if let index = controller.tourPoints.index(where: { $0.title! == selectedAnnotation.title! }) {
                    controller.tourPoints.remove(at: index)
                }
                selectedAnnotation.type = .tourStop
                controller.POI.append(selectedAnnotation)
                let annotationView = controller.mapView.view(for: annotation)
                annotationView?.backgroundColor = selectedAnnotation.annotationColor
            } else {
                if let index = controller.POI.index(of: selectedAnnotation) { controller.POI.remove(at: index) }
                selectedAnnotation.type = .tourStop
                controller.tourPoints.append(selectedAnnotation)
                let annotationView = controller.mapView.view(for: annotation)
                annotationView?.backgroundColor = selectedAnnotation.annotationColor
            }
        }
    }
    
    func setupMapViewUI(controller: TourMapViewController) {
        controller.view.addSubview(controller.mapView)
        controller.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.mapView.translatesAutoresizingMaskIntoConstraints = false
        controller.mapView.snp.makeConstraints { make in
            make.left.equalTo(controller.view.snp.left)
            make.right.equalTo(controller.view.snp.right)
            make.bottom.equalTo(controller.view.snp.bottom)
            make.top.equalTo(controller.view.snp.top)
        }
        controller.mapView.tintColor = .gray
    }
    
    func containsWaypoint(tourPoints: [Annotation], waypoint: Annotation) -> Bool {
        if tourPoints.contains(where: { $0.title! == waypoint.title! }) { return true }
        return false
    }
    
    func setToWaypoints(controller: TourMapViewController) {
        controller.createMode = true
        controller.currentStage = .waypoints
    }
    
    func removeWaypoints(controller: TourMapViewController) {
        controller.tourStops.removeAll()
    }
    
    func removeUnusedWaypoints(controller: TourMapViewController) {
        controller.POI.removeAll()
    }
    
    func setupMapView(controller: TourMapViewController) {
        let styleURL = URL(string: Secrets.mapStyle)
        controller.mapView  = MGLMapView(frame: controller.view.bounds, styleURL: styleURL)
        setupMapViewUI(controller: controller)
        
        let location = controller.stops[0].location
        let locationName = location.locationName
        let annotationLocation = location.location
        
        controller.tourDestinationAnnotation = createAnnotations(controller: controller,
                                                                 location: annotationLocation,
                                                                 locationName: locationName)
        controller.mapView.delegate = controller
        controller.mapView.userTrackingMode = .follow
    }
    
    func removePath(controller: TourMapViewController) {
        if let path = controller.tourPath {
            controller.mapView.removeAnnotation(path)
        }
        controller.tourPath = nil
    }
    
    func containsWaypoint(controller: TourMapViewController, waypoint: Annotation) -> Bool {
        if controller.POI.contains(where: { $0.title! == waypoint.title! }) { return true }
        return false
    }
    
    func path(controller: TourMapViewController) -> String {
        var time: String = ""
        let stops = controller.tourStops
        let locationStore = controller.locationStore
        guard let startingLocation = controller.initialLocationAnnotation, let destination = controller.tourDestinationAnnotation else { return time }
        let tourStopWayPoints = locationStore.setWaypointsFromStops(startingCoordinate: startingLocation, endCoordinate: destination, tourStops:  stops)
        
        let options = RouteOptions(waypoints: tourStopWayPoints, profileIdentifier: MBDirectionsProfileIdentifier.walking)
        options.includesSteps = true
        options.routeShapeResolution = .full
        
        router.path { waypoints, routes, error in
            guard error == nil else { print("Error getting directions: \(error!)"); return }
            if let routes = routes , let route = routes.first {
                if route.coordinateCount > 0 {
                    var routeCoordinates = route.coordinates!
                    controller.tourPath = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    if let routeLine = controller.tourPath {
                        let mapView = controller.mapView
                        mapView?.addAnnotation(routeLine)
                        mapView?.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: UIEdgeInsets.zero, animated: true)
                    }
                }
                time = String.getTravelTimeFromInterval(interval: route.expectedTravelTime)!
              
            }
            
        }
        return time
    }
    
    func viewForAnnotation(controller: TourMapViewController, annotation: MGLAnnotation) -> MGLAnnotationView? {
        let reuseIdentifier = "\(annotation.title)"
        var annotationView = controller.mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = TourSpotAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        }
        annotationView?.backgroundColor = .white
        return annotationView
    }
    
    func getDestination(controller: TourMapViewController, destinationPoint: Annotation) {
        if let destination = controller.end {
            controller.mapView.removeAnnotation(destination)
        }
        controller.end = destinationPoint
        controller.mapView.addAnnotation(destinationPoint)
        controller.mapView.setCenter(destinationPoint.coordinate, animated: true)
    }
    
    func addAnnotation(controller: TourMapViewController) {
        let centerAnnotation = createAnnotations(controller: controller, location: controller.startCoordinates, locationName: "Begin")
        controller.initialLocationAnnotation = centerAnnotation
        addAnnotationsToMap(controller: controller)
        setCenterCoordinateOnMapView(controller: controller)
    }
    
    func createAnnotations(controller: TourMapViewController, location: CLLocation, locationName: String) -> MGLPointAnnotation {
        let annotation = router.createAnnotations(location: location, locationName: locationName)
        addAnotationToMapView(annotation: annotation, mapView: controller.mapView)
        return annotation
    }
    
    func addAnotationToMapView(annotation: MGLPointAnnotation, mapView: MGLMapView) {
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func coordinatesEqual(location: CLLocationCoordinate2D, other: CLLocationCoordinate2D) -> Bool {
        return location.latitude == other.latitude && location.longitude == other.longitude
    }
    
    func addAnnotationsToMap(controller: TourMapViewController) {
        let range = 1...3
        for i in range {
            let stop = controller.stops[i]
            let location = stop.location
            let locationName = location.locationName
            let latitude = location.coordinates.latitude
            let longitude = location.coordinates.longitude
            let newlocation = CLLocation(latitude: latitude, longitude: longitude)
            let tourAnnotation = createAnnotations(controller: controller, location: newlocation, locationName: "\(i). \(locationName)")
            controller.tourStops.append(tourAnnotation)
        }
        controller.createPath() { time in
            print(time)
        }
    }
}
