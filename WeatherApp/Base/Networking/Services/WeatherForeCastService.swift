//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 02/05/24.
//

import Foundation
import CoreLocation

protocol WeatherForeCastServiceable {
    func fetchWeather(para:[String:String]) async -> Result<WeatherResponse,RequestError>
}

actor WeatherForeCastService: WeatherForeCastServiceable,HttpRequest {
   
    func fetchWeather(para:[String:String]) async -> Result<WeatherResponse, RequestError> {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm" //2024-04-26T07:00
        dateFormat.timeZone = Constants.commonTimeZone

        let dateFormat2 = DateFormatter()
        dateFormat2.dateFormat = "yyyy-MM-dd" //2024-04-26T07:00
        dateFormat2.timeZone = Constants.commonTimeZone

        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let singleValueContainer = try  decoder.singleValueContainer()
            let string = try singleValueContainer.decode(String.self)
            
            for formatter in [dateFormat,dateFormat2] {
                if let date = formatter.date(from: string) {
                    return date
                }
            }

            throw DecodingError.dataCorruptedError(in: singleValueContainer, debugDescription: "Cannot decode date string \(string)")
        })
        
        return await  sendRequest(endPoint: ForecastEndPoint.forecast(para: para), responseModelType: WeatherResponse.self,jsonDecoder: decoder)
    }
}


struct WeatherAPIParameters: Codable {
    var latitude: String
    var longitude: String
    var current: String = "temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,weather_code,surface_pressure,wind_speed_10m,wind_direction_10m"
    var hourly: String = "temperature_2m,precipitation_probability,rain,weather_code"
    var daily: String =   "weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,daylight_duration,uv_index_max,precipitation_sum,precipitation_probability_max"
    var windSpeedUnit: String = "ms"
    var timezone: String =  "auto"
    var forecastDays: String = "10"
    
    func toDictionary() -> [String: String] {
        let mirror = Mirror(reflecting: self)
        var dict = [String: String]()
        for case let (label?, value) in mirror.children {
            dict[label] = "\(value)"
        }
        return dict
    }
}
