import UIKit
import SnapKit
import CoreLocation
import Mapbox
import MapboxGeocoder
import MapboxDirections
import RealmSwift

let MapboxAccessToken = Secrets.mapKey

final class TourMapViewController: UIViewController  {
    
    let directions = Directions(accessToken: Secrets.mapKey)
    let locationStore = TourDataStore.shared
    var locationService = LocationService.sharedInstance
    var tourist: Results<Tourist>!
    var viewModel = TourMapViewModel()
    var currentStage: CurrentStage?
    var mapView: MGLMapView!
    var createMode = false
    var startCoordinates = CLLocation()
    var initialLocationAnnotation: MGLAnnotation?
    var tourDestinationAnnotation: MGLAnnotation?
    var tourPoints: [Annotation] = []
    var tourPath: MGLPolyline?
    var POI: [Annotation] = []
    var startLocation: Annotation?
    var end: Annotation?
    var tourStops: [MGLAnnotation] = []
    
    var stops: [TourStop] = TourStop.stops
    
    enum CurrentStage {
        case defaultStage, waypoints, route
    }
    
    init(_ coder: NSCoder? = nil) {
        
        startLocation = Annotation(typeSelected: .origin)
        end = Annotation(typeSelected: .tourStop)
        
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
        
        if let realm = try? Realm() { tourist = realm.objects(Tourist.self) }
        
        viewModel.setLocation(controller: self)
        viewModel.setupMapView(controller: self)
        viewModel.addAnnotation(controller: self)
    }
}

extension TourMapViewController: MGLMapViewDelegate {
    
    func setupTourStopButton() -> UIButton {
        
        let removeButton = UIButton(type: .system)
        let myAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: UIFontWeightLight)]
        let buttonIcon = NSAttributedString(string: "ⓧ", attributes: myAttributes)
        
        removeButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        removeButton.setAttributedTitle(buttonIcon, for: .normal)
        removeButton.tintColor = .red
        
        return removeButton
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        guard let annotationSelected = annotation as? Annotation else { return nil }
        switch annotationSelected.type {
            
        case .tourStop:
            return setupTourStopButton()
            
        case .POI:
            let addButton = UIButton(type: .contactAdd)
            addButton.tintColor = .green
            return addButton
            
        default:
            return nil
            
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return viewModel.showAnnotation
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return viewModel.lineColor
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return viewModel.lineWidth
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return viewModel.viewForAnnotation(controller: self, annotation: annotation)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        viewModel.tapCalloutAcessory(controller: self, annotation: annotation)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let centerCoordinate = mapView.centerCoordinate
        let camera = MGLMapCamera(lookingAtCenter: centerCoordinate, fromDistance: 200, pitch: 20, heading: 0)
        
        mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        mapView.resetNorth()
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        
        guard let selectedAnnotation = annotation as? Annotation else { return }
        
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
        completion(viewModel.path(controller: self))
    }
}

extension TourMapViewController: LocationServiceDelegate {
    
    func tracingLocationDidFailWithError(error: NSError) {
        
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        
    }

}
