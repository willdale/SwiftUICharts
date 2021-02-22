//
//  MultiLayerPie.swift
//  
//
//  Created by Will Dale on 22/02/2021.
//

import SwiftUI

public struct MultiLayerPie<ChartData>: View where ChartData: MultiLayerPieChartData {
    
    @ObservedObject var chartData: ChartData

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
                
                if let points = data.layerDataPoints {
                    ForEach(points, id: \.self) { point in
                        DoughnutSegmentShape(id:         point.id,
                                             startAngle: point.startAngle,
                                             amount:     point.amount)
                            .strokeBorder(point.colour, lineWidth: 120)
                        
                        
                        
                        if let pointsTwo = point.layerDataPoints {
                            ForEach(pointsTwo, id: \.self) { pointTwo in
                                DoughnutSegmentShape(id:         pointTwo.id,
                                                     startAngle: pointTwo.startAngle,
                                                     amount:     pointTwo.amount)
                                    .strokeBorder(pointTwo.colour, lineWidth: 80)
                                
                                
                                if let pointsThree = pointTwo.layerDataPoints {
                                    ForEach(pointsThree, id: \.self) { pointThree in
                                        DoughnutSegmentShape(id:         pointThree.id,
                                                             startAngle: pointThree.startAngle,
                                                             amount:     pointThree.amount)
                                            .strokeBorder(pointThree.colour, lineWidth: 40)
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
