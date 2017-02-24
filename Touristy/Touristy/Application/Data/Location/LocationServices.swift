//
//  LocationServices.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/24/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    private static let _shared = LocationService()
    
    public static var sharedInstance: LocationService{ return _shared }
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    
    private override init() {
        super.init()
        self.locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
            print("No access")
            locationManager.stopUpdatingLocation()
            //locationManager.stopMonitoringSignificantLocationChanges()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            lastLocation = locationManager.location
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    func updateLocation(currentLocation: CLLocation) {
        guard let delegate = delegate else { return }
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    func updateLocationDidFailWithError(error: NSError) {
        guard let delegate = delegate else { return }
        delegate.tracingLocationDidFailWithError(error: error)
    }
}
