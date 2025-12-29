//
//  SearchFlightsUseCase.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 29/12/25.
//

import Testing
@testable import AGXFlights

@MainActor
struct SearchFlightsUseCaseTests {
    
    @Test("Search with valid query returns flights")
    func searchWithValidQuery() async throws {
        // given
        let repository = FlightRepositoryMock()
        repository.searchResult = [Flight.mock()]
        let useCase = SearchFlightsUseCase(repository: repository)
        // when
        let result = try await useCase.search(query: "   spain  ")
        // then
        #expect(result.count == 1)
        #expect(repository.lastSearchQuery == "spain")
        #expect(result.first?.originCountry.uppercased() == "SPAIN")
        #expect(repository.searchCallCount == 1)
    }
    
    @Test("Search with empty query returns empty array without calling repository")
    func searchWithEmptyQuery() async throws {
        // given
        let repository = FlightRepositoryMock()
        let useCase = SearchFlightsUseCase(repository: repository)
        // when
        let result = try await useCase.search(query: " ")
        // then
        #expect(result.isEmpty)
        #expect(repository.searchCallCount == 0)
    }
}
