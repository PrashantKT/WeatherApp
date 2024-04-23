//
//  WeatherHourlyView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import SwiftUI

struct WeatherHourlyView: View {
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing:0) {
                ForEach(1...24,id: \.self) { i in

                    VStack(spacing:0) {
                        WeatherIconView(width: 55).padding()

                        CommonTitleValueLabelView(title: "7:00", value: "21°")
                    }
                    .coverFullScreen()
                }

            }
        }
    }
}



#Preview {
    WeatherHourlyView()
}
