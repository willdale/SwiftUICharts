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
        if chartData.barStyle.fillColour.colourType == .colour,
           let colour = chartData.barStyle.fillColour.colour
        {
            
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                ColourBar(chartData   : chartData,
                          dataPoint   : dataPoint,
                          colour      : colour)
            }
            
        } else if chartData.barStyle.fillColour.colourType == .gradientColour,
                  let colours    = chartData.barStyle.fillColour.colours,
                  let startPoint = chartData.barStyle.fillColour.startPoint,
                  let endPoint   = chartData.barStyle.fillColour.endPoint
        {
            
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GradientColoursBar(chartData   : chartData,
                                   dataPoint   : dataPoint,
                                   colours     : colours,
                                   startPoint  : startPoint,
                                   endPoint    : endPoint)
            }
            
        } else if chartData.barStyle.fillColour.colourType == .gradientStops,
                  let stops      = chartData.barStyle.fillColour.stops,
                  let startPoint = chartData.barStyle.fillColour.startPoint,
                  let endPoint   = chartData.barStyle.fillColour.endPoint
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
            
            if dataPoint.fillColour.colourType == .colour,
               let colour = dataPoint.fillColour.colour
            {
                
                ColourBar(chartData   : chartData,
                          dataPoint   : dataPoint,
                          colour      : colour)
                
            } else if dataPoint.fillColour.colourType == .gradientColour,
                      let colours    = dataPoint.fillColour.colours,
                      let startPoint = dataPoint.fillColour.startPoint,
                      let endPoint   = dataPoint.fillColour.endPoint
            {
                
                GradientColoursBar(chartData   : chartData,
                                   dataPoint   : dataPoint,
                                   colours     : colours,
                                   startPoint  : startPoint,
                                   endPoint    : endPoint)
                
            } else if dataPoint.fillColour.colourType == .gradientStops,
                      let stops      = dataPoint.fillColour.stops,
                      let startPoint = dataPoint.fillColour.startPoint,
                      let endPoint   = dataPoint.fillColour.endPoint
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
