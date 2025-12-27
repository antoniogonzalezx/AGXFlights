//
//  NetworkError.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidURL
    case decodingError
}
