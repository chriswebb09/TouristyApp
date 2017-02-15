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
}

