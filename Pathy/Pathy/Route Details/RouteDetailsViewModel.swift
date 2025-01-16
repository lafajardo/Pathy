import CoreLocation
import Foundation

struct RouteDetailsCheckpoint {
    let time: String
    let streetNumber: String
    let streetName: String
}

@MainActor
class RouteDetailsViewModel: ObservableObject {
    let route: Route

    @Published var start: RouteDetailsCheckpoint?
    @Published var end: RouteDetailsCheckpoint?

    init(route: Route) {
        self.route = route
    }

    func fetchCheckpoints() {
        guard let firstPoint = route.routePoints.first, let endPoint = route.routePoints.last else {
            return
        }

        buildCheckpoint(for: firstPoint) { checkpoint in
            self.start = checkpoint
        }

        buildCheckpoint(for: endPoint) { checkpoint in
            self.end = checkpoint
        }
    }

    private func buildCheckpoint(for point: RoutePoint, completion: @escaping (RouteDetailsCheckpoint?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            if let streetNumber = placemark.subThoroughfare,
               let streetName = placemark.thoroughfare
            {
                let time = ISO8601DateFormatter().string(from: point.timestamp)
                let checkpoint = RouteDetailsCheckpoint(time: time, streetNumber: streetNumber, streetName: streetName)
                completion(checkpoint)
            } else {
                completion(nil)
            }
        }
    }
}
