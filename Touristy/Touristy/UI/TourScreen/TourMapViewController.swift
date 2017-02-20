import UIKit
import SnapKit
import CoreLocation
import Mapbox
import MapboxGeocoder
import MapboxDirections


let MapboxAccessToken = Secrets.mapKey

final class TourMapViewController: UIViewController {
    
    var mapView: MGLMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var startCoordinates = CLLocation()
    var initialLocation: MGLAnnotation?
    var tourDestination: MGLAnnotation?
    var tourPath: MGLPolyline?
    var navigationRoutes: [Route] = []
    var navigationLegs: [RouteLeg] = []
    var POI: [Annotation] = []
    var tourStops: [Annotation] = []
    var stops = TourStop.stops
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        var geocoder = Geocoder(accessToken: Secrets.mapKey)
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
    
    fileprivate func setupMapView() {
        let styleURL = NSURL(string: Secrets.mapStyle)
        mapView  = MGLMapView(frame: view.bounds,
                              styleURL: styleURL as URL?)
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tourDestination = addAnnotations(location: stops[0].location.location, locationName: stops[0].location.locationName)
        mapView.delegate = self
        mapView.userTrackingMode = .follow
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
        var centerAnnotation = addAnnotations(location: startCoordinates, locationName: "Begin")
        initialLocation = centerAnnotation
        mapView.setCenter(centerAnnotation.coordinate, zoomLevel: 17, animated: false)
        mapView.selectAnnotation(centerAnnotation, animated: true)
        setupAnnotation()
    }
    
    func setupAnnotation() {
        let stops = TourStop.stops
        for stop in stops {
            let location = CLLocation(latitude: stop.location.coordinates.latitude, longitude: stop.location.coordinates.longitude)
            var centerAnnotation = addAnnotations(location: location, locationName: stop.location.locationName)
        }
        setLocation()
        createPath(completion: { time in
            print(time)
        })
    }
    
    func addAnnotations(location: CLLocation, locationName: String) -> MGLPointAnnotation {
       
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)
        annotation.title = locationName
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        return annotation
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return UIColor.black
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 4
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
    }
    
    private func setLocation() {
        if let location = initializeLocationToUser() {
            startCoordinates = location
        }
    }
    
    private func setCenterCoordinateOnMapView() {
        let downtownManhattan = CLLocationCoordinate2D(latitude: startCoordinates.coordinate.latitude, longitude: startCoordinates.coordinate.longitude)
        mapView.setCenter(downtownManhattan, zoomLevel: 15, direction: 25.0, animated: false)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
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
    
    func createPath(completion: @escaping (_ time: String) -> ()) {
        var tourStops: [Waypoint] = []
        
        for waypoint in self.tourStops {
            let waypoint = Waypoint(coordinate: waypoint.coordinate)
            tourStops.append(waypoint)
        }
        
        //  sortWaypoints(tourStops)
        
        guard let startingLocation = initialLocation, let destination = tourDestination else {
            return
        }
        
        let originWaypoint = Waypoint(coordinate: startingLocation.coordinate)
        let destinationWaypoint = Waypoint(coordinate: destination.coordinate)

        tourStops.insert(originWaypoint, at: 0)
        tourStops.append(destinationWaypoint)
        let directions = Directions(accessToken: Secrets.mapKey)
        let options = RouteOptions(waypoints: tourStops, profileIdentifier: MBDirectionsProfileIdentifierWalking)
        options.includesSteps = true
        options.routeShapeResolution = .full
        directions.calculate(options, completionHandler: { waypoints, routes, error in
            guard error == nil else {
                print("Error getting directions: \(error!)")
                return
            }
            
            if let routes = routes {
                self.navigationRoutes = routes
            }
            
            if let route = routes?.first {
                self.navigationLegs = route.legs
                let travelTimeFormatter = DateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .short
                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
                completion(formattedTravelTime!)
                
                // TODO: Remove testing data stuff
                // Call this function when user saves path
                
                
                if route.coordinateCount > 0 {
                    var routeCoordinates = route.coordinates!
                    self.tourPath = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    
                    if let routeLine = self.tourPath {
                        self.mapView.addAnnotation(routeLine)
                        self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: UIEdgeInsets.zero, animated: true)
                    }
                }
            }
        })
    }
}

extension TourMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            self.startCoordinates = location
        }
    }
    
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

