import UIKit
import SnapKit
import CoreLocation
import Mapbox
import MapboxGeocoder

let MapboxAccessToken = Secrets.mapKey

final class TourMapViewController: UIViewController {
    
    var mapView: MGLMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var startCoordinates = CLLocation()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupMapView()
        
        if let location = initializeLocationToUser()  { self.startCoordinates = location }
        
        view.backgroundColor = .white
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        addAnnotation()
    }
}

extension TourMapViewController: MGLMapViewDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            self.startCoordinates = location
        }
    }
    
    fileprivate func setupMapView() {
        let styleURL = NSURL(string: "mapbox://styles/chriswebb/ciz2oxgoh002s2sprtfmaeo5m")
        mapView  = MGLMapView(frame: view.bounds,
                              styleURL: styleURL as URL?)
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
        }
        mapView.tintColor = .gray
    }
    
    func addAnnotation() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: startCoordinates.coordinate.latitude, longitude: startCoordinates.coordinate.longitude)
        annotation.title = "New York City"
        
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
        var anotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if anotationView == nil {
            anotationView = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
            anotationView?.frame = CGRect(x:0, y:0, width:100, height:100)
            let imageView = UIImageView(image: UIImage(named:"Test"))
        }
        return anotationView
       // return mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as! MGLAnnotationView?
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
           startCoordinates = location
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
    
    func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        print("Here we are")
    }
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        // implement
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
//    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
//        // Wait for the map to load before initiating the first camera movement.
//        
//        // Create a camera that rotates around the same center point, rotating 180°.
//        // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
//        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 200, pitch: 60, heading: 180)
//        
//        // Animate the camera movement over 5 seconds.
//        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
//    }
}

extension TourMapViewController: CLLocationManagerDelegate {
    
    func initializeLocationToUser() -> CLLocation? {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            return locationManager.location
            
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
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

