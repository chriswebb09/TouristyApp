import UIKit
import CoreLocation

public struct TourStop {
    var location: Location
    let localHistory: String
    var historicalPhotos: [UIImage]?
    var trivia: [String]
    
    static let stops: [TourStop] = {
        
        let worldTraceCenterMemorial = TourStop(
            location: Location(
                streetAddress: "180 Greenwich St, New York, NY",
                distanceTo: "Unknown",
                locationName: "World Trade Center Memorial",
                coordinates: CLLocationCoordinate2D(latitude: 40.711415, longitude: -74.012479)
            ),
            localHistory: "Unknown",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let centralPark = TourStop(
            location: Location(
                streetAddress: "Central Park, New York, NY 10024",
                distanceTo: "Unknown",
                locationName: "Central Park",
                coordinates: CLLocationCoordinate2D(latitude: 40.782865, longitude: -73.965355)
            ),
            localHistory: "Unknown",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let theTombs = TourStop(
            location: Location(
                streetAddress: "125 White St, New York, NY 10013",
                distanceTo: "Unknown",
                locationName: "Manhattan Detention Complex 'The Tombs'",
                coordinates: CLLocationCoordinate2D(latitude: 40.717030, longitude: -74.000316)
            ),
            localHistory: "Unknown",
            historicalPhotos: [UIImage()],
            trivia: ["None"]
        )
        
        let triangleFire = TourStop(
            location: Location(
                streetAddress: "Washington Pl, New York, NY 10003",
                distanceTo: "Unknown",
                locationName: "Triangle Shirtwaist Factory 'The Triangle Fire'",
                coordinates: CLLocationCoordinate2D(latitude: 40.730041, longitude: -73.995593)
            ),
            localHistory: "Unknown",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let ussIntrepid = TourStop(
            location: Location(
                streetAddress: "Pier 86, W 46th St & 12th Ave, New York, NY 10036",
                distanceTo: "Unknown",
                locationName: "USS Intrepid Museum",
                coordinates: CLLocationCoordinate2D(latitude: 40.764527, longitude: -73.999608)
            ),
            localHistory: "Unknown",
            historicalPhotos: [UIImage()], trivia: ["None"])
        
        let tenamentMuseum = TourStop(
            location: Location(
                streetAddress: "103 Orchard St, New York, NY 10002",
                distanceTo: "Unknown",
                locationName: "Tenament Museum",
                coordinates: CLLocationCoordinate2D(latitude: 40.718793, longitude: -73.990070)
            ),
            localHistory: "Unknown",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let africanBurialGround = TourStop(
            location: Location(
                streetAddress: "Ted Weiss Federal Building, 290 Broadway, New York, NY 10007",
                distanceTo: "Unknown",
                locationName: "African Burial Ground National Monument",
                coordinates: CLLocationCoordinate2D(latitude: 40.714723, longitude: -74.005142)
            ),
            localHistory: "Unknown",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let SixtyNinthRegimentArmory = TourStop(
            location: Location(
                streetAddress: "68 Lexington Ave, New York, NY 10010",
                distanceTo: "Unknown",
                locationName: "69th Regiment Armory",
                coordinates: CLLocationCoordinate2D(latitude: 40.741349, longitude: -73.984246)
            ),
            localHistory: "Unknown",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let frauncesTavern = TourStop(
            location: Location(
                streetAddress: "54 Pearl St, New York, NY 10004",
                distanceTo: "Unknown", locationName: "Fraunces Tavern",
                coordinates: CLLocationCoordinate2D(latitude: 40.703395, longitude: -74.011337)
            ),
            localHistory: "Unknown",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        return [
            worldTraceCenterMemorial,
            centralPark,
            theTombs,
            triangleFire,
            ussIntrepid,
            tenamentMuseum,
            africanBurialGround
        ]
    }()
}
