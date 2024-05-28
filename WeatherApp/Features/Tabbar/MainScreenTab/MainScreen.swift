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
//    @AppStorage("tapCount") private var tapCount = 0
    @StateObject private var saveManager = UserDefaultSavedLocation()

    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        ZStack {
            VStack(spacing:0) {
                TabView(selection:$vm.currentTab) {
                    LocationsView()
                        .tag(MainScreenViewModel.Tab.myLocation)
                    
                    MainWeatherPagingView(currentTab: $vm.currentTab)
                        .tag(MainScreenViewModel.Tab.weather)
                    
                    SettingsView()
                        .tag(MainScreenViewModel.Tab.settings)
                    
                }
            }
            VStack {
                customTabbar()
            }
            .coverFullScreen(alignment: .bottom)
        }
        .environmentObject(saveManager)

        
    }
    

    @ViewBuilder
    func customTabbar() -> some View {
        HStack {
            ForEach(MainScreenViewModel.Tab.allCases,id: \.self) { tab in
                
                VStack() {
                    if tab == .weather && vm.currentTab == .weather && !saveManager.savedLocations.isEmpty {
                        HStack {
                            ForEach(1...3,id:\.self) {_ in 
                                Circle()
                                    .frame(width:3)
                            }
                        }
                    } else {
                        VStack {
                            tab.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:25)
                                .foregroundStyle(vm.currentTab == tab ?  .mainTint : .gray)
                            
                            if vm.currentTab == tab {
                                Text(tab.label)
                                    .fontNunito(.medium, size: 12)
                                    .foregroundStyle(vm.currentTab == tab ?  .mainTint : .gray)

                            }
                        }
                    }

                }
                .coverH(alignment: .top)
                .frame(height: 60)

                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        vm.currentTab = tab
                    }
                }
                
            }
        }
        .padding(6)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 24))

        .padding(.horizontal,32)
    }
}

#Preview {
    MainScreen()
}
