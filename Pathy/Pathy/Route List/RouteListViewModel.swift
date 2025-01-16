//
//  RouteListViewModel.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/24/24.
//

import Foundation

enum RouteListLoadingState {
    case idle
    case loading
    case success(routes: [Route])
    case error(message: String)
}

@MainActor
class RouteListViewModel: ObservableObject {
    @Published var state: RouteListLoadingState = .idle

    func fetchAllRoutes() async {
        do {
            state = .loading
            let routes = try await RoutesService.fetchAllRoutes()
            let sortedRoutes = routes.sorted { $0.startTime > $1.startTime }
            state = .success(routes: sortedRoutes)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    func delete(route: Route) async {
        do {
            state = .loading
            try await RoutesService.delete(route: route)
            await fetchAllRoutes()
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
}
