//
//  TourMapViewModel.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/22/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Mapbox

struct TourMapViewModel {
    var lineWidth: CGFloat = 2
    var lineColor: UIColor = UIColor.darkGray
    
    func setStartPoint(controller: TourMapViewController, mapView: MGLMapView, startPoint: Annotation) {
        if let start = controller.startLocation {
            mapView.removeAnnotation(start)
        }
        controller.startLocation = startPoint
        mapView.addAnnotation(startPoint)
        mapView.setCenter(startPoint.coordinate, animated: true)
    }
    
    func setLocation(controller: TourMapViewController) {
        if let location = controller.initializeLocationToUser() {
            controller.startCoordinates = location
        }
    }
    
    func setCenterCoordinateOnMapView(controller: TourMapViewController) {
        let downtownManhattan = CLLocationCoordinate2D(latitude: controller.startCoordinates.coordinate.latitude,
                                                       longitude: controller.startCoordinates.coordinate.longitude)
        controller.mapView.setCenter(downtownManhattan, zoomLevel: 15, direction: 25.0, animated: false)
    }
    
    func containsWaypoint(tourPoints: [Annotation], waypoint: Annotation) -> Bool {
        if tourPoints.contains(where: { $0.title! == waypoint.title! }) {
            return true
        }
        
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
        controller.setupMapViewUI()
        controller.tourDestinationAnnotation = createAnnotations(controller: controller, location: controller.stops[0].location.location,
                                                                locationName: controller.stops[0].location.locationName)
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
        if controller.POI.contains(where: { $0.title! == waypoint.title! }) {
            return true
        }
        return false
    }
    
    func addAnnotation(controller: TourMapViewController) {
        let centerAnnotation = createAnnotations(controller: controller, location: controller.startCoordinates, locationName: "Begin")
        controller.initialLocationAnnotation = centerAnnotation
        controller.addAnnotationsToMap()
        setCenterCoordinateOnMapView(controller: controller)
    }
    
    func createAnnotations(controller: TourMapViewController, location: CLLocation, locationName: String) -> MGLPointAnnotation {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                       longitude: location.coordinate.longitude)
        annotation.title = locationName
        controller.mapView.addAnnotation(annotation)
        controller.mapView.selectAnnotation(annotation, animated: true)
        return annotation
    }
    
}
