//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import SwiftUI

struct DateForecastView: View {
    var dayRange:ForecastDayRange
    
    @StateObject private var viewModel:ViewModel
    @Environment(\.dismiss) var dismiss
    init(dayRange: ForecastDayRange = .days(number: 10)) {
        self.dayRange = dayRange
        _viewModel = StateObject(wrappedValue: ViewModel(dayRange: dayRange))
    }
    
    var body: some View {
        VStack {
            headerView
            ScrollView {
                ForEach(viewModel.sessions) { i in
                    sessionForecast(session: i)
                    Divider()
                    
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("10 Day forecast")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .font(.title2).bold()
                            .foregroundStyle(.mainTint)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("info 1", action: {})
                        Button("Info 2", action: {})
                    } label: {
                        Image(systemName: "i.circle")
                            .font(.title2)
                            .foregroundStyle(.mainTint)
                    }
                    .fontNunito(.semibold, size: .mediumFontSize)
                }
            }

        }
        .background(Color.appBackground)
        .task {
            await self.viewModel.fetchSessionWiseForecast(for: viewModel.selectedDate)
        }
        
    }
    
    @ViewBuilder
    func sessionForecast(session:SessionForeCast) -> some View {
        VStack(alignment: .leading,spacing:14) {
            HStack {
                VStack(alignment: .leading,spacing:16) {
                    
                    Text(session.session.rawValue)
                        .fontNunito(.medium, size: .mediumFontSize)
                        .foregroundStyle(.font)
                    
                    HStack {
                        Text("\(session.temperature)°")
                            .fontNunito(.regular, size: .largeFontSize)
                        Group {
                            Image(systemName: "thermometer.medium")
                                .foregroundStyle(.blue.gradient)
                            Text("\(session.feelLike)°")
                                .fontNunito(.regular, size: .mediumFontSize)
                        }
                    }
                    .padding(.top,12)
                    
                    Text("\(session.condition.description)")
                        .fontNunito(.semibold, size: .mediumFontSize)
                  
                }
                .coverFullScreen(alignment: .leading)
                
                
                session.condition.symbol!
                    .font(.system(size: 55))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(session.condition.foregroundColor)
                    .symbolEffect(.variableColor, value: session.condition.symbol)
                
            }
            
            HStack(spacing:12) {
                Label(
                    title: { Text(session.windDirection) },
                    icon: { Image(systemName: "location").foregroundStyle(.blue.gradient) }
                )
                Label(
                    title: { Text(session.pressure) },
                    icon: { Image(systemName: "barometer").foregroundStyle(.blue.gradient) }
                )
                Label(
                    title: { Text(session.humidity) },
                    icon: { Image(systemName: "drop").foregroundStyle(.blue.gradient) }
                )
            }
            .fontNunito(.semibold, size: .mediumFontSize)
            
            Label(
                title: { Text(session.windGust) },
                icon: { Image(systemName: "wind").foregroundStyle(.blue.gradient) }
            )

        }
        .padding()
    }
    
    @ViewBuilder var headerView : some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.dates,id: \.self) { date in
                    VStack {
                        Text(date.weekSymbol().prefix(2))
                            .fontNunito(.medium, size: .smallFontSize)
                            .foregroundStyle(date == viewModel.selectedDate ? Color.appBackground : .primary)
                        Text(date.formatted(.dateTime.day()))
                            .fontNunito(.medium, size: .mediumFontSize)
                            .foregroundStyle(date == viewModel.selectedDate ? Color.appBackground : .primary)
                        
                    }
                    .padding()
                    .background(date == viewModel.selectedDate ? .mainTint : .clear,in: .rect(cornerRadius: 8))
                    .contentShape(.rect)
                    .onTapGesture {
                        Task {
                            
                            viewModel.selectedDate = date
                            
                            await self.viewModel.fetchSessionWiseForecast(for: viewModel.selectedDate)
                        }
                    }
                    .id(date)
                }
                
            }
            
            //            .scrollTargetLayout()
            
        }
        .scrollPosition(id: $viewModel.scrollPos,anchor: .center)
        .padding(.vertical)
        .contentMargins(.horizontal,12)
        .background(Color.appBackgroundSecond)
        .onAppear {
            viewModel.scrollPos = viewModel.selectedDate
        }
        
        
            
        

    }
    
    
    var bodyView: some View {
        ZStack {
            Text("Hello")
        }
    }
}

#Preview {
    NavigationStack {
        DateForecastView()
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("10 Day forecast")
    }
}
