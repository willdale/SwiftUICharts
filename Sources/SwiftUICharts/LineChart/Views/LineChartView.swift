//
//  LineChartView.swift
//  LineChart
//
//  Created by Will Dale on 27/12/2020.
//

import SwiftUI

/**
 View for drawing a line chart.
 
 Uses `LineChartData` data model.
 
 # Declaration
 ```
 LineChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .pointMarkers(chartData: data)
 .touchOverlay(chartData: data, specifier: "%.0f")
 .yAxisPOI(chartData: data,
           markerName: "Something",
           markerValue: 110,
           labelPosition: .center(specifier: "%.0f"),
           labelColour: Color.white,
           labelBackground: Color.blue,
           lineColour: Color.blue,
           strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
 .averageLine(chartData: data,
              strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
 .xAxisGrid(chartData: data)
 .yAxisGrid(chartData: data)
 .xAxisLabels(chartData: data)
 .yAxisLabels(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
 ```
 */
public struct LineChart<ChartData>: View where ChartData: LineChartData {
    
    @ObservedObject var chartData: ChartData
    
    /// Initialises a line chart view.
    /// - Parameter chartData: Must be LineChartData model.
    public init(chartData: ChartData) {
        self.chartData  = chartData
    }
     
    public var body: some View {
        
        if chartData.isGreaterThanTwo() {
            
<<<<<<< HEAD
            if style.colourType == .colour,
               let colour = style.colour
            {
                if !isFilled {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .stroke(colour, style: strokeStyle)
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
//                        .animateOnDisAppear(using: chartData.chartStyle.globalAnimation) {
//                            self.startAnimation = false
//                        }
                } else {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .fill(colour)
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
//                        .animateOnDisAppear(using: chartData.chartStyle.globalAnimation) {
//                            self.startAnimation = false
//                        }
                }
                
            } else if style.colourType == .gradientColour,
                      let colours     = style.colours,
                      let startPoint  = style.startPoint,
                      let endPoint    = style.endPoint
            {
                if !isFilled {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                               startPoint: startPoint,
                                               endPoint: endPoint),
                                style: strokeStyle)
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
//                        .animateOnDisAppear(using: chartData.chartStyle.globalAnimation) {
//                            self.startAnimation = false
//                        }
                } else {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .fill(LinearGradient(gradient: Gradient(colors: colours), startPoint: startPoint, endPoint: endPoint))
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
//                        .animateOnDisAppear(using: chartData.chartStyle.globalAnimation) {
//                            self.startAnimation = false
//                        }
                }
            } else if style.colourType == .gradientStops,
                      let stops      = style.stops,
                      let startPoint = style.startPoint,
                      let endPoint   = style.endPoint
            {
                let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                if !isFilled {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                               startPoint: startPoint,
                                               endPoint: endPoint),
                                style: strokeStyle)
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
//                        .animateOnDisAppear(using: chartData.chartStyle.globalAnimation) {
//                            self.startAnimation = false
//                        }
                } else {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
//                        .animateOnDisAppear(using: chartData.chartStyle.globalAnimation) {
//                            self.startAnimation = false
//                        }
=======
            ZStack {
                
                chartData.getAccessibility()
                
                if chartData.dataSets.style.lineColour.colourType == .colour,
                   let colour = chartData.dataSets.style.lineColour.colour
                {
                    LineChartColourSubView(chartData: chartData,
                                           dataSet  : chartData.dataSets,
                                           minValue : chartData.minValue,
                                           range    : chartData.range,
                                           colour   : colour,
                                           isFilled : false)
                    
                    
                } else if chartData.dataSets.style.lineColour.colourType == .gradientColour,
                          let colours     = chartData.dataSets.style.lineColour.colours,
                          let startPoint  = chartData.dataSets.style.lineColour.startPoint,
                          let endPoint    = chartData.dataSets.style.lineColour.endPoint
                {
                    
                    LineChartColoursSubView(chartData   : chartData,
                                            dataSet     : chartData.dataSets,
                                            minValue    : chartData.minValue,
                                            range       : chartData.range,
                                            colours     : colours,
                                            startPoint  : startPoint,
                                            endPoint    : endPoint,
                                            isFilled    : false)
                    
                } else if chartData.dataSets.style.lineColour.colourType == .gradientStops,
                          let stops      = chartData.dataSets.style.lineColour.stops,
                          let startPoint = chartData.dataSets.style.lineColour.startPoint,
                          let endPoint   = chartData.dataSets.style.lineColour.endPoint
                {
                    let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                    
                    LineChartStopsSubView(chartData : chartData,
                                          dataSet   : chartData.dataSets,
                                          minValue  : chartData.minValue,
                                          range     : chartData.range,
                                          stops     : stops,
                                          startPoint: startPoint,
                                          endPoint  : endPoint,
                                          isFilled  : false)
>>>>>>> version-2
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
