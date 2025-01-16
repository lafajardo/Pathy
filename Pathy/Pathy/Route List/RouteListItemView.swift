//
//  RouteListItemView.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/24/24.
//

import SwiftUI

struct RouteListItemView: View {
    let route: Route
    
    var body: some View {
        VStack(spacing: 12) {
            RouteMapView(coordinates: route.coordinates)
                .allowsHitTesting(false)
                .frame(height: 180)
                .cornerRadius(8)
                
            HStack {
                Image(systemName: route.type.systemImageName)
                    .padding(16)
                    .background(.regularMaterial, in: .circle)
                    
                VStack(alignment: .leading) {
                    Text(route.userName)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text(route.formattedDate)
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundStyle(.secondary)
                }
                    
                Spacer()
                    
                VStack(alignment: .trailing) {
                    Text(route.formattedDistance)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text(route.formattedDuration)
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    List {
        RouteListItemView(route: .walkExample)
    }
}
