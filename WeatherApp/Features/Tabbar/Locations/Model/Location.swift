//
//  Location.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import Foundation
import CoreLocation


struct Location:Identifiable,Hashable {
  
    
    var id: Float {
        return Float(coordinates.latitude)
    }
    
    
    var locationName:String
    var temp:String
    var condition:String
    var iconName:String
    var coordinates:CLLocationCoordinate2D
    
    init(locationName: String, temp: String = "", condition: String = "" , iconName: String = "", coordinates: CLLocationCoordinate2D = .init(latitude: 32, longitude: -142)) {
        self.locationName = locationName
        self.temp = temp
        self.condition = condition
        self.iconName = iconName
        self.coordinates = coordinates
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.coordinates.latitude == rhs.coordinates.latitude && lhs.coordinates.longitude == rhs.coordinates.longitude
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinates.latitude)
    }
    
}


extension Location {
    
    static let tempData: [Location] = [
        Location(locationName: "New York", temp: "20°C", condition: "Clear", iconName: "sun.max.fill",coordinates: .init(latitude: 72.5151, longitude: 65.51561)),
        Location(locationName: "London", temp: "15°C", condition: "Cloudy", iconName: "cloud.fill",coordinates:.init(latitude: 72.5151, longitude: 65.51561)),
        Location(locationName: "Tokyo", temp: "22°C", condition: "Rain", iconName: "cloud.rain.fill",coordinates:.init(latitude: 72.5151, longitude: 65.51561)),
        Location(locationName: "Paris", temp: "18°C", condition: "Partly Cloudy", iconName: "cloud.sun.fill",coordinates:.init(latitude: 72.5151, longitude: 65.51561)),
        // Add more locations as needed
    ]

}
