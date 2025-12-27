//
//  APIResponse.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import Foundation

struct APIResponse: Codable, Sendable {
    let time: Int
    let states: [[StateValue]]?
}

enum StateValue: Codable, Sendable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case nilValue
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self = .nilValue
            return
        }
        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
            return
        }
        if let value = try? container.decode(Int.self) {
            self = .int(value)
            return
        }
        if let value = try? container.decode(Double.self) {
            self = .double(value)
            return
        }
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }
        self = .nilValue
    }
    
    var stringValue: String? {
        if case .string(let value) = self { return value }
        return nil
    }
    
    var intValue: Int? {
        if case .int(let value) = self { return value }
        return nil
    }
    
    var doubleValue: Double? {
        switch self {
        case .double(let value): return value
        case .int(let value): return Double(value)
        default: return nil
        }
    }
}
