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
                 .onAppear {
                     withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
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
                .foregroundStyle(Color.loader)
                .font(.system(size: 70))
                

            Image(systemName: "sun.max.fill")
                .transition(.symbolEffect(.appear))
                .foregroundStyle(Color.yellow.gradient)
                .font(.system(size: 70))
                .rotationEffect(isAnimating ? .degrees(360) :     .degrees(0))
                .symbolEffect(.variableColor, options: .repeating, value: isAnimating)
                .offset(x:20,y:17)

            
            Image(systemName: "cloud.fill")
                .transition(.symbolEffect(.appear))
                .foregroundStyle(Color.loader)
                .font(.system(size: 70))
                .offset(x:40,y:35)
            
            
        }
    }
    
}

#Preview {
    ContentView()
        
        .modifier(LoaderView(isLoading: .constant(true)))
        
}
