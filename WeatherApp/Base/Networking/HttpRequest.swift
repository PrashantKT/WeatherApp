//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 21/03/24.
//

import Foundation
import OpenMeteoSdk
import CoreLocation


protocol HttpRequest {
    func sendRequest<T:Codable>(endPoint:EndPoint,responseModelType:T.Type,jsonDecoder:JSONDecoder) async -> Result<T,RequestError>
}

extension HttpRequest {
    
    func sendRequest<T:Codable>(endPoint:EndPoint,responseModelType:T.Type,jsonDecoder:JSONDecoder = JSONDecoder()) async -> Result<T,RequestError> {
        let url = endPoint.prepareURL()
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }

            switch response.statusCode {
            case 200...299:
                do {
                    let res = try jsonDecoder.decode(T.self, from: data)
                    return .success(res)
                    
                } catch {
                    print(error)
                    return .failure(.decode)
                    
                }
                
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }

        } catch {
            return .failure(.decode)
        }
        
    }
}

class WeatherRequest {
    func requestWeather(coordinates:CLLocationCoordinate2D) async throws -> WeatherResponse  {
        
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=21.6422&longitude=69.6093&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,weather_code,surface_pressure,wind_speed_10m,wind_direction_10m&hourly=temperature_2m,precipitation_probability,rain,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,daylight_duration,uv_index_max,precipitation_sum,precipitation_probability_max&wind_speed_unit=ms&timezone=auto&forecast_days=10")!
      
        let (dataR,_) = try await URLSession.shared.data(from: url)
        
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
        
        let weatherRes = try decoder.decode(WeatherResponse.self, from: dataR)
        
        return weatherRes

    }
    
}
