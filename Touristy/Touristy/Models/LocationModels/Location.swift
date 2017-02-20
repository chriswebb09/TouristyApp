import Foundation
import UIKit
import CoreLocation

struct Location {
    let streetAddress: String
    let distanceTo: String
    let locationName: String
    let coordinates: CLLocationCoordinate2D
}


struct Coordinates {
    var latitude: Float
    var longitude: Float
    
    func midpointCoordinates(origin: Location, tourDestination: Location) -> CLLocation {
        let centerLatitidue = (origin.coordinates.latitude + tourDestination.coordinates.latitude) / 2
        let centerLongitude = (origin.coordinates.longitude + tourDestination.coordinates.longitude) / 2
        return CLLocation(latitude: centerLatitidue, longitude: centerLongitude)
    }
}

