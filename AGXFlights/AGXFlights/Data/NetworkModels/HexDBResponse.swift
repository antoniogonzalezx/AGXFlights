//
//  HexDBResponse.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 28/12/25.
//

import Foundation

struct HexDBRouteResponse: Codable {
    let route: String?
}

struct HexDBAirportResponse: Codable {
    let airport: String
    let iata: String?
    let countryCode: String
    
    enum CodingKeys: String, CodingKey {
        case airport
        case iata
        case countryCode = "country_code"
    }
}
