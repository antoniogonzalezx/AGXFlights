//
//  FlightRepositoryProtocol.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

struct FlightsResult: Sendable {
    let flights: [Flight]
    let fromCache: Bool
}

protocol FlightRepositoryProtocol: Sendable {
    func searchFlights(query: String) async throws -> FlightsResult
    func fetchAllFlights() async throws -> FlightsResult
    func clearCache() async
}
