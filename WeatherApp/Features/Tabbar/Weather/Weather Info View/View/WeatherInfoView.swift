//
//  WeatherInfoView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 15/03/24.
//

import SwiftUI
import CoreLocation

struct WeatherInfoView: View {
    @Environment(\.dismiss) var dismiss
    var coordinates:CLLocationCoordinate2D = .init()
    
    @StateObject private var viewModel:WeatherInfoViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                WeatherInfoHeaderView().padding([.top,.horizontal]).environmentObject(viewModel)
                WeatherHourlyView().environmentObject(viewModel)
                WeatherForecastListView(data: viewModel.prepareDailyData()).padding([.top,.horizontal]).environmentObject(viewModel)
                Divider()
                NavigationLink {
                    DateForecastView(dayRange: .days(number: 10))
                } label: {
                    buttonRowView(title: "10 Days Forecast")
                        .padding([.top,.horizontal])

                }
                .foregroundStyle(.primary)
                
                NavigationLink {
                    DateForecastView(dayRange: .monthly)

                } label: {
                    buttonRowView(title: "Monthly Forecast")
                        .padding([.horizontal])

                }
                .foregroundStyle(.primary)


//                    .background(Color.red)
                
            }
            .coverFullScreen()
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
        .task {
            do {
                viewModel.response = try await WeatherRequest().requestWeather(coordinates: coordinates)
                viewModel.isLoading = false
            } catch {
                print("Exception \(error)")
            }
        }
        .modifier(LoaderView(isLoading: $viewModel.isLoading))

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
    WeatherInfoView(coordinates: .init(latitude: 21.6422, longitude: 69.6093))
}



