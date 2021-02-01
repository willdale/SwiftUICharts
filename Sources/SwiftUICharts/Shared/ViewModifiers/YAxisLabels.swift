//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct YAxisLabels<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData: T

    let specifier       : String
    var labelsArray     : [Double] { chartData.getYLabels() }

    internal init(chartData: T,
                  specifier: String
    ) {
        self.chartData = chartData
        self.specifier = specifier
        chartData.viewData.hasYAxisLabels = true
    }
    
    internal var textAsSpacer: some View {
        Text("")
            .font(.caption)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
    
    internal var labels: some View {
        let labelsAndTop    = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .top
        let labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .bottom
        let numberOfLabels  = chartData.chartStyle.yAxisNumberOfLabels
        
        return VStack {
            if labelsAndTop {
                textAsSpacer
            }
            ForEach((0...numberOfLabels).reversed(), id: \.self) { i in
                Text("\(labelsArray[i], specifier: specifier)")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if i != 0 {
                    Spacer()
                        .frame(minHeight: 0, maxHeight: 500)
                }
            }
            if labelsAndBottom {
                textAsSpacer
            }
        }
        .if(labelsAndBottom) { $0.padding(.top, -8) }
        .if(labelsAndTop) { $0.padding(.bottom, -8) }
    }
    
    @ViewBuilder
    internal  func body(content: Content) -> some View {
        switch chartData.chartStyle.yAxisLabelPosition {
        case .leading:
            HStack {
//                if chartData.isGreaterThanTwo {
                    labels
//                }
                content
            }
        case .trailing:
            HStack {
                content
//                if chartData.isGreaterThanTwo {
                    labels
//                }
            }
        }
    }
}

extension View {
    /**
     Automatically generated labels for the Y axis
     - Parameters:
      - specifier: Decimal precision specifier
     - Returns: HStack of labels
     */
    public func yAxisLabels<T: LineAndBarChartData>(chartData: T, specifier: String = "%.0f") -> some View {
        self.modifier(YAxisLabels(chartData: chartData, specifier: specifier))
    }
}
