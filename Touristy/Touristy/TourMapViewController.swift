//
//  TourMapViewController.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import MapboxGeocoder

let MapboxAccessToken = Secrets.mapKey


class TourMapViewController: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var userStartLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        addAnnotation()
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let locValue:CLLocationCoordinate2D = location.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
        }
    }
    
    func addAnnotation() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 35.03946, longitude: 135.72956)
        annotation.title = "Kinkaku-ji"
        annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, zoomLevel: 17, animated: false)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else { return nil }
        let reuseIdentifier = String(annotation.coordinate.longitude)
        return mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as! MGLAnnotationView?
    }
    
    func setupAnnotation() {
        var tourStop = MGLPointAnnotation()
        let centralPark = Location(streetAddress: "Central ParK",
                                   distanceTo: "0",
                                   locationName: "Central Park" ,
                                   coordinates: CLLocationCoordinate2D(latitude: 40.782865,
                                                                       longitude: -73.965355))
        tourStop.coordinate = centralPark.coordinates
        tourStop.title = centralPark.locationName
        mapView.addAnnotation(tourStop)
        setLocation()
    }
    
    private func setLocation() {
        if let location = initializeLocationToUser() {
            userStartLocation = location
        }
    }
}

extension TourMapViewController: CLLocationManagerDelegate {
    
    func initializeLocationToUser() -> CLLocation? {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            return locationManager.location
        case .authorizedAlways:
            return locationManager.location
        case .denied:
            return nil
        case .notDetermined:
            return nil
        case .restricted:
            return nil
        }
    }
}

