//
//  Flight+Placeholder.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 28/12/25.
//

import Foundation

extension Flight {
    static let placeholder = Flight(
        id: "000000",
        callsign: "XXXXXXX",
        originCountry: "Country",
        timePosition: nil,
        longitude: nil,
        latitude: nil,
        velocity: nil,
        altitude: nil
    )
}
