//
//  MainScreenViewModel.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import Foundation


class MainScreenViewModel:ObservableObject {

    enum Tab {
        case myLocation
        case weather
        case settings
    }
    
    @Published var currentTab:Tab = .myLocation
    
}

