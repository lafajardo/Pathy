//
//  RouteState.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/16/24.
//

import Foundation

enum RouteState: Equatable {
    case notStarted
    case inProgress(startTime: Date)
    case ended(startTime: Date, endTime: Date)
}
