//
//  LocationsView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import SwiftUI

struct LocationsView: View {
    @StateObject private var locationViewModel = MyLocationsViewModel()
    @FocusState var searchFocus:Bool
    @EnvironmentObject var saveLocation:UserDefaultSavedLocation
    var body: some View {
        VStack {
            
            searchBar
            .padding()
            
            if locationViewModel.isSearching || searchFocus {
                LocationSearchListView(focusState: $searchFocus)
                    .background(.clear)
                    .environmentObject(locationViewModel)
            } else {
                if !saveLocation.savedLocations.isEmpty {
                    locationsList
                } else {
                    contentUnAvailableViewForList
                }
            }
            
            Spacer()
            
        }
        .coverFullScreen()
        .background(.appBackground)
        .showErrorAlert(error: $locationViewModel.showError) {error in
            handleError(error: error)
        }.fullScreenCover(isPresented: $locationViewModel.isShowingWeatherScreen) {
            
            if let location = locationViewModel.locationSelected {
                WeatherInfoView.init(location: location) {
                    self.locationViewModel.addUserLocation()
                    locationViewModel.isShowingWeatherScreen = false
                }
            }
        }.onAppear {
            self.locationViewModel.saveLocation = saveLocation
        }
    }
    
    private var searchBar: some View {
           SearchBar(searchText: $locationViewModel.locationSearch, focusState: $searchFocus)
       }
    
    private var locationsList: some View {
        List {
            ForEach(locationViewModel.saveLocation.savedLocations) { location in
                HStack {
                    Text(location.originalName)
                }
                .frame(height: 110)
                .fontNunito(.semibold, size: 15)
                .listRowBackground(Color.red)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.appBackground.ignoresSafeArea())
    }
    
    @ViewBuilder
    private func handleError(error: AppError?) -> some View {
        switch error {
        case .locationPermission:
                VStack {
                    Button("Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Cancel", action: {})
                }
            
        case nil:
           EmptyView()
        }
    }
    
    @ViewBuilder
     var contentUnAvailableViewForList : some View {
         ContentUnavailableView(label: {
            Label(
                title: { Text("Add your locations").fontNunito(.regular, size: 22) },
                icon: { Image(systemName: "mappin").foregroundStyle(.primary) }
            )
        }, description: {
            Text("Use the searchbar to find and then add the location you need")
                .padding(.top,8)
                .fontNunito(.light, size: 16)
        })
    }
}


#Preview {
    LocationsView()
        .environmentObject(UserDefaultSavedLocation())
}
