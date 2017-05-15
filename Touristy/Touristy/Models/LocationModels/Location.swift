//
//  Location.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 5/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import CoreLocation

struct Location {
    let streetAddress: String
    let distanceTo: String
    let locationName: String
    let coordinates: CLLocationCoordinate2D
    var location: CLLocation
}
