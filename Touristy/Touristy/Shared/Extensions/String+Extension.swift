//
//  String+Extension.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

extension String {
    static func getTravelTimeFromInterval(interval: TimeInterval) -> String? {
        let travelTimeFormatter = DateComponentsFormatter()
        travelTimeFormatter.unitsStyle = .short
        let formattedTravelTime = travelTimeFormatter.string(from: interval)
        return formattedTravelTime
    }
    
}
