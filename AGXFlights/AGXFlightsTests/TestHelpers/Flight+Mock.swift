//
//  Helpers.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 29/12/25.
//

import Foundation
@testable import AGXFlights

extension Flight {
    static func mock(
        id: String = "abc123",
        callsign: String? = "IBE987",
        country: String = "Spain",
        latitude: Double? = nil,
        longitude: Double? = nil,
        altitude: Double? = nil,
        velocity: Double? = nil
    ) -> Flight {
        Flight(
            id: id,
            callsign: callsign,
            originCountry: country,
            timePosition: nil,
            longitude: longitude,
            latitude: latitude,
            velocity: velocity,
            altitude: altitude
        )
    }
}
