//
//  RouteInProgressMapView.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/16/24.
//

import MapKit
import SwiftUI

struct RouteMapView: View {
    let coordinates: [CLLocationCoordinate2D]

    var body: some View {
        Map {
            if !coordinates.isEmpty {
                MapPolyline(coordinates: coordinates)
                    .stroke(.blue, lineWidth: 4.0)
            }
        }
    }
}

#Preview {
    RouteMapView(coordinates: [])
}
