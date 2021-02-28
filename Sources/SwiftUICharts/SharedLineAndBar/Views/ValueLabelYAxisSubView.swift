//
//  ValueLabelYAxisSubView.swift
//  
//
//  Created by Will Dale on 27/02/2021.
//

import SwiftUI

internal struct ValueLabelYAxisSubView<T>: View where T: CTLineBarChartDataProtocol {

   @ObservedObject var chartData: T
   private let markerValue     : Double
   private let specifier       : String
   private let labelColour     : Color
   private let labelBackground : Color
   private let lineColour      : Color
   private let chartSize       : CGRect
    
    internal init(chartData       : T,
                  markerValue     : Double,
                  specifier       : String,
                  labelColour     : Color,
                  labelBackground : Color,
                  lineColour      : Color,
                  chartSize       : CGRect
    ) {
        self.chartData       = chartData
        self.markerValue     = markerValue
        self.specifier       = specifier
        self.labelColour     = labelColour
        self.labelBackground = labelBackground
        self.lineColour      = lineColour
        self.chartSize       = chartSize
    }
    
    var body: some View {
        Text("\(markerValue, specifier: specifier)")
            .font(.caption)
            .foregroundColor(labelColour)
            .padding(4)
            .background(labelBackground)
            
            .ifElse(self.chartData.chartStyle.yAxisLabelPosition == .leading, if: {
                $0
                    .clipShape(LeadingLabelShape())
                    .overlay(LeadingLabelShape()
                                .stroke(lineColour)
                    )
                    
                    .position(x: -(chartData.infoView.yAxisLabelWidth / 2) - 6,
                              y: getYPoint(chartType: chartData.chartType.chartType, chartSize: chartSize))
            }, else: {
                $0
                    .clipShape(TrailingLabelShape())
                    .overlay(TrailingLabelShape()
                                .stroke(lineColour)
                    )
                    .position(x: chartSize.width + (chartData.infoView.yAxisLabelWidth / 2),
                              y: getYPoint(chartType: chartData.chartType.chartType, chartSize: chartSize))
            })
            
    }
    
    private func getYPoint(chartType: ChartType, chartSize: CGRect) -> CGFloat {
         switch chartData.chartType.chartType {
         case .line:
            let y = chartSize.height / CGFloat(chartData.range)
            return (CGFloat(markerValue - chartData.minValue) * -y) + chartSize.height
         case .bar:
            let y = chartSize.height / CGFloat(chartData.maxValue)
             return  chartSize.height - CGFloat(markerValue) * y
         case .pie:
             return 0
         }
     }
}
