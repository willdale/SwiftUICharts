//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/**
 Automatically generated labels for the Y axis.
 */
internal struct YAxisLabels<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject var chartData: T
    
    private let specifier       : String
    private var labelsArray     : [Double] { chartData.getYLabels() }
    
    private let labelsAndTop    : Bool
    private let labelsAndBottom : Bool
    
    internal init(chartData: T,
                  specifier: String
    ) {
        self.chartData = chartData
        self.specifier = specifier
        chartData.viewData.hasYAxisLabels = true
        
        labelsAndTop    = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .top
        labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .bottom
    }
    
    @State private var height : CGFloat = 0
    @State private var axisLabelWidth : CGFloat = 0
    
    @ViewBuilder private var axisTitle: some View {
        if let title = chartData.chartStyle.yAxisTitle {
            VStack {
                Text(title)
                    .font(.caption)
                    .rotationEffect(Angle.init(degrees: -90), anchor: .center)
                    .fixedSize()
                    .frame(width: axisLabelWidth)
                Spacer()
                    .frame(height: (self.chartData.viewData.xAxisLabelHeights.max(by: { $0 < $1 }) ?? 0) + axisLabelWidth)
            }
            .onAppear {
                axisLabelWidth = 20
            }
        }
    }
    
    private var labels: some View {
        VStack {
            ForEach((0...chartData.chartStyle.yAxisNumberOfLabels-1).reversed(), id: \.self) { i in
                Text("\(labelsArray[i], specifier: specifier)")
                    .font(.caption)
                    .foregroundColor(chartData.chartStyle.yAxisLabelColour)
                    .lineLimit(1)
                    .accessibilityLabel(Text("Y Axis Label"))
                    .accessibilityValue(Text("\(labelsArray[i], specifier: specifier)"))
                if i != 0 {
                    Spacer()
                        .frame(minHeight: 0, maxHeight: 500)
                }
            }
            Spacer()
                .frame(height: (chartData.viewData.xAxisLabelHeights.max(by: { $0 < $1 }) ?? 0) + chartData.viewData.xAxisTitleHeight)
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
                        self.height = geo.frame(in: .local).height
                    }
                    .onChange(of: axisLabelWidth) { width in
                        chartData.infoView.yAxisLabelWidth = geo.frame(in: .local).size.width + width
                    }
            }
        )
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                switch chartData.chartStyle.yAxisLabelPosition {
                case .leading:
                    HStack(spacing: 0) {
                        axisTitle
                        labels
                        content
                    }
                case .trailing:
                    HStack(spacing: 0) {
                        content
                        labels
                        axisTitle
                    }
                }
            } else { content }
        }
    }
}

extension View {
    /**
     Automatically generated labels for the Y axis.
     
     Controls are in ChartData --> ChartStyle
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Filled Line Chart
     - Ranged Line Chart
     - Bar Chart
     - Grouped Bar Chart
     - Stacked Bar Chart
     - Ranged Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
      - specifier: Decimal precision specifier
     - Returns: HStack of labels
     */
    public func yAxisLabels<T: CTLineBarChartDataProtocol>(chartData: T, specifier: String = "%.0f") -> some View {
        self.modifier(YAxisLabels(chartData: chartData, specifier: specifier))
    }
}
