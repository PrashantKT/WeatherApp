//
//  HourlyDataModel.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 26/04/24.
//

import Foundation



struct HourlyDataViewModel:Identifiable {
    var id = UUID()
    var time:String
    var temperature:String
    var precipitation:Int? = nil
    var weatherCode:WeatherCode
    
    var precipitationFormatted:String? {
        if let precipitation,precipitation > 0 {
            return "\(precipitation ) %"
        }
        return nil
    }
}


