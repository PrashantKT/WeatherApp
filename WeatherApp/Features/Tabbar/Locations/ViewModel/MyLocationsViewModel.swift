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
class MyLocationsViewModel: ObservableObject {
    
    @Published var locationSearch = ""
    @Published var searchList = [SearchedLocationModel]()
    
    @Published var isFetchingCurrentLocation = false
    @Published var isNeedToAskLocationPermission = false
    @Published var askUserToChangeLocationPermission = false
    
    @Published var isShowingWeatherScreen = false
    @Published var locationSelected: SavedLocation?
    @Published var showError: AppError?

    private var cancellables = Set<AnyCancellable>()
    private var locationManager = LocationManager()
    
    var saveLocation = UserDefaultSavedLocation()
    
    init() {
        setupBindings()
        checkLocationPermissionStatus()
    }

    var isSearching: Bool {
        !locationSearch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isSavedLocationAvailable: Bool {
        saveLocation.savedLocations.isEmpty
    }
    
    var isMyLocationAdded: Bool {
        guard let currentLocation = locationManager.userLocation else {
            return false
        }
        let radius: CLLocationDistance = 300
        return saveLocation.savedLocations.contains { location in
            let locationCoordinate = CLLocation(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
            return currentLocation.distance(from: locationCoordinate) <= radius
        }
    }
    
    private func setupBindings() {
        $locationSearch
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .dropFirst()
            .sink { [weak self] value in
                self?.handleSearchInput(value)
            }
            .store(in: &cancellables)
        
        locationManager.$userLocation
            .sink { [weak self] location in
                self?.handleUserLocationUpdate(location)
            }
            .store(in: &cancellables)
    }
    
    private func handleSearchInput(_ value: String) {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        searchList = trimmedValue.isEmpty ? [] : (0..<Int.random(in: 2...10)).map { _ in SearchedLocationModel(locationName: UUID().uuidString) }
    }
    
    private func handleUserLocationUpdate(_ location: CLLocation?) {
        Task {
            if let location = location {
                if isFetchingCurrentLocation {
                    await showWeatherScreenFor(location: location.coordinate)
                    isFetchingCurrentLocation = false
                }
            } else if isFetchingCurrentLocation {
                isFetchingCurrentLocation = false
                showError = .locationPermission
            }
        }
    }
    
    private func checkLocationPermissionStatus() {
        let status = locationManager.manager.authorizationStatus
        switch status {
        case .notDetermined:
            isNeedToAskLocationPermission = true
        case .restricted, .denied:
            askUserToChangeLocationPermission = true
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            isNeedToAskLocationPermission = false
        @unknown default:
            isNeedToAskLocationPermission = false
        }
    }
    
    func fetchCurrentLocation() async {
        if let currentLocation = locationManager.userLocation {
            isFetchingCurrentLocation = false
            await showWeatherScreenFor(location: currentLocation.coordinate)
        } else {
            locationManager.askForLocationPermission()
            checkLocationPermissionStatus()
            
            if askUserToChangeLocationPermission {
                showError = .locationPermission
                isFetchingCurrentLocation = false
            }
        }
    }
    
    private func showWeatherScreenFor(location: CLLocationCoordinate2D) async {
        let pm = try? await CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)).first
        let locationName = "\(pm?.locality ?? ""), \(pm?.country ?? "")"
        await MainActor.run {
            self.locationSelected = SavedLocation(lat: location.latitude, lon: location.longitude, originalName: locationName)
            self.isShowingWeatherScreen = true
        }
    }
    
    func addUserLocation() {
        if let locationSelected {
            try? saveLocation.saveLocation(locationSelected)
        }
    }
}

/*
 
 
 PLAN
 
 1) User location accesss ---> If it is not detrmined - FALSE
 2) User location access --> if restrected - FALSE
 3) User location accesss -> accessible --> Check radius --> TRUE / FALSAE
 
 
 
 */
