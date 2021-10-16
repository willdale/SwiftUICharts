//
//  InfoBoxType.swift
//  
//
//  Created by Will Dale on 02/10/2021.
//

import SwiftUI

@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public enum InfoBoxType<ChartData>
where ChartData: CTLineBarChartDataProtocol & InfoData {
    case verticle(chartData: ChartData)
    case horizontal(chartData: ChartData)
    
    public func modifier<Content: View, S: Shape>(
        of view: Content,
        with style: InfoBoxStyle,
        and shape: S
    ) -> some View {
        Group {
            switch self {
            case .verticle(let data):
                view.modifier(VerticalInfoBoxViewModifier(chartData: data, style: style, shape: shape))
            case .horizontal(let data):
                view.modifier(HorizontalInfoBoxViewModifier(chartData: data, style: style, shape: shape))
            }
        }
    }
}
