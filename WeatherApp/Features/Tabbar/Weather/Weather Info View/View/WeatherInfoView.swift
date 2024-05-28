//
//  WeatherInfoView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 15/03/24.
//

import SwiftUI
import CoreLocation

enum WeatherInfoViewMode {
    case addLocation
    case viewDetails
}
struct WeatherInfoView: View {
    @Environment(\.dismiss) var dismiss
    var location:SavedLocation
    var screenFlowType = WeatherInfoViewMode.addLocation

    var addButtonAction:(() -> ())? = nil
    
    @StateObject private var viewModel:WeatherInfoViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                WeatherInfoHeaderView().padding([.top,.horizontal]).environmentObject(viewModel)
                WeatherHourlyView(data: viewModel.prepareHourlyData())
                WeatherForecastListView(data: viewModel.prepareDailyData()).padding([.top,.horizontal]).environmentObject(viewModel)
                Divider()
                NavigationLink {
                    DateForecastView(dayRange: .days(number: 10))
                } label: {
                    buttonRowView(title: "10 Days Forecast")
                        .padding([.top,.horizontal])
                }
                .foregroundStyle(.primary)
            }
            .coverFullScreen()
            .background(Color.appBackground.ignoresSafeArea())
            .toolbar(content: toolBarButtons)
            .navigationTitle(location.originalName)
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await viewModel.fetchWeatherData(coordinates: location.coordinates)
        }
        .modifier(LoaderView(isLoading: $viewModel.isLoading))


    }
    
    @ToolbarContentBuilder
    func toolBarButtons() -> some ToolbarContent {
        if screenFlowType == .addLocation {
            ToolbarItem(placement: .topBarLeading) {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    addButtonAction?()
                } label: {
                    Text("Add")
                }
            }
        }
    }
    
    func buttonRowView(title:String) -> some View{
        HStack {
            WeatherIconView(systemIcon: Image(systemName: "list.clipboard"),systemIconColor: .primary,width: 55,overlayText: nil).padding([.vertical,.trailing],8)
            Text(title)
                .fontNunito(.regular, size: 14)
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.primary)
        }
        .coverFullScreen(alignment: .leading)
    }
}



#Preview {
    MainScreen()
}



