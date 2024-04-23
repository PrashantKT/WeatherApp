//
//  WeatherCodable.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 21/03/24.
//

import Foundation

struct WeatherResponse:Codable {
   
    
    let latitude, longitude: Double?
    let timezone, timezone_abbreviation: String?
    let current: Current?
    let hourly: Hourly?
    let daily: Daily?
    
    internal init(latitude: Double? = nil, longitude: Double? = nil, timezone: String? = nil, timezone_abbreviation: String? = nil, current: Current? = nil, hourly: Hourly? = nil, daily: Daily? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.timezone = timezone
        self.timezone_abbreviation = timezone_abbreviation
        self.current = current
        self.hourly = hourly
        self.daily = daily
    }
}


// MARK: - Current
struct Current: Codable {
    let time: Date?
    let interval: Int?
    let temperature2M: Double?
    let relativeHumidity2M: Int?
    let apparentTemperature, precipitation, rain: Float?
    let weatherCode: WeatherCode?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation, rain
        case weatherCode = "weather_code"
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


enum WeatherCode: Int,Codable {
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
