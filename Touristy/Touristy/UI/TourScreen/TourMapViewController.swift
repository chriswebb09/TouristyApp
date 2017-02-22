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
    var viewModel = TourMapViewModel()
    var currentStage: CurrentStage?
    let locationStore = TourDataStore.shared
    var geocoder = Geocoder(accessToken: Secrets.mapKey)
    var mapView: MGLMapView!
    var createMode = false
    var locationManager: CLLocationManager = CLLocationManager()
    var startCoordinates = CLLocation()
    var initialLocationAnnotation: MGLAnnotation?
    var tourDestinationAnnotation: MGLAnnotation?
    var tourPoints: [Annotation] = []
    var tourPath: MGLPolyline?
    var navRoutes: [Route] = []
    var navLegs: [RouteLeg] = []
    var POI: [Annotation] = []
    var startLocation: Annotation?
    var end: Annotation?
    var tourStops: [MGLAnnotation] = []
    let directions = Directions(accessToken: Secrets.mapKey)
    var stops = TourStop.stops
    
    enum CurrentStage {
        case defaultStage, waypoints, route
    }
    
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
        
        viewModel.setLocation(controller: self)
        viewModel.setupMapView(controller: self)
        viewModel.addAnnotation(controller: self)
    }
}

extension TourMapViewController: MGLMapViewDelegate {
    
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
    
    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        guard let annotationSelected = annotation as? Annotation else {
            return nil
        }
        
        switch annotationSelected.type {
        case .tourStop:
            let removeButton = UIButton(type: .system)
            let myAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: UIFontWeightLight)]
            let buttonIcon = NSAttributedString(string: "ⓧ", attributes: myAttributes)
            removeButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            removeButton.setAttributedTitle(buttonIcon, for: .normal)
            removeButton.tintColor = UIColor.red
            return removeButton
        case .POI:
            let addButton = UIButton(type: .contactAdd)
            addButton.tintColor = UIColor.green
            return addButton
        default:
            return nil
        }
    }
    
    func addAnnotationsToMap() {
        var newTourStops = [TourStop]()
        for i in 1...3 {
            let location = CLLocation(latitude: stops[i].location.coordinates.latitude, longitude: stops[i].location.coordinates.longitude)
            let tourAnnotation = viewModel.createAnnotations(controller: self, location: location, locationName: "\(i). \(stops[i].location.locationName)")
            newTourStops.append(stops[i])
            self.tourStops.append(tourAnnotation)
        }
        
        print(locationStore.getClosestDestination(locations: newTourStops))
        createPath() { time in
            print(time)
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return viewModel.lineColor
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return viewModel.lineWidth
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
    
    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(annotation, animated: false)
        
        guard let selectedAnnotation = annotation as? Annotation else {
            return
        }
        
        
        if createMode && currentStage == .waypoints {
            
            if viewModel.containsWaypoint(tourPoints: tourPoints, waypoint: selectedAnnotation) {
                if let index = tourPoints.index(where: { $0.title! == selectedAnnotation.title! }) {
                    tourPoints.remove(at: index)
                }
                selectedAnnotation.type = .POI
                POI.append(selectedAnnotation)
                let annotationView = mapView.view(for: annotation)
                annotationView?.backgroundColor = selectedAnnotation.annotationColor
            } else {
                if let index = self.POI.index(of: selectedAnnotation) {
                    self.POI.remove(at: index)
                }
                selectedAnnotation.type = .tourStop
                tourPoints.append(selectedAnnotation)
                let annotationView = mapView.view(for: annotation)
                annotationView?.backgroundColor = selectedAnnotation.annotationColor
            }
        }
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
        
        func coordinatesEqual(location: CLLocationCoordinate2D, other: CLLocationCoordinate2D) -> Bool {
            return location.latitude == other.latitude && location.longitude == other.longitude
        }
    }
}

extension TourMapViewController: CLLocationManagerDelegate {
    
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

