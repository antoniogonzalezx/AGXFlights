//
//  DependencyManager.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

@MainActor
final class DependencyManager {
    static var shared = DependencyManager()
    
    private init() {}
    
    private lazy var cache = FlightCache()
    
    private lazy var networkService: NetworkServiceProtocol = NetworkService()
    
    private lazy var flightRepository: FlightRepositoryProtocol = FlightRepositoryImpl(
        networkService: networkService,
        cache: cache
    )
    
    private lazy var searchFlightsUseCase: SearchFlightsUseCaseProtocol = SearchFlightsUseCase(
        repository: flightRepository
    )
    
    func makeFlightListViewModel() -> FlightListViewModel {
        FlightListViewModel(
            searchFlightsUseCase: searchFlightsUseCase,
            flightRepository: flightRepository
        )
    }
}
