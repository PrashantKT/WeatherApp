//
//  WeatherHourlyView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import SwiftUI

struct WeatherHourlyView: View {

    var data :[HourlyDataViewModel]
    
    init(data: [HourlyDataViewModel]) {
        self.data = data
    }
    
    @State private var currentHourData:String? = nil
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            Text("Data : \(data.count)").coverH(alignment: .leading)
            HStack(spacing:0) {
                ForEach((data)) { i in
                   
                    VStack(spacing:0) {
                        WeatherIconView(systemIcon: i.weatherCode.symbol,systemIconColor: i.weatherCode.foregroundColor,width: 55, overlayText: i.precipitationFormatted)
                            .padding([.horizontal])
                            .padding(.vertical,8)

                        CommonTitleValueLabelView(title: i.time, value: "\(i.temperature)°")
                    }
                    .coverFullScreen()
                    .id(i.time)
                    
                }

            }
        }
        .scrollPosition(id: $currentHourData)
        .onChange(of: data) { oldValue, newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.currentHourData = data.first(where: { model in
                    model.time.replacingOccurrences(of: " ", with: "") == Date().formatted(.dateTime.hour()).filter{$0.isASCII}
                })?.time
            }
        }
    }
}



#Preview {
    WeatherHourlyView(data: WeatherInfoViewModel(response:testData).prepareHourlyData())
}
