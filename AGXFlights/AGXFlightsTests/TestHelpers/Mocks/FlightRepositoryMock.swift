//
//  FlightRepositoryMock.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 29/12/25.
//

import Foundation
@testable import AGXFlights

@MainActor
final class FlightRepositoryMock: FlightRepositoryProtocol {
    var searchResult: [Flight] = []
    var fetchAllResult: [Flight] = []
    var fromCache: Bool = false
    var searchCallCount = 0
    var fetchAllCallCount = 0
    var clearCacheCallCount = 0
    var lastSearchQuery: String?
    var shouldThrowError = false
    var error: Error = NetworkError.invalidResponse
    
    func searchFlights(query: String) async throws -> FlightsResult {
        searchCallCount += 1
        lastSearchQuery = query
        if shouldThrowError { throw error }
        return FlightsResult(flights: searchResult, fromCache: fromCache)
    }
    
    func fetchAllFlights() async throws -> FlightsResult {
        fetchAllCallCount += 1
        if shouldThrowError { throw error }
        return FlightsResult(flights: fetchAllResult, fromCache: fromCache)
    }
    
    func clearCache() async {
        clearCacheCallCount += 1
    }
}
