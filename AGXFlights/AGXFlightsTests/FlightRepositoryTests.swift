//
//  FlightRepositoryTests.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 29/12/25.
//

import Testing
@testable import AGXFlights

@MainActor
struct FlightRepositoryTests {
    
    // MARK: - Search flights tests
    
    @Test("Search returns cached results if available")
    func searchReturnsCachedResults() async throws {
        // given
        let networkService = NetworkServiceMock()
        let cache = FlightCache()
        await cache.setSearchResults([Flight.mock()], for: "spain")
        let repository = FlightRepositoryImpl(networkService: networkService, cache: cache)
        // when
        let result = try await repository.searchFlights(query: "spain")
        // then
        #expect(result.flights.count == 1)
        #expect(result.fromCache == true)
        #expect(networkService.fetchCallCount == 0)
    }
    
    @Test("Search fetches results from network when cache is empty")
    func searchFetchesResultsFromNetwork() async throws {
        // given
        let networkService = NetworkServiceMock()
        networkService.flightsResult = [
            Flight.mock(id: "1", country: "Spain"),
            Flight.mock(id: "2", country: "France")
        ]
        let cache = FlightCache()
        let repository = FlightRepositoryImpl(networkService: networkService, cache: cache)
        //when
        let result = try await repository.searchFlights(query: "spain")
        // then
        #expect(result.flights.count == 1)
        #expect(result.fromCache == false)
        #expect(result.flights.first?.originCountry.uppercased() == "SPAIN")
        #expect(networkService.fetchCallCount == 1)
    }
    
    @Test("Search filters result by country and call sign", arguments: [
        "IBE",
        "Spain"
    ])
    func searchFiltersResultsByCountryAndCallSign(_ query: String) async throws {
        // given
        let networkService = NetworkServiceMock()
        networkService.flightsResult = [
            Flight.mock(id: "1", callsign: "Spain", country: "IBE123"),
            Flight.mock(id: "2", callsign: "France", country: "XYZ456"),
            Flight.mock(id: "3", callsign: "Spain", country: "IBE789")
        ]
        let cache = FlightCache()
        let repository = FlightRepositoryImpl(networkService: networkService, cache: cache)
        // when
        let result = try await repository.searchFlights(query: query)
        // then
        #expect(result.flights.count == 2)
        #expect(networkService.fetchCallCount == 1)
    }
    
    @Test("Search with empty query returns empty array")
    func searchWithEmptyQueryReturnsEmptyArray() async throws {
        // given
        let networkService = NetworkServiceMock()
        let cache = FlightCache()
        let repository = FlightRepositoryImpl(networkService: networkService, cache: cache)
        // when
        let result = try await repository.searchFlights(query: "")
        // then
        #expect(result.flights.isEmpty)
        #expect(result.fromCache == true)
        #expect(networkService.fetchCallCount == 0)
    }
    
    // MARK: - Fetch all flights tests
    
    @Test("Fetch all flights returns cached flights if available")
    func fetchAllFlightsReturnsCachedFlightsIfAvailable() async throws {
        // given
        let networkService = NetworkServiceMock()
        let cache = FlightCache()
        await cache.setFlights([
            Flight.mock(id: "1", country: "Spain"),
            Flight.mock(id: "2", country: "France")
        ])
        let repository = FlightRepositoryImpl(networkService: NetworkServiceMock(), cache: cache)
        // when
        let result = try await repository.fetchAllFlights()
        // then
        #expect(result.flights.count == 2)
        #expect(result.fromCache == true)
        #expect(networkService.fetchCallCount == 0)
    }
    
    @Test("Fetch all flights fetches from network when cache is empty")
    func fetchAllFlightsFetchesFromNetworkWhenCacheIsEmpty() async throws {
        // given
        let networkService = NetworkServiceMock()
        networkService.flightsResult = [
            Flight.mock(id: "1", country: "Spain"),
            Flight.mock(id: "2", country: "France")
            ]
        let cache = FlightCache()
        let repository = FlightRepositoryImpl(networkService: networkService, cache: cache)
        // when
        let result = try await repository.fetchAllFlights()
        //then
        #expect(result.flights.count == 2)
        #expect(result.fromCache == false)
        #expect(networkService.fetchCallCount == 1)
    }
}
