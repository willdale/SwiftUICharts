//
//  BarChartSubViews.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

// MARK: - Standard
//
//
//
// MARK: Bar Style
/**
 Bar segment where the colour information comes from chart style.
 */
internal struct BarChartBarStyleSubView<CD: BarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        if chartData.barStyle.colour.colourType == .colour,
           let colour = chartData.barStyle.colour.colour
        {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                BarElement(chartData: chartData,
                          dataPoint: dataPoint,
                          fill: colour)
            }
        } else if chartData.barStyle.colour.colourType == .gradientColour,
                  let colours = chartData.barStyle.colour.colours,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint = chartData.barStyle.colour.endPoint
        {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                BarElement(chartData: chartData,
                          dataPoint: dataPoint,
                          fill: LinearGradient(gradient: Gradient(colors: colours),
                                               startPoint: startPoint,
                                               endPoint: endPoint))
            }
        } else if chartData.barStyle.colour.colourType == .gradientStops,
                  let stops = chartData.barStyle.colour.stops,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint = chartData.barStyle.colour.endPoint
        {
            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                BarElement(chartData: chartData,
                          dataPoint: dataPoint,
                          fill: LinearGradient(gradient: Gradient(stops: safeStops),
                                               startPoint: startPoint,
                                               endPoint: endPoint))
            }
        }
    }
}

// MARK: Data Points
/**
 Bar segment where the colour information comes from datapoints.
 */
internal struct BarChartDataPointSubView<CD: BarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        ForEach(chartData.dataSets.dataPoints) { dataPoint in
            if dataPoint.colour.colourType == .colour,
               let colour = dataPoint.colour.colour
            {
                BarElement(chartData: chartData,
                          dataPoint: dataPoint,
                          fill: colour)
            } else if dataPoint.colour.colourType == .gradientColour,
                      let colours = dataPoint.colour.colours,
                      let startPoint = dataPoint.colour.startPoint,
                      let endPoint = dataPoint.colour.endPoint
            {
                BarElement(chartData: chartData,
                          dataPoint: dataPoint,
                          fill: LinearGradient(gradient: Gradient(colors: colours),
                                               startPoint: startPoint,
                                               endPoint: endPoint))
            } else if dataPoint.colour.colourType == .gradientStops,
                      let stops = dataPoint.colour.stops,
                      let startPoint = dataPoint.colour.startPoint,
                      let endPoint = dataPoint.colour.endPoint
            {
                let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                BarElement(chartData: chartData,
                          dataPoint: dataPoint,
                          fill: LinearGradient(gradient: Gradient(stops: safeStops),
                                               startPoint: startPoint,
                                               endPoint: endPoint))
            } else {
                BarElement(chartData: chartData,
                          dataPoint: dataPoint,
                          fill: Color.blue)
            }
        }
    }
}

// MARK: - Ranged
//
//
//
// MARK: Bar Style
internal struct RangedBarChartBarStyleSubView<CD:RangedBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    var body: some View {
        if chartData.barStyle.colour.colourType == .colour,
           let colour = chartData.barStyle.colour.colour
        {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GeometryReader { geo in
                    RangedBarCell(chartData: chartData,
                                  dataPoint: dataPoint,
                                  fill: colour,
                                  barSize: geo.frame(in: .local))
                }
            }
        } else if chartData.barStyle.colour.colourType == .gradientColour,
                  let colours = chartData.barStyle.colour.colours,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint = chartData.barStyle.colour.endPoint
        {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GeometryReader { geo in
                    RangedBarCell(chartData: chartData,
                                  dataPoint: dataPoint,
                                  fill: LinearGradient(gradient: Gradient(colors: colours),
                                                       startPoint: startPoint,
                                                       endPoint: endPoint),
                                  barSize: geo.frame(in: .local))
                }
            }
        } else if chartData.barStyle.colour.colourType == .gradientStops,
                  let stops = chartData.barStyle.colour.stops,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint = chartData.barStyle.colour.endPoint
        {
            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GeometryReader { geo in
                RangedBarCell(chartData: chartData,
                              dataPoint: dataPoint,
                              fill: LinearGradient(gradient: Gradient(stops: safeStops),
                                                   startPoint: startPoint,
                                                   endPoint: endPoint),
                              barSize: geo.frame(in: .local))
                }
            }
        }
    }
}

