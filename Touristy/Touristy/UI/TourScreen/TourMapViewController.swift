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
    var initialLocationAnnotation: MGLAnnotation?
    var tourDestinationAnnotation: MGLAnnotation?
    
    var tourPath: MGLPolyline?
    var navRoutes: [Route] = []
    var navLegs: [RouteLeg] = []
    var POI: [Annotation] = []
    var tourStops: [MGLAnnotation] = []
    let directions = Directions(accessToken: Secrets.mapKey)
    
    var stops = TourStop.stops
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        setLocation()
        setupMapView()
        addAnnotation()
    }
}

extension TourMapViewController: MGLMapViewDelegate {
    
    fileprivate func setupMapView() {
        let styleURL = NSURL(string: Secrets.mapStyle)
        mapView  = MGLMapView(frame: view.bounds, styleURL: styleURL as URL?)
        setupMapViewUI()
        tourDestinationAnnotation = addAnnotations(location: stops[0].location.location,
                                                   locationName: stops[0].location.locationName)
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
        initialLocationAnnotation = centerAnnotation
        addAnnotationsToMap()
        setCenterCoordinateOnMapView()
    }
    
    func addAnnotationsToMap() {
        for i in 1...3 {
            let location = CLLocation(latitude: stops[i].location.coordinates.latitude,
                                      longitude: stops[i].location.coordinates.longitude)
            var tourAnnotation = addAnnotations(location: location,
                                                locationName: "\(i). \(stops[i].location.locationName)")
            self.tourStops.append(tourAnnotation)
        }
        createPath(completion: { time in
            print(time)
        })
    }
    
    func addAnnotations(location: CLLocation, locationName: String) -> MGLPointAnnotation {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                       longitude:location.coordinate.longitude)
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
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        let reuseIdentifier = "\(annotation.title)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = TourSpotAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        }
        annotationView?.backgroundColor = .white
        return annotationView
    }
    
    private func setCenterCoordinateOnMapView() {
        let downtownManhattan = CLLocationCoordinate2D(latitude: startCoordinates.coordinate.latitude,
                                                       longitude: startCoordinates.coordinate.longitude)
        mapView.setCenter(downtownManhattan,
                          zoomLevel: 15,
                          direction: 25.0,
                          animated: false)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate,
                                  fromDistance: 200,
                                  pitch: 20,
                                  heading: 0)
        mapView.setCamera(camera,
                          withDuration: 2,
                          animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
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
        guard let startingLocation = initialLocationAnnotation, let destination = tourDestinationAnnotation else { return }
        let tourStopWayPoints: [Waypoint] = locationStore.setWaypointsFromStops(startingCoordinate:startingLocation,
                                                                                endCoordinate: destination,
                                                                                tourStops: self.tourStops)
        
        let options = RouteOptions(waypoints: tourStopWayPoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
        options.includesSteps = true
        options.routeShapeResolution = .full
        
        _ = directions.calculate(options) { waypoints, routes, error in
            guard error == nil else { print("Error getting directions: \(error!)"); return }
            if let routes = routes , let route = routes.first {
                self.navRoutes = routes
                self.navLegs = route.legs
                completion(self.getTravelTimeFromInterval(interval: route.expectedTravelTime)!)
                
                if route.coordinateCount > 0 {
                    var routeCoordinates = route.coordinates!
                    self.tourPath = MGLPolyline(coordinates: &routeCoordinates,
                                                count: route.coordinateCount)
                    
                    if let routeLine = self.tourPath {
                        self.mapView.addAnnotation(routeLine)
                        self.mapView.setVisibleCoordinates(&routeCoordinates,
                                                           count: route.coordinateCount,
                                                           edgePadding: UIEdgeInsets.zero, animated: true)
                    }
                }
            }
        }
    }
    
    func getTravelTimeFromInterval(interval: TimeInterval) -> String? {
        let travelTimeFormatter = DateComponentsFormatter()
        travelTimeFormatter.unitsStyle = .short
        let formattedTravelTime = travelTimeFormatter.string(from: interval)
        return formattedTravelTime
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
    
    fileprivate func setLocation() {
        if let location = initializeLocationToUser() {
            startCoordinates = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            self.startCoordinates = location
            self.locationStore.initialLocation = location
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

