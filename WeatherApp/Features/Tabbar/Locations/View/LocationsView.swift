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

    var body: some View {
        VStack {
            SearchBar(searchText: $locationViewModel.locationSearch,focusState: $searchFocus)
                .padding()
            
            if locationViewModel.isSearching || searchFocus {
                LocationSearchListView(focusState: $searchFocus)
                    .background(.clear)
                    .environmentObject(locationViewModel)
            } else {
                if !locationViewModel.locations.isEmpty {
                    
                    List {
                        ForEach(locationViewModel.locations,id: \.self) {location in
                            HStack {
                                Text(location.locationName)
                                Image(systemName: location.iconName)
                                    
                            }
                            .fontNunito(.semibold, size: 15)
                        }
                    }
                    
                } else {
                    contentUnAvailableViewForList
                }
            }
            
            Spacer()
            
        }
        .coverFullScreen()
        .background(.appBackground)
        .showErrorAlert(error: $locationViewModel.showError) {error in
            switch error {
            case .locationPermission:
                Button("Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                Button("Cancel") {
                    
                }
            case nil:
                EmptyView()
            }
        }.fullScreenCover(isPresented: $locationViewModel.isShowingWeatherScreen, content: {
            if let location = locationViewModel.locationSelected {
                WeatherInfoView.init(coordinates: location)
            }
        })
        
      

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
}
