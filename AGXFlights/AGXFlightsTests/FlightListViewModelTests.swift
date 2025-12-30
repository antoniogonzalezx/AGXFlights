//
//  FlightListViewModelTests.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 29/12/25.
//

import Testing
@testable import AGXFlights

@MainActor
struct FlightListViewModelTests {
    
    @Test("Load flights updates flights array")
    func loadFlightsUpdatesFlightsArray() async throws {
        // given
        let useCase = SearchFlightsUseCaseMock()
        let repository = FlightRepositoryMock()
        repository.fetchAllResult = [Flight.mock()]
        let viewModel = FlightListViewModel(
            searchFlightsUseCase: useCase,
            flightRepository: repository
        )
        // when
        viewModel.loadFlights()
        try await Task.sleep(for: .milliseconds(50))
        //then
        #expect(viewModel.flights.count == 1)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("Load flights shows error message on failure")
    func loadFlightsShowsErrorMessageOnFailure() async throws {
        // given
        let useCase = SearchFlightsUseCaseMock()
        let repository = FlightRepositoryMock()
        repository.shouldThrowError = true
        let viewModel = FlightListViewModel(
            searchFlightsUseCase: useCase,
            flightRepository: repository
        )
        // when
        viewModel.loadFlights()
        try await Task.sleep(for: .milliseconds(50))
        // then
        #expect(viewModel.flights.isEmpty)
        #expect(viewModel.errorMessage != nil)
    }
    
    @Test("Search updates flights array with results")
    func searchUpdatesFlightsArrayWithResults() async throws {
        // given
        let useCase = SearchFlightsUseCaseMock()
        useCase.searchResult = [Flight.mock()]
        let repository = FlightRepositoryMock()
        let viewModel = FlightListViewModel(
            searchFlightsUseCase: useCase,
            flightRepository: repository
        )
        viewModel.searchText = "spain"
        // when
        viewModel.searchFlights()
        try await Task.sleep(for: .milliseconds(50))
        // then
        #expect(viewModel.flights.count == 1)
        #expect(viewModel.errorMessage == nil)
        #expect(useCase.searchCallCount == 1)
    }
    
    @Test("Clear resets search text and reload flights")
    func clearResetsSearchTextAndReloadsFlights() async throws {
        // given
        let useCase = SearchFlightsUseCaseMock()
        let repository = FlightRepositoryMock()
        repository.fetchAllResult = [Flight.mock()]
        let viewModel = FlightListViewModel(
            searchFlightsUseCase: useCase,
            flightRepository: repository
        )
        viewModel.searchText = "spain"
        //when
        viewModel.clear()
        try await Task.sleep(for: .milliseconds(50))
        // then
        #expect(viewModel.searchText.isEmpty)
        #expect(repository.fetchAllCallCount == 1)
    }
    
    @Test("Refresh clears cache and reloads flights")
    func refreshClearsCacheAndReloadsFlights() async throws {
        // given
        let useCase = SearchFlightsUseCaseMock()
        let repository = FlightRepositoryMock()
        repository.fetchAllResult = [Flight.mock(), Flight.mock(id: "123456")]
        let viewModel = FlightListViewModel(
            searchFlightsUseCase: useCase,
            flightRepository: repository
        )
        // when
        await viewModel.refresh()
        // then
        #expect(repository.clearCacheCallCount == 1)
        #expect(repository.fetchAllCallCount == 1)
        #expect(viewModel.flights.count == 2)
        #expect(viewModel.errorMessage == nil)
    }
}
