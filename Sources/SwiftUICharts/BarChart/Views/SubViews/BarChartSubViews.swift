//
//  BarChartSubViews.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

// MARK: - Bar Style
/**
 Bar segment where the colour information comes from chart style.
 */
internal struct BarChartBarStyleSubView<CD: BarChartData>: View {

    private let chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        if chartData.barStyle.colour.colourType == .colour,
           let colour = chartData.barStyle.colour.colour
        {
            
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                ColourBar(chartData   : chartData,
                          dataPoint   : dataPoint,
                          colour      : colour)
            }
            
        } else if chartData.barStyle.colour.colourType == .gradientColour,
                  let colours    = chartData.barStyle.colour.colours,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint   = chartData.barStyle.colour.endPoint
        {
            
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GradientColoursBar(chartData   : chartData,
                                   dataPoint   : dataPoint,
                                   colours     : colours,
                                   startPoint  : startPoint,
                                   endPoint    : endPoint)
            }
            
        } else if chartData.barStyle.colour.colourType == .gradientStops,
                  let stops      = chartData.barStyle.colour.stops,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint   = chartData.barStyle.colour.endPoint
        {
            
            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
            
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GradientStopsBar(chartData     : chartData,
                                 dataPoint   : dataPoint,
                                 stops       : safeStops,
                                 startPoint  : startPoint,
                                 endPoint    : endPoint)
            }
            
        }
    }
}

// MARK: - DataPoints
/**
 Bar segment where the colour information comes from datapoints.
 */
internal struct BarChartDataPointSubView<CD: BarChartData>: View {
    
    private let chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        
        ForEach(chartData.dataSets.dataPoints) { dataPoint in
            
            if dataPoint.colour.colourType == .colour,
               let colour = dataPoint.colour.colour
            {
                
                ColourBar(chartData   : chartData,
                          dataPoint   : dataPoint,
                          colour      : colour)
                
            } else if dataPoint.colour.colourType == .gradientColour,
                      let colours    = dataPoint.colour.colours,
                      let startPoint = dataPoint.colour.startPoint,
                      let endPoint   = dataPoint.colour.endPoint
            {
                
                GradientColoursBar(chartData   : chartData,
                                   dataPoint   : dataPoint,
                                   colours     : colours,
                                   startPoint  : startPoint,
                                   endPoint    : endPoint)
                
            } else if dataPoint.colour.colourType == .gradientStops,
                      let stops      = dataPoint.colour.stops,
                      let startPoint = dataPoint.colour.startPoint,
                      let endPoint   = dataPoint.colour.endPoint
            {
                
                let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                
                GradientStopsBar(chartData  : chartData,
                                 dataPoint  : dataPoint,
                                 stops      : safeStops,
                                 startPoint : startPoint,
                                 endPoint   : endPoint)
                
            } else {
                ColourBar(chartData   : chartData,
                          dataPoint   : dataPoint,
                          colour      : .blue)
            }
        }
    }
}
