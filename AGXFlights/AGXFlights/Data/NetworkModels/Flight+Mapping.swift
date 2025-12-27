//
//  Flight+Mapping.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

// MARK: - OpenSky API State Mapping
//
// The states property is a two-dimensional array. Each row represents a state vector:
//
// Index | Property        | Type    | Description
// ------|-----------------|---------|---------------------------------------------
// 0     | icao24          | string  | Unique ICAO 24-bit address (hex)
// 1     | callsign        | string  | Callsign (8 chars). Can be null.
// 2     | origin_country  | string  | Country name from ICAO 24-bit address
// 3     | time_position   | int     | Unix timestamp for last position update. Can be null.
// 4     | last_contact    | int     | Unix timestamp for last update
// 5     | longitude       | float   | WGS-84 longitude in decimal degrees. Can be null.
// 6     | latitude        | float   | WGS-84 latitude in decimal degrees. Can be null.
// 7     | baro_altitude   | float   | Barometric altitude in meters. Can be null.
// 8     | on_ground       | boolean | True if from surface position report
// 9     | velocity        | float   | Velocity over ground in m/s. Can be null.
// 10    | true_track      | float   | True track in degrees (north=0°). Can be null.
// 11    | vertical_rate   | float   | Vertical rate in m/s. Can be null.
// 12    | sensors         | int[]   | Receiver IDs. Can be null.
// 13    | geo_altitude    | float   | Geometric altitude in meters. Can be null.
// 14    | squawk          | string  | Transponder code. Can be null.
// 15    | spi             | boolean | Special purpose indicator
// 16    | position_source | int     | 0=ADS-B, 1=ASTERIX, 2=MLAT, 3=FLARM
// 17    | category        | int     | Aircraft category (0-20)
//
// Full documentation: https://openskynetwork.github.io/opensky-api/rest.html

extension Flight {
    init?(from state: [StateValue]) {
        guard state.count >= 17,
              let id = state[0].stringValue,
              let originCountry = state[2].stringValue else {
            return nil
        }
        
        self.init(
            id: id,
            callsign: state[1].stringValue?.trimmingCharacters(in: .whitespaces),
            originCountry: originCountry,
            timePosition: state[3].intValue.map { Date(timeIntervalSince1970: TimeInterval($0)) },
            longitude: state[5].doubleValue,
            latitude: state[6].doubleValue,
            velocity: state[9].doubleValue,
            altitude: state[7].doubleValue
        )
    }
}
