//
//  WeatherHourlyView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import SwiftUI

struct WeatherHourlyView: View {

    @EnvironmentObject var weatherInfoVM:WeatherInfoViewModel
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing:0) {
                ForEach((weatherInfoVM.prepareHourlyData())) { i in

                    VStack(spacing:0) {
                        WeatherIconView(systemIcon: i.weatherCode.symbol,systemIconColor: i.weatherCode.foregroundColor,width: 55, overlayText: i.precipitationFormatted)
                            .padding([.horizontal])
                            .padding(.vertical,8)

                        CommonTitleValueLabelView(title: i.time, value: "\(i.temperature)°")
                    }
                    .coverFullScreen()
                }

            }
        }
    }
}



#Preview {
    WeatherHourlyView().environmentObject(WeatherInfoViewModel(response:testData))
}
