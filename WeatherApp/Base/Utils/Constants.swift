//
//  Constants.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 13/03/24.
//

import Foundation

enum Constants {
    static let baseUrl = "https"
    static let apiToken = ""
    
    static let commonTimeZone = TimeZone.current
    
}

enum APIConstants {
    static let baseURLForecast  = "https://api.open-meteo.com"
    static let apiVersion  = "v1"

}

enum FontSize {
    static let smallFontSize:CGFloat = 12
    static let mediumFontSize:CGFloat = 16
    static let largeFontSize:CGFloat = 22
}
