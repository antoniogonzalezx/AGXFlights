# AGXFlights ✈️

A real-time flight tracking app for iOS.

## What does it do?

It consumes the [OpenSky Network API](https://openskynetwork.github.io/opensky-api/) to display flights currently in the air. You can search by country of origin (e.g., "Spain") or by flight code (e.g., "IBE" for Iberia).

## Why this API?

I chose OpenSky because:
- It's public and free (no API key required)
- It offers real-time data
- It has enough complexity to demonstrate handling heterogeneous data (the response comes as arrays of mixed values, not nice JSON objects)

The endpoint I use is `https://opensky-network.org/api/states/all` which returns all active flights at that moment.

## Architecture

I followed a fairly classic layered architecture:

```
Presentation  →  Domain  →  Data
(SwiftUI)       (UseCases)   (Repository, Cache, Network)
```

The idea is that each layer only knows the one below through protocols. This makes it very easy to test (you can inject mocks) and maintain.

### Why not pure MVVM?

Technically it's MVVM in the presentation layer (the ViewModel talks to the UseCase), but I preferred having an explicit UseCase in Domain because:
- It makes clear what the business logic is
- If tomorrow there are more operations, each one will get its own UseCase
- It's easier to test

## Technical decisions

### The Cache

The cache works like this:

1. I check if I have that exact search cached
2. If not, I check if I have all flights cached and filter locally
3. If not, I go to the network, cache everything, and filter

Why this flow? Because the API I used doesn't have a search endpoint. It always returns ALL active flights. So if I already have the data, filtering locally is instant and saves me a network call.

The cache uses a Swift **actor**. This guarantees no race conditions without having to deal with manual locks. It's one of the things I like most about modern Swift.

The time interval is set to 2 minutes. Which I consider a reasonable time to keep the data "real-time".

### Search cancellation

Every time the user types something new, I cancel the previous search:

```swift
func searchFlights() {
    searchTask?.cancel()  // Previous search is cancelled
    
    searchTask = Task {
        // ...
        guard !Task.isCancelled else { return }  // Just in case
        flights = results
    }
}
```

We need to add `guard !Task.isCancelled`, which is important because even if you cancel the Task, code that's already running continues until it explicitly checks if it was cancelled. Without this, you could see results from old searches appearing after newer ones.

### Dependency injection

I use a simple `DependencyManager`. No external frameworks. For an app this size, having constructor-injectable dependencies is enough. This allows me to inject mocks in tests without any issues.

If the app becomes bigger in the future, we may need a dependency injection framework such as **Swinject** or **Factory**

## Tests

I've covered all three layers:

- **Domain**: `SearchFlightsUseCaseTests` - verifies the use case delegates correctly
- **Data**: `FlightCacheTests` + `FlightRepositoryTests` - verify TTL, cache hit/miss, local filtering
- **Presentation**: `FlightListViewModelTests` - verifies ViewModel states

Mocks are in `TestHelpers/Mocks/` and there's a `Flight.mock()` extension to easily create test flights.

One thing that took me a bit was testing the ViewModel. Since the methods launch internal Tasks, you need to wait a little (`Task.sleep`) before verifying state. It's not the most elegant solution, but it works and it's clear.

## Future improvements

### 1. **Map with flights**
The API returns coordinates. It would have been cool to show the planes on a MapKit with their real positions. You could even animate the movement by refreshing every X seconds.

### 2. **Enriched detail with another API**
OpenSky gives basic data, but there are APIs like [hexdb.io](https://hexdb.io) that from the flight code give you the model of the aircraft, airline, some details about the route... The detail screen would have been much more complete.

### 3. **Advanced filters**
Filter by minimum altitude, speed, only flights from a specific airline... The logic is already prepared for this as filtering is local, only the UI would be missing.

### 4. **Cache persistence**
Right now the cache is in memory. If you close the app, you lose everything. With UserDefaults or a JSON file it would be easy to persist it.

### 5. **Pull to refresh**
To manually refresh the list. Currently it only refreshes when you search or when the cache expires.

## Project structure

```
AGXFlights/
├── App/
│   ├── AGXFlightsApp.swift      # Entry point
│   └── DependencyManager.swift  # Dependency injection
├── Domain/
│   ├── Entities/Flight.swift    # Main model
│   ├── Repositories/            # Protocols
│   └── UseCases/                # Business logic
├── Data/
│   ├── Cache/FlightCache.swift  # Cache actor
│   ├── Network/                 # Network service
│   ├── NetworkModels/           # DTOs and mapping
│   └── Repositories/            # Implementation
├── Presentation/
│   ├── FlightListView.swift     # Main screen
│   ├── FlightListViewModel.swift
│   ├── FlightListRowView.swift
│   └── FlightDetailView.swift   # Detail screen
└── Resources/
    └── Icons.swift              # Centralized SF Symbols
```

## Author

Antonio González Valdepeñas
https://www.linkedin.com/in/antoniogonzalezvaldepenas
