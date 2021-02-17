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
    
    let labelsAndTop    : Bool
    let labelsAndBottom : Bool
    
    internal init(chartData: T,
                  specifier: String
    ) {
        self.chartData = chartData
        self.specifier = specifier
        chartData.viewData.hasYAxisLabels = true
        
        labelsAndTop    = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .top
        labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .bottom
    }
    
    internal var textAsSpacer: some View {
        Text("")
            .font(.caption)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
    
    internal var labels: some View {
        VStack {
            if labelsAndTop {
                textAsSpacer
            }
            ForEach((0...chartData.chartStyle.yAxisNumberOfLabels).reversed(), id: \.self) { i in
                Text("\(labelsArray[i], specifier: specifier)")
                    .font(.caption)
                    .foregroundColor(chartData.chartStyle.yAxisLabelColour)
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
        .padding(.trailing, 10)
        .background(
            GeometryReader { geo in
                Rectangle()
                    .foregroundColor(Color.clear)
                    .onAppear {
                        chartData.infoView.yAxisLabelWidth = geo.frame(in: .local).size.width
                    }
            }
        )
    }
    
    internal  func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                switch chartData.chartStyle.yAxisLabelPosition {
                case .leading:
                    HStack(spacing: 0) {
                        labels
                        content
                    }
                case .trailing:
                    HStack(spacing: 0) {
                        content
                        labels
                    }
                }
            } else { content }
        }
    }
}

extension View {
    /**
     Automatically generated labels for the Y axis
     
     Controls are in ChartData --> ChartStyle
     
     - Requires:
     Chart Data to conform to LineAndBarChartData.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Bar Chart
     - Grouped Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
      - specifier: Decimal precision specifier
     - Returns: HStack of labels
     - Tag: YAxisLabels
     */
    public func yAxisLabels<T: LineAndBarChartData>(chartData: T, specifier: String = "%.0f") -> some View {
        self.modifier(YAxisLabels(chartData: chartData, specifier: specifier))
    }
}
