//
//  FlightListView.swift
//  AGXFlights
//
//  Created by Antonio González Valdepeñas on 27/12/25.
//

import SwiftUI

struct FlightListView: View {
    @StateObject private var viewModel: FlightListViewModel
    
    init(viewModel: FlightListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Flights")
                .searchable(
                    text: $viewModel.searchText,
                    prompt: "Search by country or airline"
                )
                .onSubmit(of: .search) {
                    viewModel.searchFlights()
                }
                .onChange(of: viewModel.searchText) { _, newValue in
                    if newValue.isEmpty {
                        viewModel.clear()
                    }
                }
                .task {
                    viewModel.loadFlights()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.errorMessage {
            errorView(message: error)
        } else if viewModel.flights.isEmpty {
            emptyView
        } else {
            flightList
        }
    }
    
    private var loadingView: some View {
        List(0..<10, id: \.self) { _ in
            FlightListRowView(flight: .placeholder)
                .redacted(reason: .placeholder)
        }
    }
    
    private var flightList: some View {
        List(viewModel.flights) { flight in
            NavigationLink(value: flight) {
                FlightListRowView(flight: flight)
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .navigationDestination(for: Flight.self) { flight in
            FlightDetailView(flight: flight)
        }
    }
    
    private var emptyView: some View {
        ContentUnavailableView(
            "Search Flights",
            systemImage: Icons.airplane.rawValue,
            description: Text("Enter a country or airline code")
        )
    }
    
    private func errorView(message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: Icons.error.rawValue,
            description: Text(message)
        )
    }
}
