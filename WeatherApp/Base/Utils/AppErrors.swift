//
//  AppErrors.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 17/03/24.
//

import SwiftUI


enum AppError :LocalizedError {
    case locationPermission
    
    
    var errorDescription: String? {
        switch self {
        case .locationPermission:
            "Location could not fetched"
        }
    }
    
    var errorMessage : String? {
        switch self {
        case .locationPermission:
            "Location permission required to fetch your current location"
        }
    }
}



struct ErrorAlert<T:View> : ViewModifier  {
    
    @Binding var error : AppError?
    var actions:((AppError?) -> T)
    init(error: Binding<AppError?>,  @ViewBuilder action: @escaping ((AppError?) -> T)  = { _ in EmptyView()} ) {
        _error = error
        actions = action
    }
    
    var isShowingError:Binding<Bool> {
        Binding {
            error != nil
        } set: { newValue in
            error = nil
        }

    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .alert(isPresented: isShowingError, error: error) { error in
                actions(error)
            } message: { error in
                if let error = error.errorMessage {
                    Text(error)
                        .fontNunito(.medium, size: 14)
                }
            }

    }
}


extension View {
    func showErrorAlert(error:Binding<AppError?>,@ViewBuilder actions: @escaping ((AppError?) -> some View) = { _ in EmptyView() } ) -> some View {
        self.modifier(ErrorAlert(error: error,action: actions))
        
    }
    
}
