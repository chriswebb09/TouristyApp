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


class TourMapViewController: UIViewController {
    
    let tourManager = TourDataStore.shared
    
    @IBOutlet var mapView: MGLMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var userStartLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        setupAnnotation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let locValue:CLLocationCoordinate2D = location.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
        }
    }
    
    func setupAnnotation() {
        var tourStop = MGLPointAnnotation()
        let centralPark = Location(streetAddress: "Central ParK", distanceTo: "0", locationName: "Central Park" , coordinates: CLLocationCoordinate2D(latitude: 40.782865, longitude: -73.965355))
        tourStop.coordinate = centralPark.coordinates
        tourStop.title = centralPark.locationName
        mapView.addAnnotation(tourStop)
        setLocation()
    }
    
    private func setLocation() {
        if let location = initializerLocationToUser() {
            userStartLocation = location
        }
    }
}

extension TourMapViewController: CLLocationManagerDelegate {
    
    func initializerLocationToUser() -> CLLocation? {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        let userAuth = (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        if userAuth { return locationManager.location } else { return nil }
    }
}

extension TourMapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else { return nil }
        let reuseIdentifier = String(annotation.coordinate.longitude)
        return mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as! MGLAnnotationView?
    }
}
