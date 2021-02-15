//
//  GroupedBarChart.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

public struct GroupedBarChart<ChartData>: View where ChartData: GroupedBarChartData {
    
    @ObservedObject var chartData: ChartData
    
    private let groupSpacing : CGFloat
        
    public init(chartData: ChartData, groupSpacing: CGFloat) {
        self.chartData    = chartData
        self.groupSpacing = groupSpacing
        self.chartData.groupSpacing = groupSpacing
    }
    
    @State private var startAnimation : Bool = false
    
    public var body: some View {
        if chartData.isGreaterThanTwo() {
            HStack(spacing: groupSpacing) {
                ForEach(chartData.dataSets.dataSets) { dataSet in
                    HStack(spacing: 0) {
                        ForEach(dataSet.dataPoints) { dataPoint in
                            
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

                                GradientStopsBar(safeStops, startPoint, endPoint, dataPoint, chartData.getMaxValue(), chartData.chartStyle,  chartData.barStyle.cornerRadius, chartData.barStyle.barWidth)

                            }
                        }
                    }
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
