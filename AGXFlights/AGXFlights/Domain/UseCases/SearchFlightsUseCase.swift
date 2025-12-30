//
//  SearchFlightsUseCase.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

protocol SearchFlightsUseCaseProtocol: Sendable {
    func search(query: String) async throws -> FlightsResult
}

class SearchFlightsUseCase: SearchFlightsUseCaseProtocol, Sendable {
    private let repository: FlightRepositoryProtocol
    
    init(repository: FlightRepositoryProtocol) {
        self.repository = repository
    }
    
    func search(query: String) async throws -> FlightsResult {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            return FlightsResult(flights: [], fromCache: true)
        }
        
        return try await repository.searchFlights(query: query)
    }
}
