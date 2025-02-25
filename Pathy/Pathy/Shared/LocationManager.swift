//
//  LocationManager.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/11/24.
//

import CoreLocation
class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var hasLocationAccess: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.startUpdatingLocation()
    }
    func showLocationPermissionDialog() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            hasLocationAccess = false
            print("DEBUG: Not determined")
        case .restricted:
            hasLocationAccess = false
            print("DEBUG: Restricted")
        case .denied:
            hasLocationAccess = false
            print("DEBUG: Denied")
        case .authorized:
            hasLocationAccess = true
            print("DEBUG: Auth")
        case .authorizedAlways:
            hasLocationAccess = true
            print("DEBUG: Aut always")
        case .authorizedWhenInUse:
            hasLocationAccess = true
            print("DEBUG: Auth when in use")
        @unknown default:
            hasLocationAccess = false
            //break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
    func startFetchingCurrentLocation() {
        manager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    func stopFetchingCurrentLocation(){
        manager.stopUpdatingLocation()
    }
}
