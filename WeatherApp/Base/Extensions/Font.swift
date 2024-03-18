//
//  Font.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 13/03/24.
//

import SwiftUI


enum FontStyle {
    case light
    case medium
    case regular
    case semibold
    
    var fontName:String {
        switch self {
        case .light:
            "Nunito-Light"
        case .medium:
            "Nunito-Medium"
        case .regular:
            "Nunito-Regular"
        case .semibold:
            "Nunito-SemiBold"
        }
    }
}

extension View {
    
    func fontNunito(_ style:FontStyle,size:CGFloat) -> some View {
        self
            .font(.custom(style.fontName, size: size))
        
    }
}
