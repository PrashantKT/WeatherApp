//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 21/03/24.
//

import Foundation

class WeatherRequest {
    
    func requestWeather() async throws -> WeatherResponse  {
        
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=21.6422&longitude=69.6093&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,weather_code&hourly=temperature_2m,precipitation_probability,rain,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,daylight_duration,uv_index_max,precipitation_sum,precipitation_probability_max&timeformat=unixtime&timezone=Asia%2FTokyo&forecast_days=1")!
      
        let (data,_) = try await URLSession.shared.data(from: url)
        
        let weatherRes = try JSONDecoder().decode(WeatherResponse.self, from: data)
        
        print(weatherRes.latitude)
        
        return weatherRes

    }
    
}
