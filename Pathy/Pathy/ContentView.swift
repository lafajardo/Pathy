//
//  ContentView.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        if locationManager.hasLocationAccess {
            RouteListView().environmentObject(locationManager)
        } else {
            RequestLocationView(locationManager: locationManager)
        }
    }
}

#Preview {
    ContentView()
}
