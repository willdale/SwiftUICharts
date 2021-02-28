//
//  ValueLabelCenterSubView.swift
//  
//
//  Created by Will Dale on 27/02/2021.
//

import SwiftUI

internal struct ValueLabelCenterSubView<T>: View where T: CTLineBarChartDataProtocol {

    private let chartData       : T
    private let markerValue     : Double
    private let specifier       : String
    private let labelColour     : Color
    private let labelBackground : Color
    private let lineColour      : Color
    private let strokeStyle     : StrokeStyle
    private let chartSize       : CGRect
    
    internal init(chartData       : T,
                  markerValue     : Double,
                  specifier       : String,
                  labelColour     : Color,
                  labelBackground : Color,
                  lineColour      : Color,
                  strokeStyle     : StrokeStyle,
                  chartSize       : CGRect
    ) {
        self.chartData       = chartData
        self.markerValue     = markerValue
        self.specifier       = specifier
        self.labelColour     = labelColour
        self.labelBackground = labelBackground
        self.lineColour      = lineColour
        self.strokeStyle     = strokeStyle
        self.chartSize       = chartSize
    }
    
    @State private var startAnimation : Bool = false
    
    var body: some View {
        Text("\(markerValue, specifier: specifier)")
            .font(.caption)
            .foregroundColor(labelColour)
            .padding()
            .background(labelBackground)
            .clipShape(DiamondShape())
            .overlay(DiamondShape()
                        .stroke(lineColour, style: strokeStyle)
            )
            .position(x: chartSize.width / 2,
                      y: getYPoint(chartType: chartData.chartType.chartType, chartSize: chartSize))
            .opacity(startAnimation ? 1 : 0)
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
            
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

