//
//  WeatherIconView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import SwiftUI

struct WeatherIconView : View {
    var systemIcon:String = "cloud.moon"
    var systemIconColor:Color = Color.primary

    var width:CGFloat = 65
    var overlayText:String? = "100%"
    let colors = [Color.appBackground.opacity(0.9),Color.appBackgroundSecond.opacity(0.8),Color.appBackgroundSecond.opacity(0.7),Color.appBackgroundSecond.opacity(0.55),Color.appBackgroundSecond.opacity(0.2)]
    var body: some View {
        ZStack {

            Image(systemName: systemIcon)
                .font(.title)
                .foregroundStyle(systemIconColor)
            if let overlayText {
                Text(overlayText)
                    .fontNunito(.medium, size: 10)
                    .padding(.horizontal,4)
                    .background(.secondary.opacity(0.7))
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomTrailing)
                    .offset(y:5)
                    
            }
        }
        .frame(width: width,height: width)
        .background(Color.appBackgroundSecond)
        .background(in: .rect(cornerRadius: 8))
        .compositingGroup()
        .shadow(radius: 1)

    }
}


#Preview {
    ZStack {
        Color.appBackground
        WeatherIconView()
    }
    
}
