//
//  FlightRepositoryImpl.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

final class FlightRepositoryImpl: FlightRepositoryProtocol, Sendable {
    private let networkService: NetworkServiceProtocol
    private let cache: FlightCache
    
    init(networkService: NetworkServiceProtocol, cache: FlightCache) {
        self.networkService = networkService
        self.cache = cache
    }
    
    func searchFlights(query: String) async throws -> [Flight] {
        let formattedQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !formattedQuery.isEmpty else {
            return []
        }
        
        // 1. Check search cache
        if let cachedFlights = await cache.getSearchResults(for: formattedQuery) {
            return cachedFlights
        }
        
        // 2. Check all flights cache and filter locally
        if let flights = await cache.getFlights() {
            let filtered = filterFlights(flights, query: formattedQuery)
            await cache.setSearchResults(filtered, for: formattedQuery)
            return filtered
        }
        
        // 3. Fetch flights from network
        let allFlights = try await networkService.fetchFlights()
        await cache.setFlights(allFlights)
        
        // 4. Filter all flights locally and cache the results
        let filteredFlights = filterFlights(allFlights, query: formattedQuery)
        await cache.setSearchResults(filteredFlights, for: formattedQuery)
        
        return filteredFlights
    }
    
    
    /// Filters flights using fields:
    /// - `originCountry` (e.g. "Spain")
    /// - `callsign` (e.g. "IBE3456")
    ///
    private func filterFlights(_ flights: [Flight], query: String) -> [Flight] {
        flights.filter { flight in
            flight.originCountry.lowercased().contains(query) || (flight.callsign?.lowercased().contains(query) ?? false)
        }
    }
}
