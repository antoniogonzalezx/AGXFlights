//
//  FlightRepositoryProtocol.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

protocol FlightRepositoryProtocol: Sendable {
    func searchFlights(query: String) async throws -> [Flight]
    func fetchAllFlights() async throws -> [Flight]
    func clearCache() async
}
