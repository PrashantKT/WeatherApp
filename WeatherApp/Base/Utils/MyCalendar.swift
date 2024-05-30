//
//  MyCalendar.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 23/04/24.
//

import Foundation


class MyCalendar {
    
    static let shared = MyCalendar()

    private (set) var cal : Calendar
    private init() {
        cal = Calendar(identifier: .gregorian)
        cal.timeZone = Constants.commonTimeZone
    }
    
    
    
    var currentDay:Date {
        cal.startOfDay(for: Date())
    }
    
    func getDateForNext(days:Int) -> [Date] {
        var arrDates = [currentDay]
        
        for i in 1...days {
            if let nextDay = cal.date(byAdding: .day, value: i, to: currentDay) {
                arrDates.append(nextDay)
            }
        }
        return arrDates
    }
    
    func getDateForThisMonths() -> [Date] {
        guard let monthRange = cal.dateInterval(of: .month, for: currentDay) else {
            return []
        }
        var arrDates = [Date]()

        var startOfMonth = monthRange.start
        let endOfMonth = monthRange.end
        
        while startOfMonth < endOfMonth {
            arrDates.append(startOfMonth)
            startOfMonth = cal.date(byAdding: .day, value: 1, to: startOfMonth)!
        }
        return arrDates
    }
    
    func weekSymbol(from date:Date) -> String{
        let weekDay = cal.component(.weekday, from: date)
        return cal.weekdaySymbols[weekDay - 1]
    }
    
    
    
}


extension Date {
    
    func weekSymbol() -> String {
        MyCalendar.shared.weekSymbol(from: self)
    }
    
    func isTheSameDay(_ date:Date,timeZone:TimeZone?) -> Bool {
        let day = MyCalendar.shared.cal.dateComponents(in: timeZone ?? Constants.commonTimeZone, from: self).day
        return MyCalendar.shared.cal.dateComponents(in: timeZone ?? Constants.commonTimeZone, from: date).day == day
    }
    
    func isTheSameHour(_ date:Date) -> Bool {
        let hour = MyCalendar.shared.cal.dateComponents(in: Constants.commonTimeZone, from: self).hour

        return MyCalendar.shared.cal.component(.hour, from: date) == hour

    }
}
