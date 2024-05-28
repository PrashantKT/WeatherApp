//
//  ForecastEndPoint.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 02/05/24.
//

import Foundation


enum ForecastEndPoint {
    case forecast(para:[String:String])
}

extension ForecastEndPoint:EndPoint {
    var baseURL: String {
        return APIConstants.baseURLForecast
    }
    
    var apiVersion: String {
        return APIConstants.apiVersion
    }
    
    var path: String {
        return "forecast"
    }
    
    var queryPara: [String : String] {
        switch self {
        case .forecast(let para):
            return para
        }
    }
    
    
}
