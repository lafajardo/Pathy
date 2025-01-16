//
//  RequestLocationView.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/11/24.
//

import SwiftUI

struct RequestLocationView: View {
    @ObservedObject var locationManager = LocationManager()

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 16) {
                Spacer()
                Text("Location Access")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Image(.dogwalk)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("Pathy uses your current location to record the path you take during a walk, run, or ride.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()
                Button(action: locationManager.showLocationPermissionDialog) {
                    Text("Allow Access")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.blue, in: .rect(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    RequestLocationView()
}
