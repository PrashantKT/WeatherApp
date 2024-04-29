//
//  Double + Fromat.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 25/04/24.
//

import Foundation

extension Double {
    
    func formattedDecimal(_ value:Int) -> String {
    
        return self.formatted(.number.precision(.fractionLength(value)))
    }
}
