//
//  LineAndBarProtocolsExtentions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

extension AxisX where Self: CTChartData & ViewDataProtocol {

    @ViewBuilder
    internal func getAxisColourAsCircle(customColour: ChartColour, width: CGFloat) -> some View {
        Group {
            switch customColour {
            case let .colour(colour):
                HStack {
                    Circle()
                        .fill(colour)
                        .frame(width: width, height: width)
                }
            case let .gradient(colours, _, _):
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: colours),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: width, height: width)
                }
            case let .gradientStops(stops, _, _):
                let stops = stops
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: width, height: width)
                }
            }
        }
    }
}
