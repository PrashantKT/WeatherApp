//
//  Colors.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 13/03/24.
//

import SwiftUI

extension View {
    
    func coverFullScreen(alignment:Alignment = .center) -> some View  {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: alignment)
    }
    
    func coverH(alignment:Alignment = .center) -> some View  {
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    
    func coverV(alignment:Alignment = .center) -> some View  {
        self
            .frame(maxHeight:.infinity,alignment: alignment)
    }
}
