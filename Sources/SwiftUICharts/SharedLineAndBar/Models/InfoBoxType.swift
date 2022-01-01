//
//  InfoBoxType.swift
//  
//
//  Created by Will Dale on 02/10/2021.
//

import SwiftUI

@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public enum InfoBoxType<ChartData>
where ChartData: InfoData,
      ChartData.DataPoint: DataPointDisplayable
{
    case verticle(chartData: ChartData, numberFormat: NumberFormatter = .default)
    case horizontal(chartData: ChartData, numberFormat: NumberFormatter = .default)
}

extension InfoBoxType {
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    internal func modifier<Content: View, S: Shape>(
        of view: Content,
        with style: InfoBoxStyle,
        and shape: S
    ) -> some View {
        Group {
            switch self {
            case let .verticle(data, numberFormat):
                view.modifier(VerticalInfoBoxViewModifier(chartData: data, style: style, shape: shape, numberFormat: numberFormat))
            case let .horizontal(data, numberFormat):
                view.modifier(HorizontalInfoBoxViewModifier(chartData: data, style: style, shape: shape, numberFormat: numberFormat))
            }
        }
    }
}
