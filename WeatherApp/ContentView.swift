//
//  ContentView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 06/03/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = false
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(spacing:30) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.mainTint)
                Text("Hello, world!")
                    .fontNunito(.medium, size: 30)
                Text("Hello, world!")
                    .fontNunito(.light, size: 30)
                Text("Hello, world!")
                    .fontNunito(.regular, size: 30)
                Text("Hello, world!")
                    .fontNunito(.semibold, size: 30)
                    .foregroundStyle(.font)


            }
            .padding()
            .background(Color.appBackgroundSecond)
            .onTapGesture {
                isLoading.toggle()
            }
            .coverFullScreen()
            .modifier(LoaderView(isLoading: $isLoading))
        }
    }
}

#Preview {
    ContentView()
}
