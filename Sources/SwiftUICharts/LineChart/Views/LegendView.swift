//
//  LegendView.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

internal struct LegendView: View {
    
    @ObservedObject var chartData : ChartData
        
    internal init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    // Expose to API ??
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    internal var body: some View {
        
        LazyVGrid(columns: columns, alignment: .leading) {
            ForEach(chartData.legends, id: \.self) { legend in
                
                let strokeStyle = StrokeStyle(lineWidth    : legend.lineWidth,
                                              lineCap      : legend.lineCap,
                                              lineJoin     : legend.lineJoin,
                                              miterLimit   : legend.miterLimit,
                                              dash         : legend.dash,
                                              dashPhase    : legend.dashPhase)
                
                GeometryReader { geo in
                    if let colour = legend.colour {
                        HStack {
                            LegendLine(width: geo.size.width / CGFloat(columns.count) / 2)
                                .stroke(colour, style: strokeStyle)
                                .frame(width: geo.size.width / CGFloat(columns.count) / 2, height: 3)
                            Text(legend.legend)
                                .font(.caption)
                        }
                    } else if let colours = legend.colours  {
                        HStack {
                            LegendLine(width: geo.size.width / CGFloat(columns.count) / 2)
                                .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                                       startPoint: .leading,
                                                       endPoint: .trailing),
                                        style: strokeStyle)
                                .frame(width: geo.size.width / CGFloat(columns.count) / 2, height: 3)
                            Text(legend.legend)
                                .font(.caption)
                        }
                    } else if let stops = legend.stops {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        HStack {
                            LegendLine(width: geo.size.width / CGFloat(columns.count) / 2)
                                .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                                       startPoint: .leading,
                                                       endPoint: .trailing),
                                        style: strokeStyle)
                                .frame(width: geo.size.width / CGFloat(columns.count) / 2, height: 3)
                            Text(legend.legend)
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}
