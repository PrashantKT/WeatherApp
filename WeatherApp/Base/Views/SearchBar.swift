//
//  SearchBar.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 14/03/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText:String
    var focusState:FocusState<Bool>.Binding
    var body: some View {
        
        HStack(spacing:14) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.font)
                    .padding(.leading,8)
                TextField("Search Location", text: $searchText)
                    .focused(focusState)
                    .fontNunito(.medium, size: 14)
                    .autocorrectionDisabled()
                    .onSubmit {
                        focusState.wrappedValue.toggle()
                    }
                
                    .frame(height: 55)
                if !searchText.isEmpty {
                    Button("", systemImage: "xmark.circle.fill") {
                        searchText = ""
                    }
                    .frame(width: 55,height: 55)
                    .foregroundStyle(.font)
                }
                
            }
            .background(.appBackgroundSecond, in: RoundedRectangle(cornerRadius: 6))
            
            if !searchText.isEmpty || focusState.wrappedValue{
                Button("Cancel") {
                    withAnimation {
                        searchText = ""
                        focusState.wrappedValue = false

                    }
                }
                .fontNunito(.semibold, size: 14)
                .foregroundStyle(.mainTint)
            }

        }
        .shadow(color: Color.primary.opacity(0.1),radius: 1)

    }
}

#Preview {
    @FocusState var focus: Bool
    return SearchBar(searchText: .constant(""), focusState: $focus).padding().coverFullScreen().background(Color.appBackground)
}
