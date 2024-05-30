//
//  WeatherInfoViewModel.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 25/04/24.
//

import Foundation
import CoreLocation

@MainActor
class WeatherInfoViewModel : ObservableObject {
    //View Properties
    @Published var response : WeatherResponse = .init()
    @Published var isLoading = true

    private (set) var service:WeatherForeCastServiceable
    
    init() {
        service = WeatherForeCastService()
    }
    
    init(service:WeatherForeCastServiceable = WeatherForeCastService(),  response: WeatherResponse, isLoading: Bool = true) {
        self.response = response
        self.isLoading = isLoading
        self.service = service
    }
    

    func fetchWeatherData(coordinates:CLLocationCoordinate2D) async {
        do {
            let para = WeatherAPIParameters(latitude: "\(coordinates.latitude)", longitude: "\(coordinates.longitude)")
            
            response = try await service.fetchWeather(para: para.toDictionary()).get()
            isLoading = false
        } catch {
            print("Exception \(error)")
        }
    }
    
    
    private func findDailyDataIndex(of date:Date) -> Int? {
        response.daily?.time?.firstIndex(where: {$0.isTheSameDay(date,timeZone: response.timeZone)})
        
        
        
        
    }
    
    private func findHourlyDataIndex(of date:Date) -> Int? {
        response.hourly?.time?.firstIndex(where: {$0.isTheSameDay(Date(),timeZone: response.timeZone) && $0.isTheSameHour(Date())})
    }
}

//Current weather info Header View
extension WeatherInfoViewModel {
    
//    var formattedCurrentDate:String {
//        Date().formatted(date: .abbreviated, time: .omitted)
//    }
//    var formattedTime:String {
//        response.current?.time?.formatted(date: .omitted, time: .shortened) ?? "-"
//    }
    
    var formattedDateTime: String {
        response.current?.time?.formatted() ?? "~"
    }
    
    var currentFormattedTemp:String {
        response.current?.temperature2M?.formattedDecimal(1) ?? "-"
    }
    
    var currentFeelsLikeFormattedTemp:String {
        response.current?.apparentTemperature?.formattedDecimal(0) ?? "-"
    }
    
    var currentCondition:WeatherCode {
        response.current?.weatherCode ?? .clearSky
    }
    
    var pressure:String {
        response.current?.surfacePressure?.formattedDecimal(1) ?? "-"
    }
    
    var humidity:String {
        "\(response.current?.relativeHumidity2M ?? 0) %"
    }
    
    var windSpeed:String {
        response.current?.windSpeed10m?.formattedDecimal(0) ?? "-"
    }
    var windDirection:String {
        let arr = ["N","NNE","NE","ENE","E","ESE", "SE", "SSE","S","SSW","SW","WSW","W","WNW","NW","NNW"]

        let  dir =  response.current?.windDirection10m ?? 0
        return arr[dir % 16]
    }
    
    func sunriseTime(on date:Date = Date()) -> String {
        return response.daily?.sunrise?.first(where: {$0.isTheSameDay(date,timeZone: response.timeZone)})?.formatted(date: .omitted, time: .shortened) ?? "-"
        
    }
    
    func sunsetTime(on date:Date = Date()) -> String {
        return  response.daily?.sunset?.first(where: {$0.isTheSameDay(date,timeZone: response.timeZone)})?.formatted(date: .omitted, time: .shortened) ?? "-"
       
    }
    
    func uvIndex(on date:Date = Date()) -> Double {
        if let index = findDailyDataIndex(of: date),(response.daily?.uvIndexMax?.count ?? 0) > index {
          return  ((response.daily?.uvIndexMax?[index] ?? 1) / 9)
        }
        return 0
    }
    
    func maxMinTemperature(on date:Date = Date()) -> (min:String,max:String) {
        if let index = findDailyDataIndex(of: date),(response.daily?.temperature2MMin?.count ?? 0) > index {
            let min =   response.daily?.temperature2MMin?[index].formattedDecimal(0) ?? "-"
            let max =   response.daily?.temperature2MMax?[index].formattedDecimal(0) ?? "-"
            return (min,max)
        }
        return ("-","-")

    }
    
    func precipitationProbability(on date:Date = Date()) -> String {
        if let index = findHourlyDataIndex(of: date),(response.hourly?.precipitationProbability?.count ?? 0) > index {
            return  "\(response.hourly?.precipitationProbability?[index] ?? 0)"
        }
        return "-"
    }
    
