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
    var searchCallCount = 0
    var fetchAllCallCount = 0
    var lastSearchQuery: String?
    var shouldThrowError = false
    var error: Error = NetworkError.invalidResponse
    
    func searchFlights(query: String) async throws -> [Flight] {
        searchCallCount += 1
        lastSearchQuery = query
        if shouldThrowError { throw error }
        return searchResult
    }
    
    func fetchAllFlights() async throws -> [Flight] {
        fetchAllCallCount += 1
        if shouldThrowError { throw error }
        return fetchAllResult
    }
}
