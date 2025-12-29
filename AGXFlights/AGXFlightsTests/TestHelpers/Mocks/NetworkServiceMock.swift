//
//  NetworkServiceMock.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 29/12/25.
//

import Foundation
@testable import AGXFlights

@MainActor
final class NetworkServiceMock: NetworkServiceProtocol {
    var fetchResult: [Flight] = []
    var fetchCallCount = 0
    var shouldThrowError = false
    var error: Error = NetworkError.invalidResponse
    
    func fetchFlights() async throws -> [Flight] {
        fetchCallCount += 1
        if shouldThrowError { throw error }
        return fetchResult
    }
}
