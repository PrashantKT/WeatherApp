//
//  LoaderView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 13/03/24.
//

import SwiftUI



struct LoaderView:ViewModifier {
    @Binding var isLoading:Bool
    @State private var isAnimating = false
    @Environment (\.colorScheme) var colorScheme:ColorScheme

    func body(content: Content) -> some View {
        
       
        content.overlay {
            if isLoading {
                 VStack {
                     cloudAndSun
                    .offset(x:-10,y:-50)
                     
                     Text("Please Wait...")
                         .fontNunito(.semibold, size: 22)
                 }
                 .coverFullScreen()
                 .background(.ultraThinMaterial)
                 .saturation(1.9)
                 .onAppear {
                     withAnimation(.linear(duration: 3).repeatForever(autoreverses: true)) {
                         isAnimating = true
                     }
                 }
                 .onDisappear {
                     isAnimating = false
                 }
                 .onTapGesture {
                     isLoading.toggle()
                 }
            }
        }
    }
    
    @ViewBuilder var cloudAndSun : some View {
        ZStack {
            Image(systemName: "cloud.fill")
                .transition(.symbolEffect(.appear))
                .foregroundStyle(isAnimating ? Color.loader.gradient : Color.gray.gradient)
                .font(.system(size: 70))
                .opacity(isAnimating ? 1.0 : 0.9)


            Image(systemName:  "sun.max.fill" )
//                .transition(.symbolEffect(.appear))
                .foregroundStyle(isAnimating ? Color.yellow.gradient : Color.orange.gradient)
                .font(.system(size: 70))
                .rotationEffect(isAnimating ? .degrees(90) : .degrees(0))
                .symbolEffect(.variableColor, options: .default, value: isAnimating)
                .offset(x:20,y:17)
                .scaleEffect(isAnimating ? 1.0 : 0.9)
                .opacity(isAnimating ? 1.0 : 0.6)
//                .zIndex(isAnimating ? 2 : 1)

            
            Image(systemName: "cloud.fill")
                .transition(.symbolEffect(.appear))
                .foregroundStyle(isAnimating ? Color.gray.gradient : Color.loader.gradient)
                .font(.system(size: 70))
                .offset(x: 40  ,y: 35)
                .opacity(isAnimating ? 1.0 : 0.8)

//                .scaleEffect(isAnimating ? 0.9 : 0.5)

            
        }
    }
    
}

#Preview {
    ContentView()
        
        .modifier(LoaderView(isLoading: .constant(true)))
        
}
