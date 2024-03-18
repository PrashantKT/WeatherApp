//
//  MyLocationsViewModel.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import SwiftUI
import CoreLocation
import Combine

@MainActor
class MyLocationsViewModel:ObservableObject {
    
    
    @Published var locations = [Location]()
    @Published var locationSearch = ""
    @Published var searchList = [Location]()
    
    @Published var isFetchingCurrentLocation = false
    @Published var isNeedToAskLocationPermission = false
    @Published var askUserToChangeLocationPermission = false
    
    @Published var showError:AppError?


    private var cancellables = Set<AnyCancellable>()
    
    var locationManager = LocationManager()
    
    var isSearching:Bool {
        !locationSearch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isSavedLocationAvailable:Bool {
        return !locations.isEmpty
    }
    
    var isMyLocationAdded:Bool {
        guard let currentLocation = locationManager.userLocation else {
            return false
        }
        let radius:CLLocationDistance = 300
        for location in locations {
            let locationCoordinate = CLLocation(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
            let distance = currentLocation.distance(from: locationCoordinate)
            
            if distance <= radius {
                return true
            }
        }
        return false
    }
    
    init()  {
        locationPermissionStatus()
        
        $locationSearch
            .receive(on: DispatchQueue.main)
            .sink { value in
                print("value \(value)")
                let valueUpdated = value.trimmingCharacters(in: .whitespacesAndNewlines)
                if !valueUpdated.isEmpty {
                    self.searchList = (0..<Int.random(in: 2...10)).map{_ in Location(locationName:UUID().uuidString)}
                } else {
                    self.searchList.removeAll()
                }
            }.store(in: &cancellables)
        
        
        
         locationManager
            .$userLocation
            .sink { location in
                DispatchQueue.main.async {
                    
                    if location == nil {
                        if self.isFetchingCurrentLocation {
                            self.isFetchingCurrentLocation = false
                            self.showError = .locationPermission
                        }
                      
                    } else {
                        if self.isFetchingCurrentLocation {
                            self.addUserLocation(location: location!.coordinate)
                            self.isFetchingCurrentLocation = false
                        }
                        
                    }
                }
        }.store(in: &cancellables)
    }
    
    
    func locationPermissionStatus() {
        switch locationManager.manager.authorizationStatus {
        case .notDetermined:
            isNeedToAskLocationPermission = true
        case .restricted:
            askUserToChangeLocationPermission = true
        case .denied:
            askUserToChangeLocationPermission = true
        case .authorizedAlways:
            isNeedToAskLocationPermission = false
        case .authorizedWhenInUse:
            isNeedToAskLocationPermission = false
        case .authorized:
            isNeedToAskLocationPermission = false
        @unknown default:
            isNeedToAskLocationPermission = false

        }
    }
   
    
    func fetchCurrentLocation() {
        if let currentLocation = locationManager.userLocation {
            self.addUserLocation(location: currentLocation.coordinate)
            self.isFetchingCurrentLocation = false

        } else {
            locationManager.askForLocationPermission()
            locationPermissionStatus()
            
            if askUserToChangeLocationPermission {
                print("Location permission requres to add current location")
                self.showError = .locationPermission
                isFetchingCurrentLocation = false
            }

        }

    }
    
    func addUserLocation(location:CLLocationCoordinate2D) {
        locations.append(.init(locationName: "User Location", temp: "0.0", condition: "Not Determined", iconName: "sun.fill", coordinates: location))
        
    }
    

}

/*
 
 
 PLAN
 
 1) User location accesss ---> If it is not detrmined - FALSE
 2) User location access --> if restrected - FALSE
 3) User location accesss -> accessible --> Check radius --> TRUE / FALSAE
 
 
 
 */
