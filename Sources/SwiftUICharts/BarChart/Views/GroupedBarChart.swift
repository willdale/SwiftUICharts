//
//  GroupedBarChart.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

/**
 View for creating a grouped bar chart.
  
 Uses `GroupedBarChartData` data model.
 
 # Declaration
 ```
 GroupedBarChart(chartData: data, groupSpacing: 25)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
    .touchOverlay(chartData: data)
    .averageLine(chartData: data)
    .yAxisPOI(chartData: data)
    .xAxisGrid(chartData: data)
    .yAxisGrid(chartData: data)
    .xAxisLabels(chartData: data)
    .yAxisLabels(chartData: data)
    .infoBox(chartData: data)
    .headerBox(chartData: data)
    .legends(chartData: data)
 ```
 */
public struct GroupedBarChart<ChartData>: View where ChartData: GroupedBarChartData {
    
    @ObservedObject var chartData: ChartData
    
    private let groupSpacing : CGFloat
    
    /// Initialises a grouped bar chart view.
    /// - Parameters:
    ///   - chartData: Must be GroupedBarChartData model.
    ///   - groupSpacing: Spacing between groups of bars.
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
                            
                            if dataPoint.group.colourType == .colour,
                               let colour = dataPoint.group.colour
                            {
                                
                                ColourBar(colour, dataPoint, chartData.maxValue, chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)
                                    .accessibilityLabel( Text("\(chartData.metadata.title)"))
                                
                            } else if dataPoint.group.colourType == .gradientColour,
                                      let colours    = dataPoint.group.colours,
                                      let startPoint = dataPoint.group.startPoint,
                                      let endPoint   = dataPoint.group.endPoint
                            {

                                GradientColoursBar(colours, startPoint, endPoint, dataPoint, chartData.maxValue, chartData.chartStyle, chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)
                                    .accessibilityLabel( Text("\(chartData.metadata.title)"))

                            } else if dataPoint.group.colourType == .gradientStops,
                                      let stops      = dataPoint.group.stops,
                                      let startPoint = dataPoint.group.startPoint,
                                      let endPoint   = dataPoint.group.endPoint
                            {

                                let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)

                                GradientStopsBar(safeStops, startPoint, endPoint, dataPoint, chartData.maxValue, chartData.chartStyle,  chartData.barStyle.cornerRadius, chartData.barStyle.barWidth, chartData.infoView.touchSpecifier)
                                    .accessibilityLabel( Text("\(chartData.metadata.title)"))

                            }
                        }
                    }
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
