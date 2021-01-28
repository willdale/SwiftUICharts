//
//  PieChart.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

public struct PieChart<ChartData>: View where ChartData: PieChartData {
    
    @ObservedObject var chartData   : ChartData
    
    let pieSegments : [PieSegmentShape]
    let strokeWidth : Double?
    
    @State var startAnimation : Bool = false
    
    public init(chartData  : ChartData,
                strokeWidth: Double? = nil
    ) {
        self.chartData = chartData
        
        self.strokeWidth = strokeWidth
        
        var segments    = [PieSegmentShape]()
        let total       = chartData.dataSets.dataPoints.reduce(0) { $0 + $1.value }
        var startAngle  = -Double.pi / 2
        
        for data in chartData.dataSets.dataPoints {
            let amount = .pi * 2 * (data.value / total)
            let segment = PieSegmentShape(data: data, startAngle: startAngle, amount: amount)
            segments.append(segment)
            startAngle += amount
        }
        pieSegments = segments
        
        chartData.setupLegends()
    }
    
    @ViewBuilder
    var mask: some View {
        if let strokeWidth = strokeWidth {
            Circle()
                .strokeBorder(Color(.white), lineWidth: CGFloat(strokeWidth))
        } else {
            Circle()
        }
    }
    
    public var body: some View {
        ZStack {
            ForEach(pieSegments) { segment in
                segment
                    .fill(segment.data.colour)
            }
        }
        .mask(mask)
        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = true
        }
    }
}
