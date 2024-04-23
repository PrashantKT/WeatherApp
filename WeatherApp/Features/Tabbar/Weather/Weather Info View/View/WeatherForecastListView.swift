//
//  WeatherForcastListView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import SwiftUI

struct WeatherForecastListRow : View {
    let maxWeeklyTemp = 55
    let minWeeklyTemp = 26
    var isCurrentDate:Bool = false
    var body: some View {
        HStack {
            WeatherIconView(systemIcon: "sun.max.fill",systemIconColor: .yellow,width: 55).padding([.vertical,.trailing],8)
            VStack(alignment:.leading) {
                Text("Today")
                    .fontNunito(.regular, size: 14)
                Text("Rain, Partially cloudy")
                    .fontNunito(.regular, size: 11)
                    .lineLimit(2)
            }
            Spacer()
            
            MinMaxTemperatureChartView(maxWeeklyTemp: maxWeeklyTemp, minWeeklyTemp: minWeeklyTemp,isCurrentDate:isCurrentDate)
            
        }
    }
}

struct WeatherForecastListView : View {
    var body: some View {
        
        LazyVStack {
            ForEach(1...10,id:\.self) { index in
                WeatherForecastListRow(isCurrentDate: index == 1)
            }
        }
        
    }
}

#Preview {
    WeatherForecastListView()
}
