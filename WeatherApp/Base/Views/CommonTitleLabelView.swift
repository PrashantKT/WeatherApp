//
//  CommonTitleLabelView.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 22/04/24.
//

import SwiftUI

struct CommonTitleValueLabelView : View {
    var title:String,value:String
    var body: some View {
        VStack(spacing:0) {
            Text(title)
                .fontNunito(.light, size: .smallFontSize + 2)
                .foregroundStyle(Color.font)
            Text(value)
                .fontNunito(.semibold, size: .mediumFontSize + 1)
        }
    }


}


#Preview {
    CommonTitleValueLabelView(title: "Title", value: "21")
}
