//
//  FlightDetailView.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import SwiftUI
import MapKit

struct FlightDetailView: View {
    let flight: Flight
    
    var body: some View {
        List {
            if let coordinate = flight.coordinate {
                Section {
                    FlightMapView(coordinate: coordinate, callSign: flight.displayCallsign)
                        .frame(height: 200)
                        .listRowInsets(EdgeInsets())
                }
            }
            Section("Details") {
                DetailRowView(icon: .globe, title: "Country", value: flight.originCountry)
                
                if let latitude = flight.latitude {
                    DetailRowView(icon: .location, title: "Latitude", value: String(format: "%.4f°", latitude))
                }
                
                if let longitude = flight.longitude {
                    DetailRowView(icon: .location, title: "Longitude", value: String(format: "%.4f°", longitude))
                }
                
                if let altitude = flight.altitude {
                    DetailRowView(icon: .altitude, title: "Altitude", value: String(format: "%.0f m", altitude))
                }
                
                if let velocity = flight.velocity {
                    DetailRowView(icon: .speed, title: "Velocity", value: String(format: "%.0f m/s", velocity))
                }
                
                if let time = flight.timePosition {
                    DetailRowView(icon: .clock, title: "Last Update", value: time.formatted(date: .abbreviated, time: .shortened))
                }
            }
        }
        .navigationTitle(flight.displayCallsign)
    }
}

struct DetailRowView: View {
    let icon: Icons
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 8) {
            icon.image
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            Text(title)
                .foregroundStyle(.secondary)
                .font(.subheadline)
            
            Text(value)
        }
    }
}

struct FlightMapView: View {
    let coordinate: CLLocationCoordinate2D
    let callSign: String
    
    private var camera: MapCamera {
        MapCamera(
            centerCoordinate: coordinate,
            distance: 500000
        )
    }
    
    var body: some View {
        Map(initialPosition: .camera(camera)) {
            Annotation(callSign, coordinate: coordinate) {
                Icons.airplanePath.image
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
        .mapStyle(.imagery)
        .disabled(true)
    }
}

#Preview {
    NavigationStack {
        FlightDetailView(flight: .flight1)
    }
}
