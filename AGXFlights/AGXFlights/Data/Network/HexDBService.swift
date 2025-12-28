//
//  HexDBService.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 28/12/25.
//

import Foundation

protocol HexDBServiceProtocol: Sendable {
    func fetchRoute(callSign: String) async throws -> Route?
    func fetchAirport(icao: String) async throws -> Airport?
    func image(icao: String) -> URL?
}

struct Route: Sendable {
    let origin: String
    let destination: String
}

struct Airport: Sendable {
    let iata: String?
    let name: String
    let country: String
}

final class HexDBService: HexDBServiceProtocol, Sendable {
    private let session: URLSession
    private let baseURL: String = "https://hexdb.io"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRoute(callSign: String) async throws -> Route? {
        let formattedCallSign = callSign.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: "\(baseURL)/api/v1/route/icao/\(formattedCallSign)") else {
            throw NetworkError.invalidURL
        }
        
        guard let data = try await fetchData(from: url) else { return nil }
        
        let response = try JSONDecoder().decode(HexDBRouteResponse.self, from: data)
        
        guard let route = response.route else { return nil }
        
        let parts = route.split(separator: "-")
        guard parts.count == 2 else { return nil }
        
        return Route(
            origin: String(parts[0]),
            destination: String(parts[1])
        )
    }
    
    func fetchAirport(icao: String) async throws -> Airport? {
        guard let url = URL(string: "\(baseURL)/api/v1/airport/icao/\(icao)") else {
            throw NetworkError.invalidURL
        }
        
        guard let data = try await fetchData(from: url) else { return nil }
        
        let response = try JSONDecoder().decode(HexDBAirportResponse.self, from: data)
        
        return Airport(
            iata: response.iata,
            name: response.airport,
            country: response.countryCode
        )
    }
    
    func image(icao: String) -> URL? {
        URL(string: "\(baseURL)/hex-image?hex=\(icao)")
    }
    
    private func fetchData(from url: URL) async throws -> Data? {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }
        
        if httpResponse.statusCode == 404 {
            return nil
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
}
