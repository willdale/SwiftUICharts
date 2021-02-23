//
//  BarChartSubViews.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

// MARK: - Chart Data
/**
 Bar segment where the colour information comes from chart style.
 */
internal struct BarChartDataSetSubView<CD: BarChartData>: View {

    private let chartData   : CD
    private let dataPoint   : BarChartDataPoint
    
    internal init(chartData: CD,
                  dataPoint: BarChartDataPoint
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
    }
        
    internal var body: some View {
        if chartData.barStyle.colourType == .colour,
           let colour = chartData.barStyle.colour
        {
            
            ColourBar(colour, dataPoint, chartData.getMaxValue(), chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth)
            
        } else if chartData.barStyle.colourType == .gradientColour,
                  let colours    = chartData.barStyle.colours,
                  let startPoint = chartData.barStyle.startPoint,
                  let endPoint   = chartData.barStyle.endPoint
        {
            
            GradientColoursBar(colours, startPoint, endPoint, dataPoint, chartData.getMaxValue(), chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth)

        } else if chartData.barStyle.colourType == .gradientStops,
                  let stops      = chartData.barStyle.stops,
                  let startPoint = chartData.barStyle.startPoint,
                  let endPoint   = chartData.barStyle.endPoint
        {

            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
            
            GradientStopsBar(safeStops, startPoint, endPoint, dataPoint, chartData.getMaxValue(), chartData.chartStyle,  chartData.barStyle.cornerRadius, chartData.barStyle.barWidth)

        }
    }
}

// MARK: - DataPoints
/**
 Bar segment where the colour information comes from datapoints.
 */
internal struct BarChartDataPointSubView<CD: BarChartData>: View {

    private let chartData   : CD
    private let dataPoint   : BarChartDataPoint
    
    internal init(chartData: CD,
                  dataPoint: BarChartDataPoint
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
    }
    
    internal var body: some View {
        
        if dataPoint.colourType == .colour,
           let colour = dataPoint.colour
        {
            
            ColourBar(colour, dataPoint, chartData.getMaxValue(), chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth)
        
        } else if dataPoint.colourType == .gradientColour,
                  let colours    = dataPoint.colours,
                  let startPoint = dataPoint.startPoint,
                  let endPoint   = dataPoint.endPoint
        {

            GradientColoursBar(colours, startPoint, endPoint, dataPoint, chartData.getMaxValue(), chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth)

        } else if dataPoint.colourType == .gradientStops,
                  let stops      = dataPoint.stops,
                  let startPoint = dataPoint.startPoint,
                  let endPoint   = dataPoint.endPoint
        {

            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)

            GradientStopsBar(safeStops, startPoint, endPoint, dataPoint, chartData.getMaxValue(), chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth)
        } else {
            ColourBar(.blue, dataPoint, chartData.getMaxValue(), chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth)
        }
        
    }
}
