//
//  SearchViewModel.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/11/24.
//

import Foundation

import CoreLocation
import Foundation

enum RouteInProgressLoadingState {
    case idle
    case loading
    case success
    case error(message: String)
}

class RouteInProgressViewModel: ObservableObject {
    @Published var routeState: RouteState = .notStarted
    @Published var routeType: RouteType = .walk
    @Published var loadingState: RouteInProgressLoadingState = .idle
    
    @Published var locations: [CLLocation] = []
    
    func addLocationToRoute(location: CLLocation) {
        locations.append(location)
    }
    
    func startCollectingRoute() {
        let startTime = Date()
        routeState = .inProgress(startTime: startTime)
    }
    
    func stopCollectingRoute(routeStartTime: Date) {
        let endTime = Date()
        routeState = .ended(startTime: routeStartTime, endTime: endTime)
    }
    
    var coordinates: [CLLocationCoordinate2D] {
        return locations.map { $0.coordinate }
    }
    
    var distance: Double {
        guard var previousLocation = locations.first else { return 0 }
        var distanceMeters: Double = 0
        
        for location in locations {
            distanceMeters += location.distance(from: previousLocation)
            previousLocation = location
        }
        let distanceMeasurement = Measurement(value: distanceMeters, unit: UnitLength.meters)
        return distanceMeasurement.converted(to: .miles).value
    }
    
    var formattedDistance: String {
        String(format: "%.2f", distance)
    }
    
    func formatDuration(startTime: Date, endTime: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: startTime, to: endTime)!
    }
    
    func saveRoute(startTime: Date, endTime: Date) async {
        loadingState = .loading
        let routePoints = locations.map { location in
            RoutePoint(latitude: location.coordinate.latitude,
                       longitude: location.coordinate.longitude,
                       timestamp: location.timestamp)
        }
        let totalDistance = distance
        let userName = "Luis Fajardo"
        let newRoute = NewRoute(
            userName: userName,
            distance: totalDistance,
            startTime: startTime,
            endTime: endTime,
            type: routeType,
            routePoints: routePoints
        )

        do {
            try await RoutesService.create(route: newRoute)
            loadingState = .success
        } catch {
            loadingState = .error(message: error.localizedDescription)
        }
    }
}
