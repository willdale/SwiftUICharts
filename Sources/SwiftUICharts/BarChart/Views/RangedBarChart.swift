//
//  RangedBarChart.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

public struct RangedBarChart<ChartData>: View where ChartData: RangedBarChartData {
    
    @ObservedObject var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be RangedBarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    @State private var startAnimation : Bool = false
    
    public var body: some View {
        
        HStack(spacing: 0) {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GeometryReader { geo in
                    
                    if chartData.barStyle.fillColour.colourType == .colour,
                       let colour = chartData.barStyle.fillColour.colour {
                        
                        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                                 tr: chartData.barStyle.cornerRadius.top,
                                                 bl: chartData.barStyle.cornerRadius.bottom,
                                                 br: chartData.barStyle.cornerRadius.bottom)
                            .fill(colour)
                            
                            .scaleEffect(y: startAnimation ? CGFloat((dataPoint.upperValue - dataPoint.lowerValue) / chartData.range) : 0, anchor: .center)
                            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
                            .position(x: geo.frame(in: .local).midX,
                                      y: getBarPositionX(dataPoint: dataPoint, height: geo.size.height))
                            
                            .background(Color(.gray).opacity(0.000000001))
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .accessibilityValue(Text("\(dataPoint.upperValue, specifier: chartData.infoView.touchSpecifier), \(dataPoint.pointDescription ?? "")"))
                    
                    } else if chartData.barStyle.fillColour.colourType == .gradientColour,
                              let colours    = chartData.barStyle.fillColour.colours,
                              let startPoint = chartData.barStyle.fillColour.startPoint,
                              let endPoint   = chartData.barStyle.fillColour.endPoint {
                        
                        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                                 tr: chartData.barStyle.cornerRadius.top,
                                                 bl: chartData.barStyle.cornerRadius.bottom,
                                                 br: chartData.barStyle.cornerRadius.bottom)
                            .fill(LinearGradient(gradient   : Gradient(colors: colours),
                                                 startPoint : startPoint,
                                                 endPoint   : endPoint))
                            
                            .scaleEffect(y: startAnimation ? CGFloat((dataPoint.upperValue - dataPoint.lowerValue) / chartData.range) : 0, anchor: .center)
                            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
                            .position(x: geo.frame(in: .local).midX,
                                      y: getBarPositionX(dataPoint: dataPoint, height: geo.size.height))
                            
                            .background(Color(.gray).opacity(0.000000001))
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .accessibilityValue(Text("\(dataPoint.upperValue, specifier: chartData.infoView.touchSpecifier), \(dataPoint.pointDescription ?? "")"))
                        
                    } else if chartData.barStyle.fillColour.colourType == .gradientStops,
                              let stops      = chartData.barStyle.fillColour.stops,
                              let startPoint = chartData.barStyle.fillColour.startPoint,
                              let endPoint   = chartData.barStyle.fillColour.endPoint {
                        
                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                        
                        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                                 tr: chartData.barStyle.cornerRadius.top,
                                                 bl: chartData.barStyle.cornerRadius.bottom,
                                                 br: chartData.barStyle.cornerRadius.bottom)
                            .fill(LinearGradient(gradient   : Gradient(stops: safeStops),
                                                 startPoint : startPoint,
                                                 endPoint   : endPoint))
                            
                            .scaleEffect(y: startAnimation ? CGFloat((dataPoint.upperValue - dataPoint.lowerValue) / chartData.range) : 0, anchor: .center)
                            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
                            .position(x: geo.frame(in: .local).midX,
                                      y: getBarPositionX(dataPoint: dataPoint, height: geo.size.height))
                            
                            .background(Color(.gray).opacity(0.000000001))
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .accessibilityValue(Text("\(dataPoint.upperValue, specifier: chartData.infoView.touchSpecifier), \(dataPoint.pointDescription ?? "")"))
                    
                    }
                    
                }
            }
        }
    }
    
   private func getBarPositionX(dataPoint: RangedBarDataPoint, height: CGFloat) -> CGFloat {
        let value = CGFloat((dataPoint.upperValue + dataPoint.lowerValue) / 2) - CGFloat(chartData.minValue)
        return (height - (value / CGFloat(chartData.range)) * height)
    }
}
