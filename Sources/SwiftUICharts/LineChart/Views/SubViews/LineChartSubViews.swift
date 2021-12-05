//
//  LineChartSubViews.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

// MARK: - Single colour


internal struct FilledLineChartSubView<CD, DS>: View where CD: CTLineChartDataProtocol,
                                                           DS: CTLineChartDataSet,
                                                           DS.DataPoint: CTStandardDataPointProtocol & Ignorable {
    @ObservedObject private var chartData: CD
    private let dataSet: DS
    private let minValue: Double
    private let range: Double
    private let colour: ChartColour
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: CD,
        dataSet: DS,
        minValue: Double,
        range: Double,
        colour: ChartColour
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
        self.minValue = minValue
        self.range = range
        self.colour = colour
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        LineShape(dataPoints: dataSet.dataPoints,
                  lineType: dataSet.style.lineType,
                  isFilled: true,
                  minValue: minValue,
                  range: range,
                  ignoreZero: dataSet.style.ignoreZero)
            .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
            .fill(colour)
        
        
            .if(chartData.viewData.hasXAxisLabels) { $0.xAxisBorder(chartData: chartData) }
            .if(chartData.viewData.hasYAxisLabels) { $0.yAxisBorder(chartData: chartData) }

            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
        
            .background(Color(.gray).opacity(0.000000001))
    }
}


 internal struct LineChartSubView<CD, DS>: View where CD: CTLineChartDataProtocol,
                                                      DS: CTLineChartDataSet,
                                                      DS.DataPoint: CTStandardDataPointProtocol & Ignorable {
     @ObservedObject private var chartData: CD
     private let dataSet: DS
     private let minValue: Double
     private let range: Double
     private let colour: ChartColour
     
     @State private var startAnimation: Bool
     
     internal init(
         chartData: CD,
         dataSet: DS,
         minValue: Double,
         range: Double,
         colour: ChartColour
     ) {
         self.chartData = chartData
         self.dataSet = dataSet
         self.minValue = minValue
         self.range = range
         self.colour = colour
         
         self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
     }
     
     internal var body: some View {
         LineShape(dataPoints: dataSet.dataPoints,
                   lineType: dataSet.style.lineType,
                   isFilled: false,
                   minValue: minValue,
                   range: range,
                   ignoreZero: dataSet.style.ignoreZero)
             .trim(to: startAnimation ? 1 : 0)
             .stroke(colour, strokeStyle: dataSet.style.strokeStyle)

             .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                 self.startAnimation = true
             }
             .background(Color(.gray).opacity(0.000000001))
             .onDisappear {
                 self.startAnimation = false
             }
     }
 }
 
