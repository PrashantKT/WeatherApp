//
//  WeatherForcastListView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import SwiftUI

struct WeatherForecastListRow : View {
    var maxRangeTemp = 55
    var minRangeTemp = 26
    var isCurrentDate:Bool = false
    var dataModel: DailyData

    
    var body: some View {
        HStack {
            WeatherIconView(systemIcon: dataModel.weatherCode.symbol,systemIconColor: dataModel.weatherCode.foregroundColor,width: 55,overlayText: dataModel.precipitationFormatted).padding([.vertical,.trailing],8)
            VStack(alignment:.leading) {
                Text(dataModel.time)
                    .fontNunito(.regular, size: 14)
                Text(dataModel.weatherCode.description)
                    .fontNunito(.regular, size: 11)
                    .lineLimit(2)
            }
            .frame(maxWidth: 100,alignment: .leading)
//            Spacer()
            
            MinMaxTemperatureChartView(maxWeeklyTemp: maxRangeTemp, minWeeklyTemp: minRangeTemp,isCurrentDate:isCurrentDate,minV: dataModel.temperatureMin,maxV: dataModel.temperatureMax,currentValue: dataModel.currentTemperature)
            
        }
    }
}

struct WeatherForecastListView : View {
    var data:DailyDataViewModel
    var body: some View {
        
        LazyVStack {
            ForEach(0..<data.data.count,id:\.self) { index in
                WeatherForecastListRow(maxRangeTemp: data.rangeMaxTemp, minRangeTemp: data.rangeMinTemp, isCurrentDate: index == data.todayIndex,dataModel: data.data[index])
            }
        }
        
    }
}

#Preview {
    WeatherForecastListView(data: WeatherInfoViewModel(response: testData).prepareDailyData())
}
