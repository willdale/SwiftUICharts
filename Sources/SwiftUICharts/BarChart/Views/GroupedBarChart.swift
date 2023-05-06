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
 .averageLine(chartData: data,
 strokeStyle: StrokeStyle(lineWidth: 3,dash: [5,10]))
 .yAxisPOI(chartData: data,
           markerName: "50",
           markerValue: 50,
           lineColour: Color.blue,
           strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
 .xAxisGrid(chartData: data)
 .yAxisGrid(chartData: data)
 .xAxisLabels(chartData: data)
 .yAxisLabels(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct GroupedBarChart<ChartData>: View where ChartData: GroupedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    @State private var timer: Timer?
    private let groupSpacing: CGFloat
    
    /// Initialises a grouped bar chart view.
    /// - Parameters:
    ///   - chartData: Must be GroupedBarChartData model.
    ///   - groupSpacing: Spacing between groups of bars.
    public init(
        chartData: ChartData,
        groupSpacing: CGFloat
    ) {
        self.chartData = chartData
        self.groupSpacing = groupSpacing
        self.chartData.groupSpacing = groupSpacing
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                HStack(spacing: groupSpacing) {
                    ForEach(chartData.dataSets.dataSets) { dataSet in
                        GroupedBarGroup(chartData: chartData, dataSet: dataSet)
                    }
                }
                .onAppear {
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
                .accessibilityElement(children: .contain)
                .accessibilityLabel(LocalizedStringKey(chartData.metadata.title))
                .layoutNotifier(timer)
            } else { CustomNoDataView(chartData: chartData) }
        }
        .if(chartData.minValue.isLess(than: 0)) {
            $0.scaleEffect(y: CGFloat(chartData.maxValue/(chartData.maxValue - chartData.minValue)), anchor: .top)
        }
    }
}

internal struct GroupedBarGroup<ChartData>: View where ChartData: GroupedBarChartData {
    
    private let chartData: ChartData
    private let dataSet: GroupedBarDataSet
    
    init(
        chartData: ChartData,
        dataSet: GroupedBarDataSet
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(dataSet.dataPoints) { dataPoint in
                GroupedBarCell(chartData: chartData, dataPoint: dataPoint)
            }
        }
    }
}


internal struct GroupedBarCell<ChartData>: View where ChartData: GroupedBarChartData {
    
    private let chartData: ChartData
    private let dataPoint: GroupedBarDataPoint
    
    init(
        chartData: ChartData,
        dataPoint: GroupedBarDataPoint
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
    }
    
    internal var body: some View {
        Group {
            if dataPoint.group.colour.colourType == .colour,
               let colour = dataPoint.group.colour.colour
            {
                ColourBar(chartData: chartData,
                          dataPoint: dataPoint,
                          colour: colour)
                    .accessibilityLabel(LocalizedStringKey(dataPoint.group.title))
            } else if dataPoint.group.colour.colourType == .gradientColour,
                      let colours = dataPoint.group.colour.colours,
                      let startPoint = dataPoint.group.colour.startPoint,
                      let endPoint = dataPoint.group.colour.endPoint
            {
                GradientColoursBar(chartData: chartData,
                                   dataPoint: dataPoint,
                                   colours: colours,
                                   startPoint: startPoint,
                                   endPoint: endPoint)
                    .accessibilityLabel(LocalizedStringKey(dataPoint.group.title))
            } else if dataPoint.group.colour.colourType == .gradientStops,
                      let stops = dataPoint.group.colour.stops,
                      let startPoint = dataPoint.group.colour.startPoint,
                      let endPoint = dataPoint.group.colour.endPoint
            {
                let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                GradientStopsBar(chartData: chartData,
                                 dataPoint: dataPoint,
                                 stops: safeStops,
                                 startPoint: startPoint,
                                 endPoint: endPoint)
                    .accessibilityLabel(LocalizedStringKey(dataPoint.group.title))
            }
        }
    }
}
