import UIKit
import SnapKit
import CoreLocation
import Mapbox
import MapboxGeocoder
import MapboxDirections


let MapboxAccessToken = Secrets.mapKey

final class TourMapViewController: UIViewController {
    
    let locationStore = TourDataStore.shared
    var geocoder = Geocoder(accessToken: Secrets.mapKey)
    var mapView: MGLMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var startCoordinates = CLLocation()
    var initialLocation: MGLAnnotation?
    var tourDestination: MGLAnnotation?
    var tourPath: MGLPolyline?
    var navRoutes: [Route] = []
    var navLegs: [RouteLeg] = []
    var POI: [Annotation] = []
    var tourStops: [MGLAnnotation] = []
    var stops = TourStop.stops
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        
        view.backgroundColor = .white
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setLocation()
        setupMapView()
        addAnnotation()
    }
    
    private func setLocation() {
        if let location = initializeLocationToUser() {
            startCoordinates = location
        }
    }
}

extension TourMapViewController: MGLMapViewDelegate {
    
    fileprivate func setupMapView() {
        let styleURL = NSURL(string: Secrets.mapStyle)
        
        mapView  = MGLMapView(frame: view.bounds,
                              styleURL: styleURL as URL?)
        setupMapViewUI()
        tourDestination = addAnnotations(location: stops[0].location.location, locationName: stops[0].location.locationName)
        mapView.delegate = self
        mapView.userTrackingMode = .follow
    }
    
    func setupMapViewUI() {
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
        addAnnotationsToMap()
    }
    
    func addAnnotationsToMap() {
        for i in 0...2 {
            let location = CLLocation(latitude: stops[i].location.coordinates.latitude, longitude: stops[i].location.coordinates.longitude)
            var centerAnnotation = addAnnotations(location: location, locationName: stops[i].location.locationName)
            self.tourStops.append(centerAnnotation)
        }
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
        return UIColor.darkGray
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 2
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
        var tourStopWayPoints: [Waypoint] = locationStore.setWaypointsFromStops(tourStops: self.tourStops)
        
        guard let startingLocation = initialLocation, let destination = tourDestination else { return }
        locationStore.sortWaypoints(origin: startingLocation, waypoints: tourStopWayPoints)
        
        let originWaypoint = Waypoint(coordinate: startingLocation.coordinate)
        let destinationWaypoint = Waypoint(coordinate: destination.coordinate)
        
        tourStopWayPoints.insert(originWaypoint, at: 0)
        tourStopWayPoints.append(destinationWaypoint)
        
        let directions = Directions(accessToken: Secrets.mapKey)
        let options = RouteOptions(waypoints: tourStopWayPoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
        
        options.includesSteps = true
        options.routeShapeResolution = .full
        
        directions.calculate(options) { waypoints, routes, error in
            guard error == nil else { print("Error getting directions: \(error!)"); return }
            if let routes = routes , let route = routes.first {
                self.navRoutes = routes
                self.navLegs = route.legs
                let travelTimeFormatter = DateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .short
                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
                completion(formattedTravelTime!)
                if route.coordinateCount > 0 {
                    var routeCoordinates = route.coordinates!
                    self.tourPath = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    if let routeLine = self.tourPath {
                        self.mapView.addAnnotation(routeLine)
                        self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: UIEdgeInsets.zero, animated: true)
                    }
                }
            }
        }
    }
    
    func removePath() {
        if let path = tourPath {
            mapView.removeAnnotation(path)
        }
        tourPath = nil
    }
    
    func removeWaypoints() {
        tourStops.removeAll()
    }
    
    func removeUnusedWaypoints() {
        POI.removeAll()
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

