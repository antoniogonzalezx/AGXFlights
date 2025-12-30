//
//  Flight.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 26/12/25.
//

import Foundation
import CoreLocation

struct Flight: Identifiable, Equatable, Sendable, Hashable {
    let id: String
    let callsign: String?
    let originCountry: String
    let timePosition: Date?
    let longitude: Double?
    let latitude: Double?
    let velocity: Double?
    let altitude: Double?
    
    var displayCallsign: String {
        guard let callsign, !callsign.isEmpty else {
            return "UNKNOWN"
        }
        return callsign
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
