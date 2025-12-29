//
//  FlightCacheTests.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 29/12/25.
//

import Testing
@testable import AGXFlights

@MainActor
struct FlightCacheTests {
    
    @Test("Cache returns nil when it's empty")
    func cacheReturnsNilWhenEmpty() async {
        // given
        let cache = FlightCache()
        // then
        #expect(await cache.getFlights() == nil)
    }
    
    @Test("Cache stores and retrieves flights")
    func cacheStoresAndRetrievesFlights() async {
        // given
        let cache = FlightCache()
        let flights = [Flight.mock()]
        // when
        await cache.setFlights(flights)
        let result = await cache.getFlights()
        // then
        #expect(result?.count == 1)
        #expect(result?.first?.id == flights.first?.id)
    }
    
    @Test("Search cache returns flights for valid query")
    func searchCacheReturnsFlightsForValidQuery() async {
        // given
        let cache = FlightCache()
        let flights = [Flight.mock()]
        // when
        await cache.setSearchResults(flights, for: "spain")
        let result = await cache.getSearchResults(for: "spain")
        // then
        #expect(result?.count == 1)
    }
    
    @Test("Cache expires after interval")
    func cacheExpiresAfterInterval() async throws {
        // given
        let cache = FlightCache(interval: 0.1)
        let flights = [Flight.mock()]
        // when
        await cache.setFlights(flights)
        try await Task.sleep(for: .milliseconds(200))
        let result = await cache.getFlights()
        // then
        #expect(result == nil)
    }
    
    @Test("Cache is valid within interval")
    func cacheIsValidWithInterval() async throws {
        // given
        let cache = FlightCache(interval: 2.0)
        let flights = [Flight.mock()]
        // when
        await cache.setFlights(flights)
        try await Task.sleep(for: .milliseconds(100))
        let result = await cache.getFlights()
        // then
        #expect(result != nil)
        #expect(result?.count == 1)
    }
    
    @Test("Clear removes all cached data")
    func clearRemovesAllCachedData() async {
        // given
        let cache = FlightCache()
        let flights = [Flight.mock()]
        let query = "spain"
        // when
        await cache.setFlights(flights)
        await cache.setSearchResults(flights, for: query)
        // then
        #expect(await cache.getFlights() != nil)
        #expect(await cache.getSearchResults(for: query) != nil)
        // when
        await cache.clear()
        // then
        #expect(await cache.getFlights() == nil)
        #expect(await cache.getSearchResults(for: query) == nil)
    }
}
