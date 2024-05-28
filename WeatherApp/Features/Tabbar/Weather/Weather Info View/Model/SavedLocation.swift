//
//  SavedLocation.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 13/05/24.
//

import Foundation
import CoreLocation

struct SavedLocation :Codable,Identifiable {
    var id:UUID = UUID()
    var lat:Double
    var lon:Double
    var originalName:String
    var userSavedName:String?
    
    
    var coordinates:CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
