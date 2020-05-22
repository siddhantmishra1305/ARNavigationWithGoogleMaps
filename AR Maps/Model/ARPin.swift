//
//  ARPin.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 20/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import Foundation
import ARKit
import CoreLocation

struct ARPin {
    let name: String
    let location: CLLocation
    let instructions : String
    
    init(lat: CLLocationDegrees, lon: CLLocationDegrees, alt: CLLocationDistance, name: String,inst:String) {
        location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), altitude: alt, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: Date())
        self.name = name
        self.instructions = inst
    }
}
