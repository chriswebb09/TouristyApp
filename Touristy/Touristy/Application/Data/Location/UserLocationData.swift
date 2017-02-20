//
//  UserLocationData.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import MapboxDirections

struct Location {
    let streetAddress: String
    let distanceTo: String
    let locationName: String
    let coordinates: CLLocationCoordinate2D
    var location: CLLocation
}

struct Coordinate {
    var latitude: Float
    var longitude: Float
}

struct UserLocationData {
    func midpointCoordinates(origin: CLLocation, destination: CLLocation) -> CLLocation {
        let centerLatitidue = (origin.coordinate.latitude + destination.coordinate.latitude) / 2
        let centerLongitude = (origin.coordinate.longitude + destination.coordinate.longitude) / 2
        return CLLocation(latitude: centerLatitidue, longitude: centerLongitude)
    }
    
    func getClosestDestination(locations: [CLLocation]) -> CLLocation {
        var totalLat = 0.0
        var totalLong = 0.0
        let numberOfLocations = Double(locations.count)
        locations.forEach { location in
            totalLat = totalLat + location.coordinate.latitude
            totalLong = totalLong + location.coordinate.longitude
        }
        return CLLocation(latitude: totalLat/numberOfLocations, longitude: totalLong/numberOfLocations)
    }
}


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
                coordinates: CLLocationCoordinate2D(latitude: 40.711415, longitude: -74.012479),
                location: CLLocation(latitude: 40.711415, longitude: -74.012479)
            ),
            localHistory: "The National September 11 Memorial & Museum (also known as the 9/11 Memorial and 9/11 Memorial Museum) are the principal memorial and museum, respectively. They commemorate the September 11, 2001 attacks, which killed 2,977 victims, and the World Trade Center bombing of 1993, which killed six.",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let centralPark = TourStop(
            location: Location(
                streetAddress: "Central Park, New York, NY 10024",
                distanceTo: "Unknown",
                locationName: "Central Park",
                coordinates: CLLocationCoordinate2D(latitude: 40.782865, longitude: -73.965355),
                location: CLLocation(latitude: 40.782865, longitude:  -73.965355)
            ),
            localHistory: "Central Park is an urban park in Manhattan, New York City. Central Park is the most visited urban park in the United States, with 40 million visitors in 2013 and one of the most filmed locations in the world.",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let theTombs = TourStop(
            location: Location(
                streetAddress: "125 White St, New York, NY 10013",
                distanceTo: "Unknown",
                locationName: "Manhattan Detention Complex 'The Tombs'",
                coordinates: CLLocationCoordinate2D(latitude: 40.717030, longitude: -74.000316),
                location: CLLocation(latitude: 40.717030, longitude: -74.000316)
            ),
            localHistory: "The Tombs is the colloquial name for the Manhattan Detention Complex (formerly the Bernard B. Kerik Complex), a municipal jail in Lower Manhattan at 125 White Street, as well as the nickname for three previous city-run jails in the former Five Points neighborhood of lower Manhattan, an area now known as the Civic Center.",
            historicalPhotos: [UIImage()],
            trivia: ["None"]
        )
        
        let triangleFire = TourStop(
            location: Location(
                streetAddress: "Washington Pl, New York, NY 10003",
                distanceTo: "Unknown",
                locationName: "Triangle Shirtwaist Factory 'The Triangle Fire'",
                coordinates: CLLocationCoordinate2D(latitude: 40.730041, longitude: -73.995593),
                location: CLLocation(latitude: 40.730041, longitude: -73.995593)
            ),
            localHistory: "The Triangle Shirtwaist Factory fire in New York City on March 25, 1911 was the deadliest industrial disaster in the history of the city, and one of the deadliest in US history. The fire caused the deaths of 146 garment workers – 123 women and 23 men – who died from the fire, smoke inhalation, or falling or jumping to their deaths. Most of the victims were recent Jewish and Italian immigrant women aged 16 to 23 of the victims whose ages are known, the oldest victim was Providenza Panno at 43, and the youngest were 14-year-olds Kate Leone and 'Sara' Rosaria Maltese.",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let ussIntrepid = TourStop(
            location: Location(
                streetAddress: "Pier 86, W 46th St & 12th Ave, New York, NY 10036",
                distanceTo: "Unknown",
                locationName: "USS Intrepid Museum",
                coordinates: CLLocationCoordinate2D(latitude: 40.764527, longitude: -73.999608),
                location: CLLocation(latitude: 40.764527, longitude: -73.999608)
            ),
            localHistory: "Launched in 1943, the aircraft carrier Intrepid fought in World War II, surviving five kamikaze attacks and one torpedo strike. The ship later served in the Cold War and the Vietnam War. Intrepid also served as a NASA recovery vessel in the 1960s. More than 50,000 men served on board Intrepid during the ship's time in service, and more than 270 men made the ultimate sacrifice. Intrepid was decommissioned in 1974. Today, Intrepid is berthed on the Hudson River as the centerpiece of the Intrepid Sea, Air & Space Museum.",
            historicalPhotos: [UIImage()], trivia: ["None"])
        
        let tenamentMuseum = TourStop(
            location: Location(
                streetAddress: "103 Orchard St, New York, NY 10002",
                distanceTo: "Unknown",
                locationName: "Tenament Museum",
                coordinates: CLLocationCoordinate2D(latitude: 40.718793, longitude: -73.990070),
                location: CLLocation(latitude: 40.718793, longitude: -73.990070)
                
            ),
            localHistory: "The Lower East Side Tenement Museum, located at 97 Orchard Street in the Lower East Side neighborhood of Manhattan, New York City, is a National Historic Site. The five-story brick tenement building was home to an estimated 7,000 people, from over 20 nations, between 1863 and 1935. The museum, which includes a visitors' center down the block, promotes tolerance and historical perspective on the immigrant experience.",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let africanBurialGround = TourStop(
            location: Location(
                streetAddress: "Ted Weiss Federal Building, 290 Broadway, New York, NY 10007",
                distanceTo: "Unknown",
                locationName: "African Burial Ground National Monument",
                coordinates: CLLocationCoordinate2D(latitude: 40.714723, longitude: -74.005142),
                location: CLLocation(latitude: 40.714723, longitude: -74.005142)
            ),
            localHistory: "African Burial Ground National Monument is a monument at Duane Street and African Burial Ground Way (Elk Street) in the Civic Center section of Lower Manhattan, New York City. Its main building is the Ted Weiss Federal Building at 290 Broadway. The site contains the remains of more than 419 Africans buried during the late 17th and 18th centuries in a portion of what was the largest colonial-era cemetery for people of African descent, some free, most enslaved. Historians estimate there may have been 10,000–20,000 burials in what was called the 'Negroes Burial Ground' in the 1700s.",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let SixtyNinthRegimentArmory = TourStop(
            location: Location(
                streetAddress: "68 Lexington Ave, New York, NY 10010",
                distanceTo: "Unknown",
                locationName: "69th Regiment Armory",
                coordinates: CLLocationCoordinate2D(latitude: 40.741349, longitude: -73.984246),
                location: CLLocation(latitude: 40.741349, longitude: -73.984246)
            ),
            localHistory: "The 69th Regiment Armory is located at 68 Lexington Avenue between East 25th and 26th Streets in the Rose Hill section of Manhattan, New York City. The historic building began construction in 1904 and was completed in 1906.[1][4] The building is still used to house the headquarters of the New York Army National Guard's 1st Battalion, 69th Infantry Regiment (known as the 'Fightin Irish' since Gettsyburg), as well as for the presentation of special events.",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let frauncesTavern = TourStop(
            location: Location(
                streetAddress: "54 Pearl St, New York, NY 10004",
                distanceTo: "Unknown", locationName: "Fraunces Tavern",
                coordinates: CLLocationCoordinate2D(latitude: 40.703395, longitude: -74.011337),
                location: CLLocation(latitude: 40.741349, longitude: -73.984246)
            ),
            localHistory: "Fraunces Tavern is a landmark museum and restaurant in New York City, situated at 54 Pearl Street at the corner of Broad Street. The location played a prominent role in history before, during and after the American Revolution, serving as a headquarters for George Washington, a venue for peace negotiations with the British, and housing federal offices in the Early Republic.",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let cityHall = TourStop(
            location: Location(
                streetAddress: "City Hall Park, New York, NY 10007",
                distanceTo: "Unknown", locationName: "New York City Hall",
                coordinates: CLLocationCoordinate2D(latitude: 40.712850, longitude: -74.006465),
                location: CLLocation(latitude: 40.712850, longitude: -74.006465)
            ),
            localHistory: "New York City Hall, the seat of New York City government, is located at the center of City Hall Park in the Civic Center area of Lower Manhattan, between Broadway, Park Row, and Chambers Street. The building is the oldest city hall in the United States that still houses its original governmental functions, such as the office of the Mayor of New York City and the chambers of the New York City Council. While the Mayor's Office is in the building, the staff of thirteen municipal agencies under mayoral control are located in the nearby Manhattan Municipal Building, one of the largest government buildings in the world.",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        let grandCentral = TourStop(
            location: Location(
                streetAddress: "89 E 42nd St, New York, NY 10017",
                distanceTo: "Unknown", locationName: "Grand Central Terminal",
                coordinates: CLLocationCoordinate2D(latitude: 40.752496, longitude: -73.977302),
                location: CLLocation(latitude: 40.752496, longitude: -73.977302)
            ),
            localHistory: "Grand Central Terminal (GCT; also referred to as Grand Central Station or simply as Grand Central) is a commuter, rapid transit (and former intercity) railroad terminal at 42nd Street and Park Avenue in Midtown Manhattan in New York City, United States. Built by and named for the New York Central and Hudson River Railroad in the heyday of American long-distance passenger rail travel, it covers 48 acres (19 ha) and has 44 platforms, more than any other railroad station in the world. Its platforms, all below ground, serve 41 tracks on the upper level and 26 on the lower, though the total number of tracks along platforms and in rail yards exceeds 100.",
            historicalPhotos: [UIImage()],
            trivia: ["None"])
        
        return [
            worldTraceCenterMemorial,
            centralPark,
            theTombs,
            triangleFire,
            ussIntrepid,
            tenamentMuseum,
            africanBurialGround,
            cityHall,
            grandCentral
        ]
    }()
}
