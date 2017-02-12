//
//  Location.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Location {
    let streetAddress: String
    let distanceTo: String
    let locationName: String
    let coordinates: CLLocationCoordinate2D
}

struct Locations {
    let centralPark = Location(streetAddress: "Central ParK", distanceTo: "0", locationName: "Central Park" , coordinates: CLLocationCoordinate2D(latitude: 40.782865, longitude: -73.965355))
    let WTCMemorial = Location(streetAddress: "WTC Memorial", distanceTo: "0", locationName: "WTC Memorial", coordinates: CLLocationCoordinate2D(latitude: 40.711415, longitude: -74.012479))
    let frauncesTavern = Location(streetAddress: "Fraunces Tavern", distanceTo: "0", locationName: "Fraunces Tavern", coordinates: CLLocationCoordinate2D(latitude: 40.703395, longitude: -74.011337))
    var stops = [Location]()
    
    init() {
        self.stops = [self.centralPark, self.WTCMemorial, self.frauncesTavern]
    }
}

struct Coordinates {
    var latitude: Float
    var longitude: Float
}


final class Destination {
    let location: Coordinates
   
    var name: String
    var item = CALayer()
    var description: String
    var image: UIImage?
    let imageURL: String
    var downloadingImage: Bool = false
    
    init() {
        self.location = Coordinates(latitude: 13055, longitude: 30506)
        self.name = "New Name"
        self.item = CALayer()
        self.description = "Description"
        self.image = nil
        self.imageURL = "imageURL"
        self.downloadingImage = false
    }
}
