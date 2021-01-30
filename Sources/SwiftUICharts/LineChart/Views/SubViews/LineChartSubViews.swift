//
//  LineChartSubViews.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

struct LineChartColourSubView<CD>: View where CD: LineAndBarChartData {
    
    let chartData   : CD
    let dataSet     : LineDataSet
    let style       : LineStyle
    let minValue    : Double
    let range       : Double
    let colour      : Color
    
    let isFilled    : Bool
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        
        LineShape(dataSet: dataSet, lineType: style.lineType, isFilled: isFilled, minValue: minValue, range: range)
            .ifElse(isFilled, if: {
                $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                  .fill(colour)
            }, else: {
                $0.trim(to: startAnimation ? 1 : 0)
                  .stroke(colour, style: Stroke.strokeToStrokeStyle(stroke: style.strokeStyle))
            })

            .background(Color(.gray).opacity(0.01))
            .if(chartData.viewData.hasXAxisLabels) { $0.xAxisBorder(chartData: chartData) }
            .if(chartData.viewData.hasYAxisLabels) { $0.yAxisBorder(chartData: chartData) }
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}

struct LineChartColoursSubView<CD>: View where CD: LineAndBarChartData {
    
    let chartData   : CD
    let dataSet     : LineDataSet
    let style       : LineStyle
    let minValue    : Double
    let range       : Double
    let colours     : [Color]
    let startPoint  : UnitPoint
    let endPoint    : UnitPoint
    
    let isFilled    : Bool
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        
        LineShape(dataSet: dataSet, lineType: style.lineType, isFilled: isFilled, minValue: minValue, range: range)
            
            .ifElse(isFilled, if: {
                $0
                    .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                    .fill(LinearGradient(gradient: Gradient(colors: colours),
                                         startPoint: startPoint,
                                         endPoint: endPoint))
            }, else: {
                $0
                    .trim(to: startAnimation ? 1 : 0)
                    .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: Stroke.strokeToStrokeStyle(stroke: style.strokeStyle))
            })
            
            
            .background(Color(.gray).opacity(0.01))
            .if(chartData.viewData.hasXAxisLabels) { $0.xAxisBorder(chartData: chartData) }
            .if(chartData.viewData.hasYAxisLabels) { $0.yAxisBorder(chartData: chartData) }
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}

struct LineChartStopsSubView<CD>: View where CD: LineAndBarChartData {
    
    let chartData   : CD
    let dataSet     : LineDataSet
    let style       : LineStyle
    let minValue    : Double
    let range       : Double
    let stops       : [Gradient.Stop]
    let startPoint  : UnitPoint
    let endPoint    : UnitPoint
    
    let isFilled    : Bool
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        
        LineShape(dataSet: dataSet, lineType: style.lineType, isFilled: isFilled, minValue: minValue, range: range)
            
            .ifElse(isFilled, if: {
                $0
                    .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                    .fill(LinearGradient(gradient: Gradient(stops: stops),
                                           startPoint: startPoint,
                                           endPoint: endPoint))
            }, else: {
                $0
                    .trim(to: startAnimation ? 1 : 0)
                    .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: Stroke.strokeToStrokeStyle(stroke: style.strokeStyle))
            })

            .background(Color(.gray).opacity(0.01))
            .if(chartData.viewData.hasXAxisLabels) { $0.xAxisBorder(chartData: chartData) }
            .if(chartData.viewData.hasYAxisLabels) { $0.yAxisBorder(chartData: chartData) }
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}