// MARK: Data Points
internal struct RangedBarChartDataPointSubView<CD:RangedBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        ForEach(chartData.dataSets.dataPoints) { dataPoint in
            
            if dataPoint.colour.colourType == .colour,
               let colour = dataPoint.colour.colour
            {
                GeometryReader { geo in
                    RangedBarCell(chartData: chartData,
                                  dataPoint: dataPoint,
                                  fill: colour,
                                  barSize: geo.frame(in: .local))
                }
            } else if dataPoint.colour.colourType == .gradientColour,
                      let colours = dataPoint.colour.colours,
                      let startPoint = dataPoint.colour.startPoint,
                      let endPoint = dataPoint.colour.endPoint
            {
                GeometryReader { geo in
                    RangedBarCell(chartData: chartData,
                                  dataPoint: dataPoint,
                                  fill: LinearGradient(gradient: Gradient(colors: colours),
                                                       startPoint: startPoint,
                                                       endPoint: endPoint),
                                  barSize: geo.frame(in: .local))
                }
            } else if dataPoint.colour.colourType == .gradientStops,
                      let stops = dataPoint.colour.stops,
                      let startPoint = dataPoint.colour.startPoint,
                      let endPoint = dataPoint.colour.endPoint
            {
                GeometryReader { geo in
                    let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                    RangedBarCell(chartData: chartData,
                                  dataPoint: dataPoint,
                                  fill: LinearGradient(gradient: Gradient(stops: safeStops),
                                                       startPoint: startPoint,
                                                       endPoint: endPoint),
                                  barSize: geo.frame(in: .local))
                }
            }
        }
    }
}





// MARK: - Horizontal
//
//
//
// MARK: Bar Style
internal struct HorizontalBarChartBarStyleSubView<CD: HorizontalBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        if chartData.barStyle.colour.colourType == .colour,
           let colour = chartData.barStyle.colour.colour
        {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: dataPoint,
                                     fill: colour)
            }
        } else if chartData.barStyle.colour.colourType == .gradientColour,
                  let colours = chartData.barStyle.colour.colours,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint = chartData.barStyle.colour.endPoint
        {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: dataPoint,
                                     fill: LinearGradient(gradient: Gradient(colors: colours),
                                                          startPoint: startPoint,
                                                          endPoint: endPoint))
            }
        } else if chartData.barStyle.colour.colourType == .gradientStops,
                  let stops = chartData.barStyle.colour.stops,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint = chartData.barStyle.colour.endPoint
        {
            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: dataPoint,
                                     fill: LinearGradient(gradient: Gradient(stops: safeStops),
                                                          startPoint: startPoint,
                                                          endPoint: endPoint))
            }
        }
    }
}

// MARK: Data Points
internal struct HorizontalBarChartDataPointSubView<CD: HorizontalBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        ForEach(chartData.dataSets.dataPoints) { dataPoint in
            if dataPoint.colour.colourType == .colour,
               let colour = dataPoint.colour.colour
            {
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: dataPoint,
                                     fill: colour)
            } else if dataPoint.colour.colourType == .gradientColour,
                      let colours = dataPoint.colour.colours,
                      let startPoint = dataPoint.colour.startPoint,
                      let endPoint = dataPoint.colour.endPoint
            {
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: dataPoint,
                                     fill: LinearGradient(gradient: Gradient(colors: colours),
                                                          startPoint: startPoint,
                                                          endPoint: endPoint))
            } else if dataPoint.colour.colourType == .gradientStops,
                      let stops = dataPoint.colour.stops,
                      let startPoint = dataPoint.colour.startPoint,
                      let endPoint = dataPoint.colour.endPoint
            {
                let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: dataPoint,
                                     fill: LinearGradient(gradient: Gradient(stops: safeStops),
                                                          startPoint: startPoint,
                                                          endPoint: endPoint))
            }
        }
    }
}
