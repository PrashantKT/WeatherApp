//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import Foundation
import CoreLocation

class LocationManager:NSObject, ObservableObject {
    
   
    @Published var userLocation:CLLocation?

    private (set) var manager = CLLocationManager()
    
     override init() {
         super.init()
        manager.delegate = self

    }
    
  
    func askForLocationPermission() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    
}

extension LocationManager:CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        userLocation = manager.location
        print("Location permission changed ")

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location Fetched \(locations)")
    }
}
