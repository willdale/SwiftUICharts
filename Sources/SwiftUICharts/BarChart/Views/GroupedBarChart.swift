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

                            if dataPoint.group.fillColour.colourType == .colour,
                               let colour = dataPoint.group.fillColour.colour
                            {

                                ColourBar(chartData   : chartData,
                                          dataPoint   : dataPoint,
                                          colour      : colour)
                                    .accessibilityLabel(Text("\(chartData.metadata.title)"))

                            } else if dataPoint.group.fillColour.colourType == .gradientColour,
                                      let colours    = dataPoint.group.fillColour.colours,
                                      let startPoint = dataPoint.group.fillColour.startPoint,
                                      let endPoint   = dataPoint.group.fillColour.endPoint
                            {

                                GradientColoursBar(chartData   : chartData,
                                                   dataPoint   : dataPoint,
                                                   colours     : colours,
                                                   startPoint  : startPoint,
                                                   endPoint    : endPoint)
                                    .accessibilityLabel( Text("\(chartData.metadata.title)"))

                            } else if dataPoint.group.fillColour.colourType == .gradientStops,
                                      let stops      = dataPoint.group.fillColour.stops,
                                      let startPoint = dataPoint.group.fillColour.startPoint,
                                      let endPoint   = dataPoint.group.fillColour.endPoint
                            {

                                let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)

                                GradientStopsBar(chartData    : chartData,
                                                 dataPoint   : dataPoint,
                                                 stops       : safeStops,
                                                 startPoint  : startPoint,
                                                 endPoint    : endPoint)

                                    .accessibilityLabel( Text("\(chartData.metadata.title)"))

                            }
                        }
                    }
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
