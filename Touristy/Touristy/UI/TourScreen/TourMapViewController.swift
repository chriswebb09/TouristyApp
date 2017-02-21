import UIKit
import SnapKit
import CoreLocation
import Mapbox
import MapboxGeocoder
import MapboxDirections
import RealmSwift

let MapboxAccessToken = Secrets.mapKey

final class TourMapViewController: UIViewController {
    
    var tourist: Results<Tourist>!
    
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
    var startLocation: Annotation?
    var end: Annotation?
    var tourStops: [MGLAnnotation] = []
    let directions = Directions(accessToken: Secrets.mapKey)
    var stops = TourStop.stops
    
    init(_ coder: NSCoder? = nil) {
        self.startLocation = Annotation(typeSelected: .origin)
        self.end = Annotation(typeSelected: .tourStop)
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let realm = try? Realm() {
            tourist = realm.objects(Tourist.self)
        }
        
        setLocation()
        setLocation()
        setupMapView()
        addAnnotation()
    }
}

extension TourMapViewController: MGLMapViewDelegate {
    
    fileprivate func setupMapView() {
        let styleURL = URL(string: Secrets.mapStyle)
        mapView  = MGLMapView(frame: view.bounds, styleURL: styleURL)
        setupMapViewUI()
        tourDestinationAnnotation = createAnnotations(location: stops[0].location.location,
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
        let centerAnnotation = createAnnotations(location: startCoordinates, locationName: "Begin")
        initialLocationAnnotation = centerAnnotation
        addAnnotationsToMap()
        setCenterCoordinateOnMapView()
    }
    
    func addAnnotationsToMap() {
        var newTourStops = [TourStop]()
        for i in 1...3 {
            let location = CLLocation(latitude: stops[i].location.coordinates.latitude, longitude: stops[i].location.coordinates.longitude)
            let tourAnnotation = createAnnotations(location: location, locationName: "\(i). \(stops[i].location.locationName)")
            newTourStops.append(stops[i])
            self.tourStops.append(tourAnnotation)
        }
        
        print(locationStore.getClosestDestination(locations: newTourStops))
        createPath() { time in
            print(time)
        }
    }
    
    func createAnnotations(location: CLLocation, locationName: String) -> MGLPointAnnotation {
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
        mapView.setCenter(downtownManhattan, zoomLevel: 15, direction: 25.0, animated: false)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate,
                                  fromDistance: 200,
                                  pitch: 20,
                                  heading: 0)
        mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        mapView.resetNorth()
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard let selectedAnnotation = annotation as? Annotation else {
            return
        }
        
        guard let origin = startLocation, let destination = end else {
            return
        }
        switch selectedAnnotation.type {
        case .origin:
            mapView.deselectAnnotation(annotation, animated: true)
        case .POI:
            mapView.deselectAnnotation(annotation, animated: true)
        case .tourStop:
            mapView.deselectAnnotation(annotation, animated: true)
        default:
            break
        }
        
    }
    
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        if view.isKind(of: TourSpotAnnotationView.self) {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
        }
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
                //getTravelTimeFromInterval(interval: route.expectedTravelTime)!
                completion("time")
                
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
    
    
    func setStartPoint(startPoint: Annotation) {
        if let start = startLocation {
            mapView.removeAnnotation(start)
        }
        self.startLocation = startPoint
        mapView.addAnnotation(startPoint)
        mapView.setCenter(startPoint.coordinate, animated: true)
    }
    
    func getDestination(destinationPoint: Annotation) {
        if let destination = end {
            mapView.removeAnnotation(destination)
        }
        self.end = destinationPoint
        mapView.addAnnotation(destinationPoint)
        mapView.setCenter(destinationPoint.coordinate, animated: true)
        
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
        
        func coordinatesEqual(location: CLLocationCoordinate2D, other: CLLocationCoordinate2D) -> Bool {
            return location.latitude == other.latitude && location.longitude == other.longitude
        }
        
        func containsWaypoint(waypoint: Annotation) -> Bool {
            if POI.contains(where: { $0.title! == waypoint.title! }) {
                return true
            }
            return false
        }
    }
}

extension TourMapViewController: CLLocationManagerDelegate {
    
    func setLocation() {
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
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                return nil
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                return locationManager.location
            }
        } else {
            print("Location services are not enabled")
            return nil
        }
    }
}

