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
        setupMapViewUI(controller: controller)
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
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                       longitude: location.coordinate.longitude)
        annotation.title = locationName
        controller.mapView.addAnnotation(annotation)
        controller.mapView.selectAnnotation(annotation, animated: true)
        return annotation
    }
    
    func coordinatesEqual(location: CLLocationCoordinate2D, other: CLLocationCoordinate2D) -> Bool {
        return location.latitude == other.latitude && location.longitude == other.longitude
    }
    
    func getTravelTimeFromInterval(interval: TimeInterval) -> String? {
        let travelTimeFormatter = DateComponentsFormatter()
        travelTimeFormatter.unitsStyle = .short
        let formattedTravelTime = travelTimeFormatter.string(from: interval)
        return formattedTravelTime
    }
    
    func addAnnotationsToMap(controller: TourMapViewController) {
        var newTourStops = [TourStop]()
        for i in 1...3 {
            let location = CLLocation(latitude: controller.stops[i].location.coordinates.latitude, longitude: controller.stops[i].location.coordinates.longitude)
            let tourAnnotation = createAnnotations(controller: controller, location: location, locationName: "\(i). \(controller.stops[i].location.locationName)")
            newTourStops.append(controller.stops[i])
            controller.tourStops.append(tourAnnotation)
        }
        
        print(controller.locationStore.getClosestDestination(locations: newTourStops))
        controller.createPath() { time in
            print(time)
        }
    }
}
