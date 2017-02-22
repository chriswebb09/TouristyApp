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
