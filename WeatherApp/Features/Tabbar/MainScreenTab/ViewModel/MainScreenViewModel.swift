//
//  MainScreenViewModel.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import Foundation
import CoreLocation
import SwiftUI

class MainScreenViewModel:ObservableObject {

    enum Tab:CaseIterable {
        case myLocation
        case weather
        case settings
        
        var label:String {
            switch self {
            case .myLocation:
                "Location"
            case .weather:
                "Weather"
            case .settings:
                "Settings"
            }
        }
        var image:Image {
            switch self {
            case .myLocation:
                Image(systemName: "map.fill")
            case .weather:
                Image(systemName: "smoke.fill")
            case .settings:
                Image(systemName: "gearshape")

            }
        }
    }
    
    @Published var currentTab:Tab = .weather
    
    //TODO: Save location and show it as default
    @Published var currentLocation = CLLocationCoordinate2D(latitude: 21.6422, longitude: 69.6093)
    
   
}

