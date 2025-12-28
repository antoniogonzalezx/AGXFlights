//
//  FlightDetailView.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import SwiftUI

struct FlightDetailView: View {
    let flight: Flight
    
    var body: some View {
        List {
            // TODO: Create detail view
        }
        .navigationTitle(flight.callsign ?? "Flight Details")
    }
}

#Preview {
    NavigationStack {
        FlightDetailView(flight: .flight1)
    }
}
