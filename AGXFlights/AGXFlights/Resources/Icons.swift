//
//  Icons.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 28/12/25.
//

import SwiftUI

enum Icons: String {
    case airplane = "airplane"
    case airplaneList = "airplane.up.right.app.fill"
    case airplanePath = "airplane.path.dotted"
    case location = "location.fill"
    case altitude = "arrow.up"
    case speed = "speedometer"
    case clock = "clock"
    case globe = "globe"
    case error = "exclamationmark.triangle"
    
    var image: Image {
        Image(systemName: rawValue)
    }
}
