
import SwiftUI

struct RouteInProgressView: View {
    @StateObject private var vm = RouteInProgressViewModel()
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            RouteMapView(coordinates: vm.coordinates)
                .ignoresSafeArea()
            RouteInProgressCardView(vm: vm, startStopSaveAction: startStopSaveAction)
                .padding(.horizontal, 16)
        }
        .onChange(of: locationManager.userLocation, initial: true) { _, newValue in
            withAnimation(.bouncy) {
                if let location = newValue {
                    vm.addLocationToRoute(location: location)
                }
            }
        }
        .overlay(alignment: .center) {
            RouteInProgressLoadingStateView(state: vm.loadingState)
        }
        .overlay(alignment: .topLeading) {
            Menu {
                Picker("Route Type", selection: $vm.routeType) {
                    ForEach(RouteType.allCases, id: \.rawValue) { type in
                        Label(type.rawValue.capitalized, systemImage: type.systemImageName)
                            .tag(type)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: vm.routeType.systemImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)

                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 8)
                }
                .padding(10)
                .background(.ultraThickMaterial, in: .rect(cornerRadius: 8))
            }
            .padding(.leading, 16)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                cancel()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .fontWeight(.semibold)
                    .padding(12)
                    .background(.ultraThickMaterial, in: .circle)
            }
            .padding(.trailing, 16)
        }
    }

    func cancel() {
        locationManager.stopFetchingCurrentLocation()
        dismiss()
    }

    private func startStopSaveAction() {
        withAnimation(.bouncy) {
            switch vm.routeState {
            case .notStarted:
                locationManager.startFetchingCurrentLocation()
                vm.startCollectingRoute()
            case .inProgress(let startTime):

                locationManager.stopFetchingCurrentLocation()
                vm.stopCollectingRoute(routeStartTime: startTime)
            case .ended(let startTime, let endTime):
                Task {
                    await vm.saveRoute(startTime: startTime, endTime: endTime)
                    if case .success = vm.loadingState {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RouteInProgressView().environmentObject(LocationManager())
}
