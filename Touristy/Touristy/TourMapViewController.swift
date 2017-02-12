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
        setupMapView()
        view.backgroundColor = .white
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
    
    private func setupMapView() {
        let styleURL = NSURL(string: "mapbox://styles/chriswebb/ciz2oxgoh002s2sprtfmaeo5m")
        mapView  = MGLMapView(frame: view.bounds,
                              styleURL: styleURL as URL?)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func addAnnotation() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.706697302800182, longitude: -74.014699650804047)
        annotation.title = "New York City"
        // annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
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
    
    private func setCenterCoordinateOnMapView() {
        let lat: CLLocationDegrees = 40.706697302800182
        let lng: CLLocationDegrees = -74.014699650804047
        let downtownManhattan = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapView.setCenter(downtownManhattan, zoomLevel: 15, direction: 25.0, animated: false)
    }
    
    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 200, pitch: 60, heading: 0)
        mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        mapView.resetNorth()
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

