//
//  TestView.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

struct LineChartViewTestOne: View {
    
    let data : ChartData
    
    var body: some View {
        FilledLineChart()
            .touchLocation()
            
            .xAxisGrid(numberOfLines: 7)
            .yAxisGrid(numberOfLines: 7)

            .xAxisLabels(labelsFrom: .xAxisLabelArray)
            .yAxisLabels(numberOfLabels: 3)

            .yAxisPOI(markerName: "Marker", markerValue: 75, lineColour: Color(.systemBlue), lineWidth: 3, dash: [3, 6])
            .averageLine(lineWidth: 3, dash: [6, 12])

            .legends()
            .titleView()
            .environmentObject(data)
            
    }
}
struct LineChartViewTestTwo: View {
    
    let data : ChartData
    
    var body: some View {
        FilledLineChart()
            .touchLocation()
            .pointMarkers()
            
            .xAxisGrid(numberOfLines: 7)
            .yAxisGrid(numberOfLines: 7)
            
            .xAxisLabels(labelsFrom: .xAxisLabelArray)
            .yAxisLabels(numberOfLabels: 3)
            
            .yAxisPOI(markerName: "Marker", markerValue: 75, lineColour: Color(.systemBlue), lineWidth: 3, dash: [3, 6])
            .averageLine(lineWidth: 3, dash: [6, 12])
            
            .legends()
            .titleView()
            .environmentObject(data)
            
    }
}
struct LineChartViewTestThree: View {
    
    let data : ChartData
    
    var body: some View {
        FilledLineChart()
            .touchLocation()
            .pointMarkers()
            .yAxisGrid(numberOfLines: 7)
            .xAxisLabels()
            .yAxisLabels(numberOfLabels: 3)
            .legends()
            .titleView()
            .environmentObject(data)
    }
}
