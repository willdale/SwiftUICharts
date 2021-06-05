//
//  ExtraLine.swift
//  
//
//  Created by Will Dale on 08/05/2021.
//

import SwiftUI

// MARK: - View
internal struct ExtraLine<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    
    init(
        chartData: T,
        legendTitle: String,
        datapoints: @escaping ()->([ExtraLineDataPoint]),
        style: @escaping ()->(ExtraLineStyle)
    ) {
        self.chartData = chartData
        self.chartData.extraLineData = ExtraLineData(legendTitle: legendTitle,
                                                     dataPoints: datapoints,
                                                     style: style)
        
        self.lineLegendSetup()
    }
    
    @State private var startAnimation: Bool = false
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                ZStack {
                    if chartData.extraLineData.style.lineColour.colourType == .colour,
                       let colour = chartData.extraLineData.style.lineColour.colour
                    {
                        ExtraLineShape(dataPoints: chartData.extraLineData.dataPoints.map(\.value),
                                       lineType: chartData.extraLineData.style.lineType,
                                       lineSpacing: chartData.extraLineData.style.lineSpacing,
                                       range: chartData.extraLineData.range,
                                       minValue: chartData.extraLineData.minValue)
                            .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                                $0.trim(to: startAnimation ? 1 : 0)
                                    .stroke(colour, style: StrokeStyle(lineWidth: 3))
                            }, else: {
                                $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                                    .stroke(colour, style: StrokeStyle(lineWidth: 3))
                            })
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .zIndex(1)
                    } else if chartData.extraLineData.style.lineColour.colourType == .gradientColour,
                              let colours = chartData.extraLineData.style.lineColour.colours,
                              let startPoint = chartData.extraLineData.style.lineColour.startPoint,
                              let endPoint = chartData.extraLineData.style.lineColour.endPoint
                    {
                        ExtraLineShape(dataPoints: chartData.extraLineData.dataPoints.map(\.value),
                                       lineType: chartData.extraLineData.style.lineType,
                                       lineSpacing: chartData.extraLineData.style.lineSpacing,
                                       range: chartData.extraLineData.range,
                                       minValue: chartData.extraLineData.minValue)
                            .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                                $0.trim(to: startAnimation ? 1 : 0)
                                    .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                                           startPoint: startPoint,
                                                           endPoint: endPoint),
                                            style: StrokeStyle(lineWidth: 3))
                            }, else: {
                                $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                                    .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                                           startPoint: startPoint,
                                                           endPoint: endPoint),
                                            style: StrokeStyle(lineWidth: 3))
                            })
                            
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .zIndex(1)
                    } else if chartData.extraLineData.style.lineColour.colourType == .gradientStops,
                              let stops = chartData.extraLineData.style.lineColour.stops,
                              let startPoint = chartData.extraLineData.style.lineColour.startPoint,
                              let endPoint = chartData.extraLineData.style.lineColour.endPoint
                    {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        ExtraLineShape(dataPoints: chartData.extraLineData.dataPoints.map(\.value),
                                       lineType: chartData.extraLineData.style.lineType,
                                       lineSpacing: chartData.extraLineData.style.lineSpacing,
                                       range: chartData.extraLineData.range,
                                       minValue: chartData.extraLineData.minValue)
                            .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                                $0.trim(to: startAnimation ? 1 : 0)
                                    .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                                           startPoint: startPoint,
                                                           endPoint: endPoint),
                                            style: StrokeStyle(lineWidth: 3))
                            }, else: {
                                $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                                    .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                                           startPoint: startPoint,
                                                           endPoint: endPoint),
                                            style: StrokeStyle(lineWidth: 3))
                            })
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .zIndex(1)
                    }
                    content
                }
            } else { content }
        }
    }
    
    private func lineLegendSetup() {
        if self.chartData.extraLineData.style.lineColour.colourType == .colour,
           let colour = self.chartData.extraLineData.style.lineColour.colour
        {
            chartData.legends.append(LegendData(id: self.chartData.extraLineData.id,
                                                legend: self.chartData.extraLineData.legendTitle,
                                                colour: ColourStyle(colour: colour),
                                                strokeStyle: self.chartData.extraLineData.style.strokeStyle,
                                                prioity: 3,
                                                chartType: .line))
        } else if self.chartData.extraLineData.style.lineColour.colourType == .gradientColour,
                  let colours = self.chartData.extraLineData.style.lineColour.colours
        {
            chartData.legends.append(LegendData(id: self.chartData.extraLineData.id,
                                                legend: self.chartData.extraLineData.legendTitle,
                                                colour: ColourStyle(colours: colours,
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing),
                                                strokeStyle: self.chartData.extraLineData.style.strokeStyle,
                                                prioity: 3,
                                                chartType: .line))
        } else if self.chartData.extraLineData.style.lineColour.colourType == .gradientStops,
                  let stops = self.chartData.extraLineData.style.lineColour.stops
        {
            chartData.legends.append(LegendData(id: self.chartData.extraLineData.id,
                                                legend: self.chartData.extraLineData.legendTitle,
                                                colour: ColourStyle(stops: stops,
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing),
                                                strokeStyle: self.chartData.extraLineData.style.strokeStyle,
                                                prioity: 3,
                                                chartType: .line))
        }
    }
}


// MARK: - View Extension
extension View {
    /**
     Adds an seperate line that is over-layed on top of a other chart.
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     - Parameters:
        - chartData: Data that conforms to CTLineBarChartDataProtocol.
        - legendTitle: Title of the extra line to display in the legends.
        - datapoints: Data point to create the line.
        - style: Styling data for the line.
     - Returns: The chart with an extra line stacked on top.
     */
    public func extraLine<T: CTLineBarChartDataProtocol>(
        chartData: T,
        legendTitle: String,
        datapoints: @escaping ()->([ExtraLineDataPoint]),
        style: @escaping ()->(ExtraLineStyle)
    ) -> some View {
        self.modifier(ExtraLine<T>(chartData: chartData,
                                   legendTitle: legendTitle,
                                   datapoints: datapoints,
                                   style: style)
        )
    }
}
