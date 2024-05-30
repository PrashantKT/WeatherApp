//
//  LocationSearchListView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import SwiftUI

struct LocationSearchListView: View {
    @EnvironmentObject var locationViewModel:MyLocationsViewModel
    var focusState:FocusState<Bool>.Binding

    var body: some View {
        if !locationViewModel.searchList.isEmpty {
            locationSearchList
        } else {
            if !locationViewModel.isMyLocationAdded {
                askForAddCurrentLocation
            }
        }
    }
    
    var locationSearchList:some View {
        List {
            ForEach(0..<30) {_ in
                Text("Search Query result")
                    .fontNunito(.regular, size: 16)
                    .padding()
                    .frame(height: 35)
                

            }
            .listRowBackground(Color.clear)
            .listRowInsets(.none)
            .listRowSeparator(.hidden, edges: .all)

        }

        .listStyle(.plain)
    }
    
 
    @ViewBuilder
    var askForAddCurrentLocation : some View {
        
        showContentUnavailableView(titel: "Add your current location ?", iconName: "target", desc: "Let us determine your location so you don't waste time looking for it by yourself") {
            Button {
                    Task {
                        if !locationViewModel.isFetchingCurrentLocation {
                            locationViewModel.isFetchingCurrentLocation = true
                            focusState.wrappedValue = false
                            locationViewModel.locationSearch = ""
                            await locationViewModel.fetchCurrentLocation()
                        }
                    }
            } label: {
                HStack {
                    if !locationViewModel.isFetchingCurrentLocation {
                        Text("Find me")
                            .fontNunito(.semibold, size: 16)
                    } else {
                        ProgressView()
                            .tint(.font)
                    }
                }
                    .padding(.horizontal,55)
                    .padding(.vertical,14)
                    .background(Color.mainTint, in:RoundedRectangle(cornerRadius: 8))
                    .foregroundStyle(.font)
            }

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
    
    
//    @ViewBuilder
//    var askUserForPermissionChange : some View {
//        
//        showContentUnavailableView(titel: "Location is not available !!", iconName: "exclamationmark.triangle.fill", desc: "We couldn't determine your location , Please allow location permission ") {
//            Button {
//                withAnimation(.snappy) {
//                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
//                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//
//                }
//            } label: {
//                HStack {
//                    Text("Change permission")
//                        .fontNunito(.semibold, size: 16)
//                        .foregroundStyle(.white)
//                }
//                .padding(.horizontal,55)
//                .padding(.vertical,14)
//                .background(Color.red, in:RoundedRectangle(cornerRadius: 8))
//                .foregroundStyle(.font)
//            }
//
//        }
//        
//    }
}

#Preview {
    @FocusState var focus: Bool

    return LocationSearchListView(focusState: $focus)
        .background(Color.appBackground)
        .environmentObject(MyLocationsViewModel())
}
