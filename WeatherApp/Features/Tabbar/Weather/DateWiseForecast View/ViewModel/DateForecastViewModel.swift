//
//  DateForecastViewModel.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import Foundation

extension DateForecastView {
    
    class ViewModel:ObservableObject {
        
        init(dayRange: ForecastDayRange, dates: [Date] = [Date]()) {
            self.dayRange = dayRange
            self.dates = dates
            prepareDates()
        }
        
        var dayRange:ForecastDayRange
        
        @Published var selectedDate:Date = MyCalendar.shared.currentDay
        @Published var scrollPos:Date?

        @Published var dates = [Date]()
        @Published var sessions = [SessionForeCast]()

        private func prepareDates() {
            switch self.dayRange {
            case .days(let number):
                dates =  MyCalendar.shared.getDateForNext(days: number)

            case .monthly:
                dates =  MyCalendar.shared.getDateForThisMonths()

            }
        }
        @MainActor
         func fetchSessionWiseForecast(for date:Date) async {
            sessions = [
                .init(session: .morning, temperature: Int.random(in: 18...40), feelLike: Int.random(in: 18...40), condition: WeatherCode.allCases.randomElement()!, windDirection: "2 m/s,NW", pressure: "758 mmHg", humidity: "64%", windGust: "Wind gust 10 m/s"),
                .init(session: .noon, temperature: Int.random(in: 18...40), feelLike: Int.random(in: 18...40), condition: WeatherCode.allCases.randomElement()!, windDirection: "2 m/s,NW", pressure: "758 mmHg", humidity: "64%", windGust: "Wind gust 10 m/s"),
                .init(session: .evening, temperature: Int.random(in: 18...40), feelLike: Int.random(in: 18...40), condition: WeatherCode.allCases.randomElement()!, windDirection: "2 m/s,NW", pressure: "758 mmHg", humidity: "64%", windGust: "Wind gust 10 m/s")
            ]
        }
        
    }
    
}
