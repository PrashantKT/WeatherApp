//
//  WeatherCodable.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 21/03/24.
//

import Foundation
import SwiftUI
struct WeatherResponse:Codable {
   
    
    let latitude, longitude: Double?
    let timezone, timezone_abbreviation: String?
    let current: Current?
    let hourly: Hourly?
    let daily: Daily?
    let utc_offset_seconds:Int?

    internal init(latitude: Double? = nil, longitude: Double? = nil, timezone: String? = nil, timezone_abbreviation: String? = nil, current: Current? = nil, hourly: Hourly? = nil, daily: Daily? = nil,utc_offset_seconds:Int? = nil ) {
        self.latitude = latitude
        self.longitude = longitude
        self.timezone = timezone
        self.timezone_abbreviation = timezone_abbreviation
        self.current = current
        self.hourly = hourly
        self.daily = daily
        self.utc_offset_seconds = utc_offset_seconds
    }
}

extension WeatherResponse {
    var timeZone:TimeZone? {
        TimeZone(abbreviation: self.timezone_abbreviation ?? "")
    }
}


// MARK: - Current
struct Current: Codable {
    let time: Date?
    let interval: Int?
    let temperature2M: Double?
    let relativeHumidity2M: Int?
    let apparentTemperature, precipitation, rain: Double?
    let weatherCode: WeatherCode?
    let surfacePressure:Double?
    let windSpeed10m:Double?
    let windDirection10m:Int?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation, rain
        case weatherCode = "weather_code"
        case surfacePressure = "surface_pressure"
        case windSpeed10m = "wind_speed_10m"
        case windDirection10m = "wind_direction_10m"

    }
}


struct Hourly: Codable {
    let time: [Date]?
    let temperature2M: [Double]?
    let precipitationProbability: [Int]?
    let rain: [Double]?
    let weatherCode: [WeatherCode]?

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case precipitationProbability = "precipitation_probability"
        case rain
        case weatherCode = "weather_code"
    }
}

struct Daily:Codable {
    let time: [Date]?
    let weatherCode: [WeatherCode]?
    let temperature2MMax: [Double]?
    let temperature2MMin: [Double]?
    let sunrise, sunset: [Date]?
    let daylightDuration, uvIndexMax: [Double]?
    let precipitationSum, precipitationProbabilityMax: [Float]?
    
    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case sunrise, sunset
        case daylightDuration = "daylight_duration"
        case uvIndexMax = "uv_index_max"
        case precipitationSum = "precipitation_sum"
        case precipitationProbabilityMax = "precipitation_probability_max"
    }
}


enum WeatherCode: Int,Codable,CaseIterable {
    case clearSky = 0
    case mainlyClear = 1
    case partlyCloudy = 2
    case overcast = 3
    case fog = 45
    case depositingRimeFog = 48
    case drizzleLight = 51
    case drizzleModerate = 53
    case drizzleDense = 55
    case freezingDrizzleLight = 56
    case freezingDrizzleDense = 57
    case rainSlight = 61
    case rainModerate = 63
    case rainHeavy = 65
    case freezingRainLight = 66
    case freezingRainHeavy = 67
    case snowfallSlight = 71
    case snowfallModerate = 73
    case snowfallHeavy = 75
    case snowGrains = 77
    case rainShowersSlight = 80
    case rainShowersModerate = 81
    case rainShowersViolent = 82
    case snowShowersSlight = 85
    case snowShowersHeavy = 86
    case thunderstormSlight = 95
    case thunderstormWithHailSlight = 96
    case thunderstormWithHailHeavy = 99
    
