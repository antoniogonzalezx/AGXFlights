//
//  FlightListViewModel.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation
import Combine

@MainActor
class FlightListViewModel: ObservableObject {
    @Published private(set) var flights: [Flight] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var lastUpdated: Date?
    @Published var searchText = ""
    
    private let searchFlightsUseCase: SearchFlightsUseCaseProtocol
    private let flightRepository: FlightRepositoryProtocol
    private var searchTask: Task<Void, Never>?
    
    init(
        searchFlightsUseCase: SearchFlightsUseCaseProtocol,
        flightRepository: FlightRepositoryProtocol
    ) {
        self.searchFlightsUseCase = searchFlightsUseCase
        self.flightRepository = flightRepository
    }
    
    func loadFlights() {
        searchTask?.cancel()
        
        searchTask = Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let result = try await flightRepository.fetchAllFlights()
                guard !Task.isCancelled else { return }
                flights = result.flights
                if !result.fromCache {
                    lastUpdated = Date()
                }
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func searchFlights() {
        searchTask?.cancel()
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            flights = []
            return
        }
        
        searchTask = Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let result = try await searchFlightsUseCase.search(query: query)
                guard !Task.isCancelled else { return }
                flights = result.flights
                if !result.fromCache {
                    lastUpdated = Date()
                }
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = error.localizedDescription
                flights = []
            }
            
            isLoading = false
        }
    }
    
    func clear() {
        searchTask?.cancel()
        searchText = ""
        errorMessage = nil
        loadFlights()
    }
    
    func refresh() async {
        await flightRepository.clearCache()
        
        errorMessage = nil
        
        do {
            let result = try await flightRepository.fetchAllFlights()
            flights = result.flights
            lastUpdated = Date()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func refreshFlight(id: String) async -> Flight? {
        await flightRepository.clearCache()
        
        do {
            let result = try await flightRepository.fetchAllFlights()
            flights = result.flights
            lastUpdated = Date()
            return result.flights.first { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
