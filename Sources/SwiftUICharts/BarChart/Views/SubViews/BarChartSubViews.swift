//
//  BarChartSubViews.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

/**
 Bar segment where the colour information comes from chart style.
 */
internal struct BarChartDataSetSubView: View {
    
    let colourType  : ColourType
    let dataPoint   : BarChartDataPoint
    let style       : BarStyle
    let chartStyle  : BarChartStyle
    let maxValue    : Double
    
    internal var body: some View {
        if colourType == .colour,
           let colour = style.colour
        {
            ColourBar(colour, dataPoint, maxValue, chartStyle, style)
        
        } else if colourType == .gradientColour,
                  let colours    = style.colours,
                  let startPoint = style.startPoint,
                  let endPoint   = style.endPoint
        {

            GradientColoursBar(colours, startPoint, endPoint, dataPoint, maxValue, chartStyle, style)

        } else if colourType == .gradientStops,
                  let stops      = style.stops,
                  let startPoint = style.startPoint,
                  let endPoint   = style.endPoint
        {

            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
            GradientStopsBar(safeStops, startPoint, endPoint, dataPoint, maxValue, chartStyle, style)

        }
    }
}

/**
 Bar segment where the colour information comes from datapoints.
 */
internal struct BarChartDataPointSubView: View {

    let colourType  : ColourType
    let dataPoint   : BarChartDataPoint
    let style       : BarStyle
    let chartStyle  : BarChartStyle
    let maxValue    : Double
    
    internal var body: some View {
        
        if dataPoint.colourType == .colour,
           let colour = dataPoint.colour
        {
            
            ColourBar(colour, dataPoint, maxValue, chartStyle, style)
        
        } else if dataPoint.colourType == .gradientColour,
                  let colours    = dataPoint.colours,
                  let startPoint = dataPoint.startPoint,
                  let endPoint   = dataPoint.endPoint
        {

            GradientColoursBar(colours, startPoint, endPoint, dataPoint, maxValue, chartStyle, style)

        } else if dataPoint.colourType == .gradientStops,
                  let stops      = dataPoint.stops,
                  let startPoint = dataPoint.startPoint,
                  let endPoint   = dataPoint.endPoint
        {

            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)

            GradientStopsBar(safeStops, startPoint, endPoint, dataPoint, maxValue, chartStyle, style)
        }
        
    }
}
