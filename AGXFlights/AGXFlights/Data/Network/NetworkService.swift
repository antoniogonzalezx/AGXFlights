//
//  NetworkService.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

protocol NetworkServiceProtocol: Sendable {
    func fetchFlights() async throws -> [Flight]
}

final class NetworkService: NetworkServiceProtocol, Sendable {
    private let session: URLSession
    private let url = "https://opensky-network.org/api"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchFlights() async throws -> [Flight] {
        guard let url = URL(string: "\(self.url)/states/all") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        guard let states = apiResponse.states else { return [] }
        
        return states.compactMap { Flight(from: $0)}
    }
}
