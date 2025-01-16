import SwiftUI

struct RouteDetailsView: View {
    @StateObject var vm: RouteDetailsViewModel
    
    init(route: Route) {
        self._vm = StateObject(wrappedValue: RouteDetailsViewModel(route: route))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: vm.route.type.systemImageName)
                        .padding(16)
                        .background(.background.secondary, in: Circle())
                    VStack(alignment: .leading) {
                        Text(vm.route.type.displayName)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text(vm.route.userName)
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                RouteMapView(coordinates: vm.route.coordinates)
                    .frame(height: 200)
                    .cornerRadius(20)
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                    GridRow {
                        GridItemView(label: "Duration", value: vm.route.formattedDuration)
                        GridItemView(label: "Avg Speed", value: vm.route.formattedAverageSpeed + " mph")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(.thickMaterial)
                    .cornerRadius(16)
                    GridRow {
                        GridItemView(label: "Total Distance", value: vm.route.formattedDistance + " mi")
                        GridItemView(label: "Net Distance", value: vm.route.formattedNetDistance + " mi")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(.background.secondary)
                    .cornerRadius(16)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Start")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/ .leading/*@END_MENU_TOKEN@*/)
                        HStack {
                            if let start = vm.start {
                                Text("\(start.streetNumber) \(start.streetName)")
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text(vm.route.formattedStartTime)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
                Divider()
                HStack {
                    VStack(alignment: .leading) {
                        Text("End")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        HStack {
                            if let start = vm.end {
                                Text("\(start.streetNumber) \(start.streetName)")
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text(vm.route.formattedEndTime)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(16)
            .navigationTitle(vm.route.formattedDate) // change this
        }
        .onAppear {
            vm.fetchCheckpoints()
        }
    }
}

struct GridItemView: View {
    var label: String
    var value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(value)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    NavigationStack {
        Text("yo")
            .navigationDestination(isPresented: .constant(true)) {
                RouteDetailsView(route: .bikeExample)
            }
    }
}
