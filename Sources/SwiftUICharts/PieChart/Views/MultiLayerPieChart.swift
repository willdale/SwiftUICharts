//
//  MultiLayerPie.swift
//  
//
//  Created by Will Dale on 22/02/2021.
//

import SwiftUI

/**
 View for creating a multi layer pie chart.
 
 Uses `MultiLayerPieChartData` data model.
 
 # Declaration
 ```
 MultiLayerPieChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .infoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct MultiLayerPieChart<ChartData>: View where ChartData: MultiLayerPieChartData {
    
    @ObservedObject var chartData: ChartData

    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be MultiLayerPieChartData.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    @State private var incept: CGFloat = 0
    
    public var body: some View {
        
        ZStack {
            ForEach(chartData.dataSets.dataPoints, id: \.self) { data in
                PieSegmentShape(id:         data.id,
                                startAngle: data.startAngle,
                                amount:     data.amount)
                    .fill(data.colour)
                    .accessibilityLabel(Text("\(chartData.metadata.title)"))
                    .accessibilityValue(Text(String(format: chartData.infoView.touchSpecifier, data.value) + "\(data.pointDescription ?? "")"))
                
                if let points = data.layerDataPoints {
                    ForEach(points, id: \.self) { point in
                        DoughnutSegmentShape(id:         point.id,
                                             startAngle: point.startAngle,
                                             amount:     point.amount)
                            .strokeBorder(point.colour, lineWidth: 120)
                            .accessibilityLabel(Text("\(chartData.metadata.title)"))
                            .accessibilityValue(Text(String(format: chartData.infoView.touchSpecifier, point.value) + "\(point.pointDescription ?? "")"))
                        
                        if let pointsTwo = point.layerDataPoints {
                            ForEach(pointsTwo, id: \.self) { pointTwo in
                                DoughnutSegmentShape(id:         pointTwo.id,
                                                     startAngle: pointTwo.startAngle,
                                                     amount:     pointTwo.amount)
                                    .strokeBorder(pointTwo.colour, lineWidth: 80)
                                    .accessibilityLabel(Text("\(chartData.metadata.title)"))
                                    .accessibilityValue(Text(String(format: chartData.infoView.touchSpecifier, pointTwo.value) + "\(pointTwo.pointDescription ?? "")"))
                                
                                if let pointsThree = pointTwo.layerDataPoints {
                                    ForEach(pointsThree, id: \.self) { pointThree in
                                        DoughnutSegmentShape(id:         pointThree.id,
                                                             startAngle: pointThree.startAngle,
                                                             amount:     pointThree.amount)
                                            .strokeBorder(pointThree.colour, lineWidth: 40)
                                            .accessibilityLabel(Text("\(chartData.metadata.title)"))
                                            .accessibilityValue(Text(String(format: chartData.infoView.touchSpecifier, pointThree.value) + "\(pointThree.pointDescription ?? "")"))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
