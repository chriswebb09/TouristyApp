import UIKit
import CoreLocation
import Mapbox
import MapboxDirections

class TourDataStore {
    
    static let shared = TourDataStore()
    
    var initialLocation: CLLocation?
    var tourDestination: CLLocation?
    
    func setLocations(initialLocation: CLLocation, tourDestination: CLLocation) {
        self.initialLocation = initialLocation
        self.tourDestination = tourDestination
    }
    
    var totalDistance: Double {
        guard let initialLocation = initialLocation else { return 0 }
        guard let tourDestination = tourDestination else { return 0 }
        return initialLocation.distance(from: tourDestination)
    }
    
    var searchRadius: Double {
        return totalDistance / 2
    }
    
    func setWaypointsFromStops(startingCoordinate: MGLAnnotation, endCoordinate: MGLAnnotation, tourStops: [MGLAnnotation]) -> [Waypoint] {
        var waypoints = [Waypoint]()
        for waypoint in tourStops {
            let waypoint = Waypoint(coordinate: waypoint.coordinate)
            waypoints.append(waypoint)
        }
        
        sortWaypointsByDistance(origin: startingCoordinate, waypoints: waypoints)
        
        let originWaypoint = Waypoint(coordinate: startingCoordinate.coordinate)
        let destinationWaypoint = Waypoint(coordinate:endCoordinate.coordinate)
        
        waypoints.insert(originWaypoint, at: 0)
        waypoints.append(destinationWaypoint)
        return waypoints
    }
    
    func sortWaypointsByDistance(origin: MGLAnnotation, waypoints: [Waypoint]) {
        var waypoints = waypoints
        if let origin = initialLocation {
            let current = CLLocation(latitude: origin.coordinate.latitude, longitude: origin.coordinate.longitude)
            waypoints.sort { loc1, loc2 in
                let loc1 = CLLocation(latitude: loc1.coordinate.latitude, longitude: loc1.coordinate.longitude)
                let loc2 = CLLocation(latitude: loc2.coordinate.latitude, longitude: loc2.coordinate.longitude)
                return current.distance(from: loc1) < current.distance(from: loc2)
            }
        }
    }
    
    func getClosestDestination(locations: [TourStop]) -> CLLocation {
        var totalLat = 0.0
        var totalLong = 0.0
        let numberOfLocations = Double(locations.count)
        locations.forEach { location in
            dump(location)
            totalLat = totalLat + location.location.location.coordinate.latitude
            totalLong = totalLong + location.location.location.coordinate.longitude
        }
        return CLLocation(latitude: totalLat/numberOfLocations, longitude: totalLong/numberOfLocations)
    }
}
