//
//  FlightDetailView.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import SwiftUI

struct FlightDetailView: View {
    @StateObject private var viewModel: FlightDetailViewModel
    
    init(viewModel: FlightDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            flightCardView
            Section("Details") {
                
            }
        }
        .navigationTitle(viewModel.flight.callsign ?? "Flight Details")
        .task {
            viewModel.load()
        }
    }
    
    @ViewBuilder
    private var flightCardView: some View {
        ZStack {
            VStack {
                flightImageView
                    .clipShape(.rect(corners: .concentric, isUniform: true))
                
                routeView
            }
        }
        .containerShape(
            .rect(cornerRadius: 24)
        )
    }
    
    @ViewBuilder
    private var flightImageView: some View {
        if let imageURL = viewModel.imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipped()
                    
                case .failure:
                    placeholder
                    
                case .empty:
                    placeholder
                        .redacted(reason: .placeholder)
                    
                @unknown default:
                    placeholder
                }
            }
            .task {
                print(imageURL)
            }
        } else {
            placeholder
        }
    }
    
    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.6), .cyan.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                Icons.airplane.image
                    .font(.system(size: 50))
                    .foregroundStyle(.white.opacity(0.9))
                
                Text(viewModel.flight.displayCallsign)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }
        }
        .frame(height: 180)
    }
    
    @ViewBuilder
    private var routeView: some View {
        if let route = viewModel.flightRoute {
            HStack {
                Icons.airplane.image
                
                VStack {
                    if let iata = route.origin.iata {
                        Text(iata)
                    }
                    Text(route.origin.name)
                }
                
                Spacer()
                
                VStack {
                    if let iata = route.destination.iata {
                        Text(iata)
                    }
                    Text(route.destination.name)
                }
                
                Icons.airplane.image
            }
        } else {
            HStack {
                Icons.airplane.image
                VStack {
                    Text("MAD")
                        .font(.largeTitle)
                    Text("Madrid")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Text("MAD")
                        .font(.largeTitle)
                    Text("Madrid")
                        .font(.caption)
                }
                Icons.airplane.image
            }
            .padding(.horizontal)
            .redacted(reason: .placeholder)
        }
    }
    
    private func airportView(icon: Icons, code: String, name: String) -> some View {
        HStack {
            icon.image
            
            VStack {
                Text(code)
                    .font(.title3.bold())
                
                Text(name)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: 120)
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

#Preview {
    NavigationStack {
        FlightDetailView(
            viewModel: FlightDetailViewModel(
                flight: .flight1,
                hexDBService: HexDBService()
            )
        )
    }
}
