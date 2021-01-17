//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct YAxisLabels: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData

    let specifier       : String
    var labelsArray     : [Double] { getLabels() }

    internal init(specifier: String) {
        self.specifier = specifier
    }

    internal var labels: some View {
        let labelsAndTop    = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .top
        let labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .bottom
        let numberOfLabels  = chartData.chartStyle.yAxisNumberOfLabels
        
        return VStack {
            if labelsAndTop {
                Text("")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
                    .frame(minHeight: 0, maxHeight: 500)
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
                Text("")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
        .if(labelsAndBottom) { $0.padding(.top, -8) }
        .if(labelsAndTop) { $0.padding(.bottom, -8) }
        .onAppear {
            chartData.viewData.hasYAxisLabels = true
        }
    }
    
    @ViewBuilder
    internal  func body(content: Content) -> some View {
        switch chartData.chartStyle.yAxisLabelPosition {
        case .leading:
            HStack {
                if chartData.isGreaterThanTwo {
                    labels
                }
                content
            }
        case .trailing:
            HStack {
                content
                if chartData.isGreaterThanTwo {
                    labels
                }
            }
        }
    }
    
    internal func getLabels() -> [Double] {
        let numberOfLabels = chartData.chartStyle.yAxisNumberOfLabels
        switch chartData.viewData.chartType {
        case .line:
            return self.getYLabelsLineChart(numberOfLabels)
        case .bar:
            return self.getYLabelsBarChart(numberOfLabels)
        }
    }

    internal func getYLabelsLineChart(_ numberOfLabels: Int) -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double    = chartData.range()
        let minValue    : Double    = chartData.minValue()
        let range       : Double    = dataRange / Double(numberOfLabels)
        labels.append(minValue)
        for index in 1...numberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }
    internal func getYLabelsBarChart(_ numberOfLabels: Int) -> [Double] {
        var labels : [Double]  = [Double]()
        for index in 0...numberOfLabels {
            labels.append(chartData.maxValue() / Double(numberOfLabels) * Double(index))
        }
        return labels
    }
}

extension View {
    /**
     Automatically generated labels for the Y axis
     - Parameters:
      - specifier: Decimal precision specifier
     - Returns: HStack of labels
     */
    public func yAxisLabels(specifier: String = "%.0f") -> some View {
        self.modifier(YAxisLabels(specifier: specifier))
    }
}
