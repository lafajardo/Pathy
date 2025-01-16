//
//  RouteService.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/24/24.
//

import Foundation

enum RoutesService {
    static func fetchAllRoutes() async throws -> [Route] {
        let url = URL(string: "https://learning.appteamcarolina.com/pathy/routes")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let routes = try decoder.decode([Route].self, from: data)
        return routes
    }
    
    static func create(route newRoute: NewRoute) async throws {
        let url = URL(string: "https://learning.appteamcarolina.com/pathy/routes")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(newRoute)
        let (_, response) = try await URLSession.shared.upload(for: request, from: data)
    }
    
    static func delete(route: Route) async throws {
        let url = URL(string: "https://learning.appteamcarolina.com/pathy/routes/\(route.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        // let (_, response) = try await URLSession.shared.data(for: request)
        _ = try await URLSession.shared.data(for: request)
    }
}
