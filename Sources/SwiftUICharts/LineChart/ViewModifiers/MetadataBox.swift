//
//  MetadataBox.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import SwiftUI

internal struct TitleBox: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    let showTitle   : Bool
    let showSubtitle: Bool
    
    init(showTitle      : Bool = true,
         showSubtitle   : Bool = true
    ) {
        self.showTitle     = showTitle
        self.showSubtitle  = showSubtitle
    }
    
    internal func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            if showTitle, let title = chartData.metadata?.title {
                Text(title)
                    .font(.title3)
            }
            if showSubtitle, let subtitle = chartData.metadata?.subtitle {
                Text(subtitle)
                    .font(.subheadline)
            }
            content
        }
    }
}

extension View {
    public func titleView() -> some View {
        self.modifier(TitleBox())
    }
}
