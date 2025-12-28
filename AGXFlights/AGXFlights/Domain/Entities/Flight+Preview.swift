//
//  Flight+Preview.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

#if DEBUG
import Foundation

extension Flight {
    static let flight1 = Flight(
        id: "abc123",
        callsign: "IBE098",
        originCountry: "Spain",
        timePosition: Date(),
        longitude: -12.3456,
        latitude: 34.5678,
        velocity: 872.45,
        altitude: 11234.56
    )
    
    static let flight2 = Flight(
        id: "xyz978",
        callsign: "IBE567",
        originCountry: "Indonesia",
        timePosition: Date(),
        longitude: -3.9091,
        latitude: -22.5678,
        velocity: 911.02,
        altitude: 12003
    )
    
    static let flight3 = Flight(
        id: "qwe456",
        callsign: "IBE987",
        originCountry: "Sri Lanka",
        timePosition: Date(),
        longitude: 31.9002,
        latitude: -9.8765,
        velocity: 453.33,
        altitude: 1039.22
    )
        
    static let flights: [Flight] = [flight1, flight2, flight3]
}
#endif
