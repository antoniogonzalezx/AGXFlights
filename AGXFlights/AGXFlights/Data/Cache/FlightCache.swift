//
//  FlightCache.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

actor FlightCache {
    private var flightsEntry: CacheEntry?
    private var searchCache: [String: CacheEntry] = [:]
    private let interval: TimeInterval
    
    struct CacheEntry {
        let flights: [Flight]
        let timestamp: Date
        
        func isValid(interval: TimeInterval) -> Bool {
            Date().timeIntervalSince(timestamp) < interval
        }
    }
    
    init(interval: TimeInterval = 120) {
        self.interval = interval
    }
    
    // MARK: - Flights cache
    
    func getFlights() -> [Flight]? {
        guard let entry = flightsEntry, entry.isValid(interval: interval) else {
            flightsEntry = nil
            return nil
        }
        
        return entry.flights
    }
    
    func setFlights(_ flights: [Flight]) {
        flightsEntry = CacheEntry(flights: flights, timestamp: Date())
    }
    
    // MARK: - Seach cache
    
    func getSearchResults(for query: String) -> [Flight]? {
        let key = query.lowercased()
        guard let entry = searchCache[key], entry.isValid(interval: interval) else {
            searchCache[key] = nil
            return nil
        }
        
        return entry.flights
    }
    
    func setSearchResults(_ flights: [Flight], for query: String) {
        let key = query.lowercased()
        searchCache[key] = CacheEntry(flights: flights, timestamp: Date())
    }
    
    // MARK: - Clear cache
    
    func clear() {
        flightsEntry = nil
        searchCache.removeAll()
    }
}
