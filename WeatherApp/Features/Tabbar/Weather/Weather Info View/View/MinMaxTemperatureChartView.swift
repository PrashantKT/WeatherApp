//
//  WeatherMinMaxChartView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import SwiftUI

struct MinMaxTemperatureChartView : View {
    var maxWeeklyTemp:Int
    var minWeeklyTemp:Int
    var isCurrentDate:Bool = false
    init(maxWeeklyTemp: Int, minWeeklyTemp: Int,isCurrentDate:Bool = false ) {
        self.maxWeeklyTemp = maxWeeklyTemp
        self.minWeeklyTemp = minWeeklyTemp
        self.minV = Int.random(in: minWeeklyTemp...maxWeeklyTemp)
        self.maxV = Int.random(in: minV...maxWeeklyTemp)
        if isCurrentDate {
            self.currentValue = Int.random(in: minV...maxV)
            
        }
    }
    
    var minV:Int = 0
    var maxV:Int = 0
    var currentValue:Int? = nil

    var body: some View {
        VStack {
            HStack {
                Text("\(minV)")
                    .fontNunito(.medium, size: .smallFontSize)
                Spacer()
                Text("\(maxV)")
                    .fontNunito(.medium, size: .smallFontSize)
            }
            ZStack {
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.appBackgroundSecond)
                        .stroke(Color.appBackgroundSecond,lineWidth: 2)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.linearGradient(colors: [.loader.opacity(0.8),.loader,.loader.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: proxy.size.width * (calculateEndRangeOffset() - calculateStartRangeOffset()))
                        .coverH(alignment: .leading)
                        .offset(x:calculateStartRangeOffset() * proxy.size.width)
                        .saturation(10)

                   
                    if let currentValue {
                        Circle()
                            .fill(Color.mainTint)
                            .frame(width: 6)
                            .background(Circle().stroke(Color.red, lineWidth: 1.0))
//                            .shadow(Color.red,radius: 2)
                            .offset(x:calculateOffset(currentValue: currentValue) * proxy.size.width - 3)
                            .coverFullScreen(alignment: .leading)
                            
                    }
                }
                
            }.frame(height: 6)
        }
        .padding(.leading,12)
        .coverFullScreen()
    }
    
    func calculateStartRangeOffset() -> CGFloat {
        let startOffset = CGFloat(minV - minWeeklyTemp) / CGFloat(maxWeeklyTemp - minWeeklyTemp)
        return startOffset
    }
    
    func calculateEndRangeOffset() -> CGFloat {
        let startOffset = CGFloat(maxV - minWeeklyTemp) / CGFloat(maxWeeklyTemp - minWeeklyTemp)
        return startOffset
    }
    
    func calculateOffset(currentValue:Int) -> CGFloat {
        let percentage = CGFloat(currentValue - minWeeklyTemp) / CGFloat(maxWeeklyTemp - minWeeklyTemp)
        return percentage
    }
}

#Preview {
    MinMaxTemperatureChartView(maxWeeklyTemp: 50, minWeeklyTemp: 30,isCurrentDate: true)
}
