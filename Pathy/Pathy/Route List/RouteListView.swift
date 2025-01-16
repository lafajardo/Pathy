//
//  RouteListView.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/24/24.
//

import SwiftUI

struct RouteListView: View {
    @StateObject private var vm = RouteListViewModel()
    @State private var showingRouteInProgressScreen = false
    
    var body: some View {
        NavigationStack {
            List {
                switch vm.state {
                case .idle:
                    idleView
                case .loading:
                    loadingView
                case .success(routes: let routes):
                    routesView(routes: routes)
                case .error(message: let message):
                    errorView(message: message)
                }
            }
            .navigationTitle("Pathy")
            .navigationBarTitleDisplayMode(.inline)
            .listRowSpacing(12)
            .toolbar {
                Button {
                    showingRouteInProgressScreen.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .fullScreenCover(isPresented: $showingRouteInProgressScreen) {} content: {
                RouteInProgressView()
            }
            .refreshable {
                await vm.fetchAllRoutes()
            }
            .task {
                await vm.fetchAllRoutes()
            }
        }
    }
    
    @ViewBuilder
    private var idleView: some View {
        ContentUnavailableView("Pull down to make a request", systemImage: "map.circle")
    }
    
    @ViewBuilder
    private var loadingView: some View {
        ContentUnavailableView("Loading...", systemImage: "arrow.triangle.2.circlepath")
    }
    
    @ViewBuilder
    private func routesView(routes: [Route]) -> some View {
        if routes.isEmpty {
            ContentUnavailableView("There are no routes to display", systemImage: "mappin.slash.circle")
        } else {
            ForEach(routes) { route in
                ZStack {
                    RouteListItemView(route: route)
                        .listRowInsets(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    await vm.delete(route: route)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    NavigationLink(destination: RouteDetailsView(route: route)) {
                        EmptyView()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        ContentUnavailableView(message, systemImage: "exclamationmark.circle")
    }
}

#Preview {
    RouteListView()
}
