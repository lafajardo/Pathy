//
//  RouteType.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/24/24.
//

import Foundation

enum RouteType: String, Codable, CaseIterable {
    case run
    case walk
    case hike
    case bike
    case other

    var rawValue: String {
        switch self {
        case .run: "run"
        case .walk: "walk"
        case .hike: "hike"
        case .bike: "bike"
        case .other: "other"
        }
    }

    var systemImageName: String {
        switch self {
        case .run: "figure.run"
        case .walk: "figure.walk"
        case .hike: "figure.hiking"
        case .bike: "bicycle"
        case .other: "point.topleft.down.curvedto.point.bottomright.up"
        }
    }

    var displayName: String {
        switch self {
        case .run: "Run"
        case .walk: "Walk"
        case .hike: "Hike"
        case .bike: "Bike Ride"
        case .other: "Route"
        }
    }
}
