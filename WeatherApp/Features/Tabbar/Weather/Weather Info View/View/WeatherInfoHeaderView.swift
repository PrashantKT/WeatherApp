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

    let dayLightStart = Calendar.current.date(bySettingHour: Int.random(in: 5...6), minute: Int.random(in: 0...59), second: 0, of: Date())!
    let dayLightEnd = Calendar.current.date(bySettingHour: Int.random(in: 17...18), minute:Int.random(in: 0...59) , second: 0, of: Date())!
    let currentTempDate = Calendar.current.date(bySettingHour: Int.random(in: 13...14), minute:Int.random(in: 0...59) , second: 0, of: Date())!
    let currentUVIndex = CGFloat.random(in: 0.0...0.99)

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
        Text("Sat, 29 April, 04:59")
            .fontNunito(.light, size: .smallFontSize)
            .foregroundStyle(Color.font)
        HStack{
            VStack(alignment: .leading) {
                HStack (spacing:2){
                    Text("\(temperature)")
                        .fontNunito(.semibold, size: 45)
                        .contentTransition(.numericText())

                    Text("°C")
                        .fontNunito(.semibold, size: .mediumFontSize)
                        .baselineOffset(29)
                }
                Text("Clear")
                    .fontNunito(.light, size: .mediumFontSize)

                Text("Feels like 16°")
                    .fontNunito(.light, size: .mediumFontSize)
            }
            Spacer()
            Image(systemName: "moon.fill")
                .foregroundStyle(Color.yellow.gradient)
                .font(.system(size: 70))
                .rotationEffect(.degrees( isExpanded ? 360 : 0))
        }
        .onAppear {
            withAnimation(.bouncy) {
                temperature = Int.random(in: 16...20)
            }
        }
    }
    
    
    @ViewBuilder
    var expandedView : some View {
        VStack(spacing:16) {
            HStack {
                CommonTitleValueLabelView(title: "Sunrise", value: "04:52")        .coverFullScreen()

                CommonTitleValueLabelView(title: "Daylight", value: "13 h 33 min")        .coverFullScreen()

                CommonTitleValueLabelView(title: "Sunset", value: "04:52")        .coverFullScreen()

            }
            
            .background {
                daylightProgressView
            }
            HStack {
                CommonTitleValueLabelView(title: "t° max, min", value: "122° 116°")        .coverFullScreen()

                uvIndexView
                CommonTitleValueLabelView(title: "Pressure", value: "04:52")        .coverFullScreen()

            }
            .padding(.top,12)

            HStack {
                CommonTitleValueLabelView(title: "Precipprob", value: "0%")        .coverFullScreen()

                CommonTitleValueLabelView(title: "humidity", value: "77%")        .coverFullScreen()

                CommonTitleValueLabelView(title: "Wind", value: "5 m/s, SW")        .coverFullScreen()

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
                                    .position(x: proxy.frame(in: .local).maxX * currentUVIndex, y: proxy.frame(in: .local).midY)
                                    
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
                    .trim(from: 0.2 ,to : trimEnd )
                    .stroke(style: .init(dash: [8]))
                    .frame(width: diameter)
                    .rotationEffect( .degrees(90))
                    
                    


                let angleStart = calculatePointOnCircle(radius: diameter / 2, angle: .degrees((360 * 0.2) + 90))
                let angleEnd = calculatePointOnCircle(radius: diameter / 2, angle: .degrees((360 * 0.8) + 90))
                
                let sunPercentage = calculateDayLightPercentage() / 100.0  // Convert percentage to a value between 0 and 1
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
//                                point.move(to: CGPoint(x: midPoint.x + angleStart.x, y: midPoint.y + angleStart.y))
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
                        .trim(from: 0.2 ,to :  trimEnd)
                        .stroke()
                        .frame(width: diameter)
                        .rotationEffect(.degrees(90))
                      
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeIn(duration: 0.3)) {
                            trimEnd = scaledSunAngle
                        }
                    }
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
    
   
    func calculateDayLightPercentage() -> Double {
        let totalDaylightDuration = dayLightEnd.timeIntervalSince(dayLightStart)
        let elapsedTimeSinceDaylightStart = currentTempDate.timeIntervalSince(dayLightStart)

        let daylightPercentage = (elapsedTimeSinceDaylightStart / totalDaylightDuration) * 100
        return daylightPercentage
    }
}

#Preview {
    WeatherInfoView()
}