    func dayLightDuration(on date:Date = Date()) -> String {
        if let index = findDailyDataIndex(of: date),(response.daily?.daylightDuration?.count ?? 0) > index {
            let duration =   response.daily?.daylightDuration?[index] ?? 0
            
            let dateComponentFormatter = DateComponentsFormatter()
            dateComponentFormatter.allowedUnits = [.hour,.minute]
            dateComponentFormatter.unitsStyle = .abbreviated
            
            let formattedString = dateComponentFormatter.string(from: TimeInterval(duration))!
            return formattedString
        }
        return "-"
    }
    
    func calculateDayLightPercentage() -> Double {
        if let dataIndex = findDailyDataIndex(of: Date()),
           let dayEnd = response.daily?.sunset?.first(where: {$0.isTheSameDay(Date(),timeZone: response.timeZone)}),
           let dayStart = response.daily?.sunrise?.first(where: {$0.isTheSameDay(Date(),timeZone: response.timeZone)}){
            
           
            
            let totalDaylightDuration = dayEnd.timeIntervalSince(dayStart)
            let elapsedTimeSinceDaylightStart = Date().timeIntervalSince(dayStart)
            
            let daylightPercentage = (elapsedTimeSinceDaylightStart / totalDaylightDuration) * 100
            return daylightPercentage
        }
        return 0
    }
    
  
}

extension WeatherInfoViewModel {
    
    func prepareHourlyData(date:Date = Date()) -> [HourlyDataViewModel] {
    
        guard let time =  response.hourly?.time, !time.isEmpty else {
            return []
        }
        var result = [HourlyDataViewModel]()
        for index in 0..<time.count {
            let date = time[index]
            guard date.isTheSameDay(Date(),timeZone: response.timeZone) else {
                continue
            }
            let dateFormatter = DateFormatter()
//            dateFormatter.timeZone = Constants.commonTimeZone
            
            dateFormatter.dateFormat = "h a" // Format to display hour and AM/PM only
            let time = dateFormatter.string(from: date)
            let temp = response.hourly?.temperature2M?[index].formattedDecimal(1) ?? "-" + "°"
            let weatherCode = response.hourly?.weatherCode?[index] ?? .clearSky
            let precipitation = response.hourly?.precipitationProbability?[index]

            let singleData = HourlyDataViewModel(time: time, temperature: temp,precipitation:precipitation, weatherCode: weatherCode)
            result.append(singleData)

           
        }
        return result
    }
    
}

extension WeatherInfoViewModel {
    func prepareDailyData(date:Date = Date()) -> DailyDataViewModel {
    
        guard let time =  response.daily?.time, !time.isEmpty else {
            return .init(rangeMinTemp: 0, rangeMaxTemp: 0)
        }
        
        var dailyData = DailyDataViewModel(rangeMinTemp: 0, rangeMaxTemp: 0)
        var todayIndex = 0
        var result = [DailyData]()
        
        for index in 0..<time.count {
            let date = time[index]
           
            let isToday =  date.isTheSameDay(Date(),timeZone: response.timeZone)
            todayIndex = isToday ? index : todayIndex
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = Constants.commonTimeZone
            
            dateFormatter.dateFormat = "EEEEEE, MMM d"
            let time = isToday ? "Today" :  dateFormatter.string(from: date)
            let tempMin =   response.daily?.temperature2MMin?[index]
            let tempMax =   response.daily?.temperature2MMax?[index]

            let weatherCode = response.daily?.weatherCode?[index] ?? .clearSky
            let precipitation = response.daily?.precipitationProbabilityMax?[index]
            
            
            let singleData = DailyData(time: time, temperatureMin:Int(tempMin ?? 0),temperatureMax: Int(tempMax ?? 0),currentTemperature: isToday ? Int(response.current?.temperature2M ?? 0) : nil, precipitation:precipitation, weatherCode: weatherCode)
            result.append(singleData)
        }
        dailyData.data = result
        dailyData.rangeMinTemp = Int(response.daily?.temperature2MMin?.min() ?? 0)
        dailyData.rangeMaxTemp = Int(response.daily?.temperature2MMax?.max() ?? 0)
        dailyData.todayIndex = todayIndex
        return dailyData
    }
}


let testResponse =
 
