//
//  DailyDataViewModel.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 29/04/24.
//

import Foundation

struct DailyDataViewModel:Identifiable {
    var id = UUID()
    var rangeMinTemp:Int
    var rangeMaxTemp:Int
    var todayIndex = 0
    var data:[DailyData] = []
}

struct DailyData:Identifiable {
    var id = UUID()
    var time:String
    var temperatureMin:Int
    var temperatureMax:Int
    var currentTemperature:Int? = nil
    var precipitation:Float? = nil
    var weatherCode:WeatherCode
    
    var precipitationFormatted:String? {
        if let precipitation,precipitation > 0 {
            return "\(precipitation ) %"
        }
        return nil
    }
}

