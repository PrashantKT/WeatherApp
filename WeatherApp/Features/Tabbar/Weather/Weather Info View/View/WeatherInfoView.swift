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
    @State private var weatherData: WeatherResponse = .init()
    var body: some View {
        NavigationStack {
            ScrollView {
                WeatherInfoHeaderView().padding([.top,.horizontal])
                WeatherHourlyView()
                WeatherForecastListView().padding([.top,.horizontal])
                Divider()
                buttonRowView(title: "10 Days Forecast")
                    .padding([.top,.horizontal])
                buttonRowView(title: "Monthly Forecast")
                    .padding([.horizontal])

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
//        .task {
//            do {
//                self.weatherData = try await WeatherRequest().requestWeather()
//            } catch {
//                print("Exception \(error)")
//            }
//        }
    }
    
    func buttonRowView(title:String) -> some View{
        HStack {
            WeatherIconView(systemIcon: "list.clipboard",systemIconColor: .primary,width: 55,overlayText: nil).padding([.vertical,.trailing],8)
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
    WeatherInfoView()
}



