//
//  FlightListRowView.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import SwiftUI

struct FlightListRowView: View {
    
    let flight: Flight
    
    var body: some View {
        HStack {
            Icons.airplaneList.image
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(flight.callsign ?? "UNKNOWN")
                    .font(.headline)
                
                Text(flight.originCountry)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    FlightListRowView(flight: .flight1)
}
