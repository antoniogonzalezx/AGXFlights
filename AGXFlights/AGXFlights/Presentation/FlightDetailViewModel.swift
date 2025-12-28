//
//  FlightDetailViewModel.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 28/12/25.
//

import Foundation
import Combine

struct FlightRoute {
    let origin: Airport
    let destination: Airport
}

@MainActor
final class FlightDetailViewModel: ObservableObject {
    
    @Published private(set) var flight: Flight
    @Published private(set) var flightRoute: FlightRoute?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var imageURL: URL?
    
    private let hexDBService: HexDBServiceProtocol
    
    init(flight: Flight, hexDBService: HexDBServiceProtocol) {
        self.flight = flight
        self.hexDBService = hexDBService
    }
    
    func load() {
        imageURL = hexDBService.image(icao: flight.id)
        
        guard let callsign = flight.callsign, !callsign.isEmpty else { return }
        
        Task {
            isLoading = true
            
            // 1. Fetch route
            guard let route = try await hexDBService.fetchRoute(callSign: callsign) else {
                isLoading = false
                return
            }
            
            // 2. Fetch airports
            async let origin = hexDBService.fetchAirport(icao: route.origin)
            async let destination = hexDBService.fetchAirport(icao: route.destination)
            
            if let origin = try? await origin,
               let destination = try? await destination {
                flightRoute = FlightRoute(
                    origin: origin,
                    destination: destination
                )
            }
            
            isLoading = false
        }
    }
}
