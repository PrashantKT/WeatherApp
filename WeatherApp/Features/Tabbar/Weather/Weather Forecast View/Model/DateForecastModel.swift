//
//  DateForecastModel.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import Foundation

enum ForecastDayRange {
    case days(number:Int)
    case monthly
    
//    var days:Int {
//        switch self {
//        case .days(let number):
//            return number
//        case .monthly:
//            return Calendar.current.day
//        }
//    }
    
}

enum DaySessions:String {
    case morning
    case noon
    case evening
}

struct SessionForeCast:Identifiable {
    var id = UUID()
    var session:DaySessions
    var temperature:Int
    var feelLike:Int
    var condition:WeatherCode
    var windDirection:String
    var pressure:String
    var humidity:String
    var windGust:String
    

}