"""
{"latitude":21.625,"longitude":69.625,"generationtime_ms":0.2599954605102539,"utc_offset_seconds":0,"timezone":"GMT","timezone_abbreviation":"GMT","elevation":8.0,"current_units":{"time":"iso8601","interval":"seconds","temperature_2m":"°C","relative_humidity_2m":"%","apparent_temperature":"°C","precipitation":"mm","rain":"mm","weather_code":"wmo code","surface_pressure":"hPa","wind_speed_10m":"m/s","wind_direction_10m":"°"},"current":{"time":"2024-04-29T08:00","interval":900,"temperature_2m":38.0,"relative_humidity_2m":26,"apparent_temperature":39.5,"precipitation":0.00,"rain":0.00,"weather_code":0,"surface_pressure":1008.5,"wind_speed_10m":4.65,"wind_direction_10m":295},"hourly_units":{"time":"iso8601","temperature_2m":"°C","precipitation_probability":"%","rain":"mm","weather_code":"wmo code"},"hourly":{"time":["2024-04-29T00:00","2024-04-29T01:00","2024-04-29T02:00","2024-04-29T03:00","2024-04-29T04:00","2024-04-29T05:00","2024-04-29T06:00","2024-04-29T07:00","2024-04-29T08:00","2024-04-29T09:00","2024-04-29T10:00","2024-04-29T11:00","2024-04-29T12:00","2024-04-29T13:00","2024-04-29T14:00","2024-04-29T15:00","2024-04-29T16:00","2024-04-29T17:00","2024-04-29T18:00","2024-04-29T19:00","2024-04-29T20:00","2024-04-29T21:00","2024-04-29T22:00","2024-04-29T23:00","2024-04-30T00:00","2024-04-30T01:00","2024-04-30T02:00","2024-04-30T03:00","2024-04-30T04:00","2024-04-30T05:00","2024-04-30T06:00","2024-04-30T07:00","2024-04-30T08:00","2024-04-30T09:00","2024-04-30T10:00","2024-04-30T11:00","2024-04-30T12:00","2024-04-30T13:00","2024-04-30T14:00","2024-04-30T15:00","2024-04-30T16:00","2024-04-30T17:00","2024-04-30T18:00","2024-04-30T19:00","2024-04-30T20:00","2024-04-30T21:00","2024-04-30T22:00","2024-04-30T23:00","2024-05-01T00:00","2024-05-01T01:00","2024-05-01T02:00","2024-05-01T03:00","2024-05-01T04:00","2024-05-01T05:00","2024-05-01T06:00","2024-05-01T07:00","2024-05-01T08:00","2024-05-01T09:00","2024-05-01T10:00","2024-05-01T11:00","2024-05-01T12:00","2024-05-01T13:00","2024-05-01T14:00","2024-05-01T15:00","2024-05-01T16:00","2024-05-01T17:00","2024-05-01T18:00","2024-05-01T19:00","2024-05-01T20:00","2024-05-01T21:00","2024-05-01T22:00","2024-05-01T23:00","2024-05-02T00:00","2024-05-02T01:00","2024-05-02T02:00","2024-05-02T03:00","2024-05-02T04:00","2024-05-02T05:00","2024-05-02T06:00","2024-05-02T07:00","2024-05-02T08:00","2024-05-02T09:00","2024-05-02T10:00","2024-05-02T11:00","2024-05-02T12:00","2024-05-02T13:00","2024-05-02T14:00","2024-05-02T15:00","2024-05-02T16:00","2024-05-02T17:00","2024-05-02T18:00","2024-05-02T19:00","2024-05-02T20:00","2024-05-02T21:00","2024-05-02T22:00","2024-05-02T23:00","2024-05-03T00:00","2024-05-03T01:00","2024-05-03T02:00","2024-05-03T03:00","2024-05-03T04:00","2024-05-03T05:00","2024-05-03T06:00","2024-05-03T07:00","2024-05-03T08:00","2024-05-03T09:00","2024-05-03T10:00","2024-05-03T11:00","2024-05-03T12:00","2024-05-03T13:00","2024-05-03T14:00","2024-05-03T15:00","2024-05-03T16:00","2024-05-03T17:00","2024-05-03T18:00","2024-05-03T19:00","2024-05-03T20:00","2024-05-03T21:00","2024-05-03T22:00","2024-05-03T23:00","2024-05-04T00:00","2024-05-04T01:00","2024-05-04T02:00","2024-05-04T03:00","2024-05-04T04:00","2024-05-04T05:00","2024-05-04T06:00","2024-05-04T07:00","2024-05-04T08:00","2024-05-04T09:00","2024-05-04T10:00","2024-05-04T11:00","2024-05-04T12:00","2024-05-04T13:00","2024-05-04T14:00","2024-05-04T15:00","2024-05-04T16:00","2024-05-04T17:00","2024-05-04T18:00","2024-05-04T19:00","2024-05-04T20:00","2024-05-04T21:00","2024-05-04T22:00","2024-05-04T23:00","2024-05-05T00:00","2024-05-05T01:00","2024-05-05T02:00","2024-05-05T03:00","2024-05-05T04:00","2024-05-05T05:00","2024-05-05T06:00","2024-05-05T07:00","2024-05-05T08:00","2024-05-05T09:00","2024-05-05T10:00","2024-05-05T11:00","2024-05-05T12:00","2024-05-05T13:00","2024-05-05T14:00","2024-05-05T15:00","2024-05-05T16:00","2024-05-05T17:00","2024-05-05T18:00","2024-05-05T19:00","2024-05-05T20:00","2024-05-05T21:00","2024-05-05T22:00","2024-05-05T23:00","2024-05-06T00:00","2024-05-06T01:00","2024-05-06T02:00","2024-05-06T03:00","2024-05-06T04:00","2024-05-06T05:00","2024-05-06T06:00","2024-05-06T07:00","2024-05-06T08:00","2024-05-06T09:00","2024-05-06T10:00","2024-05-06T11:00","2024-05-06T12:00","2024-05-06T13:00","2024-05-06T14:00","2024-05-06T15:00","2024-05-06T16:00","2024-05-06T17:00","2024-05-06T18:00","2024-05-06T19:00","2024-05-06T20:00","2024-05-06T21:00","2024-05-06T22:00","2024-05-06T23:00","2024-05-07T00:00","2024-05-07T01:00","2024-05-07T02:00","2024-05-07T03:00","2024-05-07T04:00","2024-05-07T05:00","2024-05-07T06:00","2024-05-07T07:00","2024-05-07T08:00","2024-05-07T09:00","2024-05-07T10:00","2024-05-07T11:00","2024-05-07T12:00","2024-05-07T13:00","2024-05-07T14:00","2024-05-07T15:00","2024-05-07T16:00","2024-05-07T17:00","2024-05-07T18:00","2024-05-07T19:00","2024-05-07T20:00","2024-05-07T21:00","2024-05-07T22:00","2024-05-07T23:00","2024-05-08T00:00","2024-05-08T01:00","2024-05-08T02:00","2024-05-08T03:00","2024-05-08T04:00","2024-05-08T05:00","2024-05-08T06:00","2024-05-08T07:00","2024-05-08T08:00","2024-05-08T09:00","2024-05-08T10:00","2024-05-08T11:00","2024-05-08T12:00","2024-05-08T13:00","2024-05-08T14:00","2024-05-08T15:00","2024-05-08T16:00","2024-05-08T17:00","2024-05-08T18:00","2024-05-08T19:00","2024-05-08T20:00","2024-05-08T21:00","2024-05-08T22:00","2024-05-08T23:00"],"temperature_2m":[24.9,24.7,25.5,28.2,30.7,33.0,35.3,37.0,37.9,38.0,37.4,35.9,34.6,32.8,30.5,29.2,28.3,27.8,27.2,26.7,26.2,25.7,25.4,25.1,24.8,24.6,25.5,28.1,30.7,33.4,35.7,37.3,37.9,36.8,36.3,35.7,34.1,32.2,30.0,28.7,27.8,27.1,26.5,26.2,25.7,25.3,24.9,24.6,24.3,24.1,25.0,27.9,30.4,33.1,35.5,37.0,37.4,36.9,36.1,35.1,33.6,31.6,29.6,28.3,27.6,26.9,26.1,25.6,25.1,24.6,24.1,23.8,23.6,23.4,24.1,26.9,29.3,31.6,33.6,34.4,34.5,34.3,33.8,32.9,31.9,30.6,29.1,27.8,27.1,26.6,26.2,25.8,25.6,25.5,25.3,25.2,25.4,26.1,27.1,28.3,30.0,31.9,33.4,34.1,34.4,34.3,33.8,33.0,32.0,30.8,29.5,28.4,27.7,27.3,26.9,26.5,26.2,25.9,25.5,25.2,25.3,25.9,27.0,28.5,30.8,33.6,35.6,36.2,35.9,35.5,35.1,34.5,33.8,32.6,31.3,30.1,29.4,28.8,28.3,27.8,27.4,27.1,26.9,26.7,26.8,27.3,28.2,29.1,30.4,31.8,32.9,33.8,34.5,34.7,34.2,33.2,32.1,31.0,29.8,28.9,28.4,28.2,28.0,27.8,27.7,27.5,27.1,26.8,26.7,27.0,27.7,28.5,29.7,31.2,32.3,32.9,33.2,33.2,32.7,31.7,31.1,29.7,29.1,28.7,28.4,28.3,28.2,28.1,28.0,27.9,27.7,27.5,27.6,27.9,28.4,29.0,29.8,30.7,31.4,31.7,31.7,31.6,31.3,30.9,30.5,29.9,29.2,28.7,28.4,28.2,28.0,27.8,27.6,27.5,27.3,27.2,27.3,27.8,28.6,29.4,30.3,31.3,32.0,32.3,32.4,32.3,32.0,31.5,31.0,30.3,29.5,28.9,28.5,28.3,28.2,28.1,28.1,28.1,28.0,27.9],"precipitation_probability":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"rain":[0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00],"weather_code":[1,1,0,0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,2,3,3,1,0,1,0,0,0,0,1,1,1,1,2,1,0,0,0,0,0,0,0,0,3,3,3,2,2,3,3,2,2,3,1,3,2,2,2,2,2,2,2,0,0,0,1,1,1,1,1,1,3,3,3,2,2,2,3,3,3,2,2,2,1,1,1,3,3,3,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,3,3,3,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,96,96,96,96,96,96,96,96,96,96,96,96,96,96,96,96,96,0,0,96,96,96,96,96,96,96,96,96,96,96,96,96,96,96,96,96,96,0,0,0,0,0,0,0,0,0,0,0,0,96,96,96,96,96,96,96,0,0,0]},"daily_units":{"time":"iso8601","weather_code":"wmo code","temperature_2m_max":"°C","temperature_2m_min":"°C","sunrise":"iso8601","sunset":"iso8601","daylight_duration":"s","uv_index_max":"","precipitation_sum":"mm","precipitation_probability_max":"%"},"daily":{"time":["2024-04-29","2024-04-30","2024-05-01","2024-05-02","2024-05-03","2024-05-04","2024-05-05","2024-05-06","2024-05-07","2024-05-08"],"weather_code":[2,3,3,3,3,3,3,96,96,96],"temperature_2m_max":[38.0,37.9,37.4,34.5,34.4,36.2,34.7,33.2,31.7,32.4],"temperature_2m_min":[24.7,24.6,23.8,23.4,25.2,25.3,26.8,26.7,27.2,27.3],"sunrise":["2024-04-29T00:51","2024-04-30T00:50","2024-05-01T00:50","2024-05-02T00:49","2024-05-03T00:48","2024-05-04T00:48","2024-05-05T00:47","2024-05-06T00:47","2024-05-07T00:46","2024-05-08T00:45"],"sunset":["2024-04-29T13:46","2024-04-30T13:46","2024-05-01T13:47","2024-05-02T13:47","2024-05-03T13:47","2024-05-04T13:48","2024-05-05T13:48","2024-05-06T13:49","2024-05-07T13:49","2024-05-08T13:50"],"daylight_duration":[46512.58,46576.40,46639.64,46702.24,46764.14,46825.29,46885.62,46945.08,47003.60,47061.12],"uv_index_max":[8.10,8.10,7.90,7.20,7.60,7.65,7.65,7.55,7.60,7.65],"precipitation_sum":[0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00],"precipitation_probability_max":[0,0,0,0,0,0,0,3,0,0]}}

"""

var testData: WeatherResponse {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm" //2024-04-26T07:00
    dateFormat.timeZone = TimeZone(identifier: "Asia/Tokyo")
    
    let dateFormat2 = DateFormatter()
    dateFormat2.dateFormat = "yyyy-MM-dd" //2024-04-26T07:00
    dateFormat2.timeZone = TimeZone(identifier: "Asia/Tokyo")
    
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormat)
    
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
    
    
    
    
    let weatherRes = try! decoder.decode(WeatherResponse.self, from: testResponse.data(using: .utf8)!)
    return weatherRes
    
}
