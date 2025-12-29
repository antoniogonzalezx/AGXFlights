//
//  SearchFlightsUseCaseMock.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 29/12/25.
//

import Foundation
@testable import AGXFlights

@MainActor
final class SearchFlightsUseCaseMock: SearchFlightsUseCaseProtocol {
    var searchResult: [Flight] = []
    var searchCallCount = 0
    var shouldThrowError = false
    var error: Error = NetworkError.invalidResponse
    
    func search(query: String) async throws -> [Flight] {
        searchCallCount += 1
        if shouldThrowError { throw error }
        return searchResult
    }
}
