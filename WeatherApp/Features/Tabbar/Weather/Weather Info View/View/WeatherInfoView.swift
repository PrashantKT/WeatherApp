//
//  WeatherInfoView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 15/03/24.
//

import SwiftUI
import CoreLocation

struct WeatherInfoView: View {
    @Environment(\.dismiss) var dismiss
    var coordinates:CLLocationCoordinate2D = .init()
    
    var body: some View {
        NavigationStack {
            Text("Hello, World! \(coordinates.latitude), \(coordinates.longitude) ")
                .navigationTitle("Weather")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(role: .cancel) {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .cancel) {
                            
                        } label: {
                            Text("Add")
                        }
                    }
                }
        }
    }
}

#Preview {
    WeatherInfoView()
}
