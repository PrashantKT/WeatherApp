//
//  MainScreen.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import SwiftUI

struct MainScreen: View {
    
    @StateObject private var vm =  MainScreenViewModel()
    @State private var isAnimating = false
    
    var body: some View {
        TabView(selection:$vm.currentTab) {
            LocationsView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Locations")
                }
            WeatherView()
                .tabItem {
                    Image(systemName: "smoke.fill")
                    Text("Weather")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            
        }
        .tint(.mainTint)
    }
}

#Preview {
    MainScreen()
}
