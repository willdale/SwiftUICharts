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
        let labelsAndTop    = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabels.labelPosition == .top
        let labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabels.labelPosition == .bottom
        let numberOfLabels  = chartData.chartStyle.yAxisLabels.numberOfLabels
        
        return VStack {
            if labelsAndTop {
                Text("")
                    .font(.caption)
                Spacer()
            }
            ForEach((0...numberOfLabels).reversed(), id: \.self) { i in
                Text("\(labelsArray[i], specifier: specifier)")
                    .font(.caption)
                if i != 0 {
                    Spacer()
                }
            }
            if labelsAndBottom {
                Text("")
                    .font(.caption)
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
        switch chartData.chartStyle.yAxisLabels.labelPosition {
        case .leading:
            HStack {
                labels
                content
            }
        case .trailing:
            HStack {
                content
                labels
            }
        }
    }
    
    internal func getLabels() -> [Double] {
        let numberOfLabels = chartData.chartStyle.yAxisLabels.numberOfLabels
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
