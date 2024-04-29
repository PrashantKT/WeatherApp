//
//  WeatherInfoHeaderView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import SwiftUI

struct WeatherInfoHeaderView :  View {
    @State private var isExpanded = true

    @State private var temperature = 0
    @State private var trimEnd: CGFloat = 0.2
    @EnvironmentObject var weatherInfoVM:WeatherInfoViewModel
    

    var body: some View {
        VStack(alignment: .leading) {
          
            currentWeatherInfo
            if isExpanded {
                expandedView
                    .padding(.top,20)
            }
            
            
        }
        .padding()
        .coverFullScreen(alignment: .leading)
        .background(Color.appBackgroundSecond)
        .clipShape(.rect(cornerRadius: 8))
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.bouncy) {
                isExpanded.toggle()
            }
        }
        .shadow(radius: 2)
        
    }
    
    @ViewBuilder
    var currentWeatherInfo : some View {
        Text(weatherInfoVM.formattedDateTime)
            .fontNunito(.light, size: .smallFontSize)
            .foregroundStyle(Color.font)
        HStack{
            VStack(alignment: .leading) {
                HStack (spacing:2){
                    Text(weatherInfoVM.currentFormattedTemp)
                        .fontNunito(.semibold, size: 45)
                        .contentTransition(.numericText())

                    Text("°C")
                        .fontNunito(.semibold, size: .mediumFontSize)
                        .baselineOffset(29)
                }
                Text(weatherInfoVM.currentCondition.description)
                    .fontNunito(.light, size: .mediumFontSize)

                Text("Feels like \(weatherInfoVM.currentFeelsLikeFormattedTemp)°")
                    .fontNunito(.light, size: .mediumFontSize)
            }
            Spacer()
            weatherInfoVM.currentCondition.symbol
//                .symbolEffect(.variableColor.hideInactiveLayers, value: isExpanded)
                .foregroundStyle(weatherInfoVM.currentCondition.foregroundColor.gradient)
                .font(.system(size: 70))
                .rotationEffect(.degrees( isExpanded ? 360 : 0))
                .contentTransition(.symbolEffect(.replace))
        }
        
    }
    
    
    @ViewBuilder
    var expandedView : some View {
        VStack(spacing:16) {
            HStack {
                CommonTitleValueLabelView(title: "Sunrise", value:weatherInfoVM.sunriseTime())        .coverFullScreen()

                CommonTitleValueLabelView(title: "Daylight", value: weatherInfoVM.dayLightDuration())
                    .coverFullScreen()

                CommonTitleValueLabelView(title: "Sunset", value: weatherInfoVM.sunsetTime())        .coverFullScreen()

            }
            
            .background {
                daylightProgressView
            }
            HStack {
                CommonTitleValueLabelView(title: "t° max, min", value: weatherInfoVM.maxMinTemperature().max + "°, " + weatherInfoVM.maxMinTemperature().min + "°")
                    .coverFullScreen()

                uvIndexView
                CommonTitleValueLabelView(title: "Pressure", value: weatherInfoVM.pressure)        .coverFullScreen()

            }
            .padding(.top,12)

            HStack {
                CommonTitleValueLabelView(title: "Precipprob", value: weatherInfoVM.precipitationProbability())
                    .coverFullScreen()

                CommonTitleValueLabelView(title: "humidity", value: weatherInfoVM.humidity)        .coverFullScreen()

                CommonTitleValueLabelView(title: "Wind", value: weatherInfoVM.windSpeed + "m/s, " +  weatherInfoVM.windDirection)
                    .coverFullScreen()

            }
            .padding(.top,12)


        }
//        .coverFullScreen()
        .padding(.top,12)
    }
    
 
    @ViewBuilder var uvIndexView: some View {
        VStack(spacing:3) {
            Text("UV index")
                .fontNunito(.light, size: .smallFontSize)
                .foregroundStyle(Color.font)
            
            Text("")
                .fontNunito(.medium, size: .mediumFontSize)
                .coverFullScreen()
                .background{
                    RoundedRectangle(cornerRadius: 2)
//                        .fill(.clear)
                        .fill(.linearGradient(.init(colors: [.green,.yellow,.orange,.red]), startPoint: .leading, endPoint: .trailing))
                        .frame(height: 3)
                        .overlay(alignment:.center) {
                            
                            GeometryReader {proxy in
                                Circle()
                                    .foregroundStyle(Color.secondary)
                                    .frame(height:12)
                                    .position(x: proxy.frame(in: .local).maxX * weatherInfoVM.uvIndex(), y: proxy.frame(in: .local).midY)
                                    
                            }
                            .coverFullScreen()
                        }
                        .fontNunito(.medium, size: .mediumFontSize)

                }
        }
        .coverFullScreen()
    }
    
    @ViewBuilder
    var daylightProgressView : some View {
//        GeometryReader {proxy in
            ZStack {
              
                let diameter:CGFloat = 130
               
                Circle()
                    .trim(from: 0.2 ,to : 0.8)
                    .stroke(style: .init(dash: [8]))
                    .frame(width: diameter)
                    .rotationEffect( .degrees(90))
                    
                    


                let angleStart = calculatePointOnCircle(radius: diameter / 2, angle: .degrees((360 * 0.2) + 90))
                let angleEnd = calculatePointOnCircle(radius: diameter / 2, angle: .degrees((360 * 0.8) + 90))
                
                let sunPercentage = weatherInfoVM.calculateDayLightPercentage() / 100.0  // Convert percentage to a value between 0 and 1
                let scaledSunAngle = 0.2 + (sunPercentage * 0.6)  // Map the sun percentage to the circle's arc range 0.6 = 0.8 - 0.2 , formula is startRange + ( value * (endRane - startRange) )

                let sunPos = calculatePointOnCircle(radius: diameter / 2, angle: .degrees((360 * scaledSunAngle) + 90))
                
                let progressCircle = 0.2 + (0.6 * scaledSunAngle / 100)

                Circle()
                    .foregroundColor(.font)
                    .frame(width: 4)
                    .offset(x: angleStart.x,y:angleStart.y)
                Circle()
                    .foregroundColor(.font)
                    .frame(width: 4)
                    .offset(x: angleEnd.x,y:angleEnd.y)
                
                
              
                
                Circle()
                    .trim(from: 0.2 ,to : 0.8)
                    .fill(Color.clear.opacity(0.04))
                    .frame(width: diameter)
                    .rotationEffect(.degrees(90))
                    .overlay {
                        GeometryReader { proxy in
                            let midPoint = CGPoint(x:proxy.frame(in: .local).midX,y:proxy.frame(in: .local).midY)
                            let startAngle = Angle.degrees((360 * 0.2) + 90)
                            let endAngle = Angle.degrees((360 * scaledSunAngle) + 90)

                            Path { point in
                                point.addArc(center: midPoint, radius: diameter / 2, startAngle: endAngle, endAngle: startAngle, clockwise: true)
                                point.addLine(to: CGPoint(x: midPoint.x + sunPos.x, y: midPoint.y + angleStart.y))
                                point.addLine(to: CGPoint(x: midPoint.x + sunPos.x , y: midPoint.y + angleStart.y))
                                point.closeSubpath()
                            }
                            
                            .fill(.appBackgroundSecond.gradient)

                        }
                    }
                Group {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.mainTint)
                    //                    .font(.system(size: 12))
                        .offset(x: sunPos.x,y: sunPos.y)
                    
                    Circle()
                        .trim(from: 0.2 ,to :  scaledSunAngle)
                        .stroke()
                        .frame(width: diameter)
                        .rotationEffect(.degrees(90))
                      
                }
             

        }
        .frame(height: 130)
        .offset(y:12)
        

    }
    
    func calculatePointOnCircle(radius:CGFloat,angle:Angle) -> CGPoint {
        let x = 0 + (radius) * cos(angle.radians)
        let y = 0 + (radius ) * sin(angle.radians)
        return CGPoint(x: x, y: y)
    }
    

}

#Preview {
    WeatherInfoView()
}
