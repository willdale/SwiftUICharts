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
        if chartData.barStyle.fillColour.colourType == .colour,
           let colour = chartData.barStyle.fillColour.colour
        {
            
            ColourBar(colour, dataPoint, chartData.maxValue, chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)
            
        } else if chartData.barStyle.fillColour.colourType == .gradientColour,
                  let colours    = chartData.barStyle.fillColour.colours,
                  let startPoint = chartData.barStyle.fillColour.startPoint,
                  let endPoint   = chartData.barStyle.fillColour.endPoint
        {
            
            GradientColoursBar(colours, startPoint, endPoint, dataPoint, chartData.maxValue, chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)

        } else if chartData.barStyle.fillColour.colourType == .gradientStops,
                  let stops      = chartData.barStyle.fillColour.stops,
                  let startPoint = chartData.barStyle.fillColour.startPoint,
                  let endPoint   = chartData.barStyle.fillColour.endPoint
        {

            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
            
            GradientStopsBar(safeStops, startPoint, endPoint, dataPoint, chartData.maxValue, chartData.chartStyle,  chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)

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
        
        if dataPoint.fillColour.colourType == .colour,
           let colour = dataPoint.fillColour.colour
        {
            
            ColourBar(colour, dataPoint, chartData.maxValue, chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)
        
        } else if dataPoint.fillColour.colourType == .gradientColour,
                  let colours    = dataPoint.fillColour.colours,
                  let startPoint = dataPoint.fillColour.startPoint,
                  let endPoint   = dataPoint.fillColour.endPoint
        {

            GradientColoursBar(colours, startPoint, endPoint, dataPoint, chartData.maxValue, chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)

        } else if dataPoint.fillColour.colourType == .gradientStops,
                  let stops      = dataPoint.fillColour.stops,
                  let startPoint = dataPoint.fillColour.startPoint,
                  let endPoint   = dataPoint.fillColour.endPoint
        {

            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)

            GradientStopsBar(safeStops, startPoint, endPoint, dataPoint, chartData.maxValue, chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)
        } else {
            ColourBar(.blue, dataPoint, chartData.maxValue, chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)
        }
        
    }
}
