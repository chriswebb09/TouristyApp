//
//  TourStop.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreLocation

struct TourStop {
    var location: Location
    let locationName: String
    let locationCoords: CLLocationCoordinate2D
    let localHistory: String
    var historicalPhotos: [UIImage]?
    var trivia: [String]
}

struct Stops {
    var stops: [TourStop]
    mutating func setupLocations(locations: [Location]) {
        self.stops = [TourStop]()
        locations.forEach { location in
            self.stops.append(TourStop(location: location, locationName: location.locationName, locationCoords: location.coordinates, localHistory: "Uknown", historicalPhotos: nil, trivia: ["Test"]))
        }
        
    }
}
