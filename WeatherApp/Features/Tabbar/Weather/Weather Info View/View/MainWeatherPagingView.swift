//
//  MainWeatherPagingView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 13/05/24.
//

import SwiftUI

struct MainWeatherPagingView: View {
    @EnvironmentObject var saveLocationManager:UserDefaultSavedLocation
    @Binding var currentTab:MainScreenViewModel.Tab
    var body: some View {
        if !saveLocationManager.savedLocations.isEmpty {
            ScrollView(.horizontal) {
                HStack(spacing:0) {
                    ForEach(saveLocationManager.savedLocations) {location in
                        WeatherInfoView(location: location,screenFlowType: .viewDetails)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
            .safeAreaPadding(.bottom)
//            .background(Color.red)
        } else {
            
            showContentUnavailableView(titel: "Let's fetch weather info ?", iconName: "target", desc: "Search any location or get your current weather data in location tab") {
                Button {
                    withAnimation(.snappy) {
                        currentTab = .myLocation
                    }
                } label: {
                    HStack {
                        Text("Go to Location")
                            .fontNunito(.semibold, size: 16)
                        
                    }
                    .padding(.horizontal,55)
                    .padding(.vertical,14)
                    .background(Color.mainTint, in:RoundedRectangle(cornerRadius: 8))
                    .foregroundStyle(.black)
                }
                
            }
            .background(Color.appBackground)
        }
    }
    
    private func showContentUnavailableView(titel:String,iconName:String,desc:String,@ViewBuilder action: () -> some View = { EmptyView() }) -> some View {
        ContentUnavailableView(label: {
            Label(
                title: { Text(titel).fontNunito(.regular, size: 22) },
                icon: { Image(systemName: iconName).foregroundStyle(.primary) }
            )
        }, description: {
            Text(desc)
                .padding(.top,8)
                .fontNunito(.light, size: 16)
        }, actions: action)
    }
    
}

#Preview {
    MainWeatherPagingView(currentTab: .constant(.myLocation))
        .environmentObject(UserDefaultSavedLocation())
}
