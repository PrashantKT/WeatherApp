//
//  LocationRepo.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 15/05/24.
//

import Foundation

protocol LocationRepo {
    var savedLocations : [SavedLocation] {get set}

    func saveLocation(_ location:SavedLocation) throws -> [SavedLocation]
    func deleteLocation(_ location:SavedLocation)
    func fetchLocations() -> [SavedLocation]
    
}


class UserDefaultSavedLocation:ObservableObject, LocationRepo {
//    static let shared = UserDefaultSavedLocation()
    static let key = "SavedLocation"
    
    init() {
        
       savedLocations =  fetchLocations()
        #if DEBUG
            addFakeLocations()
        #endif
    }
    
    @Published var savedLocations = [SavedLocation]()
    
    @discardableResult
    func saveLocation(_ location: SavedLocation) throws -> [SavedLocation] {
        var locations = fetchLocations()
        locations.insert(location, at: 0)
        try writeDataPersistence(locations: locations)
        savedLocations = locations
        return locations
    }
    
    func deleteLocation(_ location: SavedLocation) {
        var locations = fetchLocations()
        locations.removeAll(where: {$0.id == location.id})
        try? writeDataPersistence(locations: locations)
        savedLocations = locations
    }
    
    func fetchLocations() -> [SavedLocation] {
        if let data = UserDefaults.standard.object(forKey: UserDefaultSavedLocation.key) as? Data,
           let obj = try? JSONDecoder().decode([SavedLocation].self, from: data) {
            return obj
        }
        return  []
    }
    
    private func writeDataPersistence(locations:[SavedLocation]) throws {
        let data = try JSONEncoder().encode(locations)
        UserDefaults.standard.set(data, forKey: UserDefaultSavedLocation.key)

    }
    
    private func addFakeLocations() {
        let fakeLocations = [
            SavedLocation(lat: 37.7749, lon: -122.4194, originalName: "San Francisco", userSavedName: "SF"),
            SavedLocation(lat: 34.0522, lon: -118.2437, originalName: "Los Angeles", userSavedName: "LA"),
            SavedLocation(lat: 40.7128, lon: -74.0060, originalName: "New York", userSavedName: "NYC"),
            SavedLocation(lat: 51.5074, lon: -0.1278, originalName: "London", userSavedName: "LDN"),
            SavedLocation(lat: 48.8566, lon: 2.3522, originalName: "Paris", userSavedName: "Paris"),
            SavedLocation(lat: 35.6895, lon: 139.6917, originalName: "Tokyo", userSavedName: "Tokyo"),
            SavedLocation(lat: -33.8688, lon: 151.2093, originalName: "Sydney", userSavedName: "Sydney"),
            SavedLocation(lat: 55.7558, lon: 37.6176, originalName: "Moscow", userSavedName: "Moscow"),
            SavedLocation(lat: 39.9042, lon: 116.4074, originalName: "Beijing", userSavedName: "Beijing"),
            SavedLocation(lat: 19.0760, lon: 72.8777, originalName: "Mumbai", userSavedName: "Mumbai")
        ]
        self.savedLocations.append(contentsOf: fakeLocations)
    }
}

