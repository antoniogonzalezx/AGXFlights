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
    @Published var searchText = ""
    
    private let searchFlightsUseCase: SearchFlightsUseCaseProtocol
    private var searchTask: Task<Void, Never>?
    
    init(searchFlightsUseCase: SearchFlightsUseCaseProtocol) {
        self.searchFlightsUseCase = searchFlightsUseCase
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
                let results = try await searchFlightsUseCase.search(query: query)
                guard !Task.isCancelled else { return }
                flights = results
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
        flights = []
        errorMessage = nil
    }
}