    var description: String {
        switch self {
        case .clearSky: return "Clear sky"
        case .mainlyClear: return "Mainly clear"
        case .partlyCloudy: return "Partly cloudy"
        case .overcast: return "Overcast"
        case .fog: return "Fog"
        case .depositingRimeFog: return "Depositing rime fog"
        case .drizzleLight: return "Drizzle: Light intensity"
        case .drizzleModerate: return "Drizzle: Moderate intensity"
        case .drizzleDense: return "Drizzle: Dense intensity"
        case .freezingDrizzleLight: return "Freezing Drizzle: Light intensity"
        case .freezingDrizzleDense: return "Freezing Drizzle: Dense intensity"
        case .rainSlight: return "Rain: Slight intensity"
        case .rainModerate: return "Rain: Moderate intensity"
        case .rainHeavy: return "Rain: Heavy intensity"
        case .freezingRainLight: return "Freezing Rain: Light intensity"
        case .freezingRainHeavy: return "Freezing Rain: Heavy intensity"
        case .snowfallSlight: return "Snowfall: Slight intensity"
        case .snowfallModerate: return "Snowfall: Moderate intensity"
        case .snowfallHeavy: return "Snowfall: Heavy intensity"
        case .snowGrains: return "Snow grains"
        case .rainShowersSlight: return "Rain showers: Slight intensity"
        case .rainShowersModerate: return "Rain showers: Moderate intensity"
        case .rainShowersViolent: return "Rain showers: Violent intensity"
        case .snowShowersSlight: return "Snow showers: Slight intensity"
        case .snowShowersHeavy: return "Snow showers: Heavy intensity"
        case .thunderstormSlight: return "Thunderstorm: Slight intensity"
        case .thunderstormWithHailSlight: return "Thunderstorm with hail: Slight intensity"
        case .thunderstormWithHailHeavy: return "Thunderstorm with hail: Heavy intensity"
        }
    }
}

extension WeatherCode {
    var symbol: Image? {
           switch self {
           case .clearSky: return Image(systemName: "sun.max.fill")
           case .mainlyClear: return Image(systemName: "cloud.sun.fill")
           case .partlyCloudy: return Image(systemName: "cloud.sun.fill")
           case .overcast: return Image(systemName: "cloud.fill")
           case .fog: return Image(systemName: "cloud.fog.fill")
           case .depositingRimeFog: return Image(systemName: "cloud.fog.fill")
           case .drizzleLight: return Image(systemName: "cloud.drizzle.fill")
           case .drizzleModerate: return Image(systemName: "cloud.drizzle.fill")
           case .drizzleDense: return Image(systemName: "cloud.drizzle.fill")
           case .freezingDrizzleLight: return Image(systemName: "cloud.drizzle.fill")
           case .freezingDrizzleDense: return Image(systemName: "cloud.drizzle.fill")
           case .rainSlight: return Image(systemName: "cloud.rain.fill")
           case .rainModerate: return Image(systemName: "cloud.rain.fill")
           case .rainHeavy: return Image(systemName: "cloud.rain.fill")
           case .freezingRainLight: return Image(systemName: "cloud.sleet.fill")
           case .freezingRainHeavy: return Image(systemName: "cloud.sleet.fill")
           case .snowfallSlight: return Image(systemName: "cloud.snow.fill")
           case .snowfallModerate: return Image(systemName: "cloud.snow.fill")
           case .snowfallHeavy: return Image(systemName: "cloud.snow.fill")
           case .snowGrains: return Image(systemName: "cloud.snow.fill")
           case .rainShowersSlight: return Image(systemName: "cloud.heavyrain.fill")
           case .rainShowersModerate: return Image(systemName: "cloud.heavyrain.fill")
           case .rainShowersViolent: return Image(systemName: "cloud.heavyrain.fill")
           case .snowShowersSlight: return Image(systemName: "cloud.snow.fill")
           case .snowShowersHeavy: return Image(systemName: "cloud.snow.fill")
           case .thunderstormSlight: return Image(systemName: "cloud.bolt.fill")
           case .thunderstormWithHailSlight: return Image(systemName: "cloud.bolt.fill")
           case .thunderstormWithHailHeavy: return Image(systemName: "cloud.bolt.fill")
           }
       }
    
    
}

extension WeatherCode {
    var foregroundColor: Color {
        switch self {
        case .clearSky, .mainlyClear, .partlyCloudy:
            return Color.yellow // Yellow for clear and partly cloudy conditions
        case .overcast, .fog, .depositingRimeFog, .drizzleLight, .drizzleModerate, .drizzleDense, .freezingDrizzleLight, .freezingDrizzleDense, .rainSlight, .rainModerate, .rainHeavy, .freezingRainLight, .freezingRainHeavy, .snowfallSlight, .snowfallModerate, .snowfallHeavy, .snowGrains, .rainShowersSlight, .rainShowersModerate, .rainShowersViolent, .snowShowersSlight, .snowShowersHeavy, .thunderstormSlight, .thunderstormWithHailSlight, .thunderstormWithHailHeavy:
            return Color.blue // Blue for cloudy, rainy, snowy, and other adverse conditions
        }
    }
}
