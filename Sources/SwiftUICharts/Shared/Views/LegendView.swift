//
//  LegendView.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

internal struct LegendView<T>: View where T: ChartData {
    
    @ObservedObject var chartData : T
        
    internal init(chartData: T) {
        self.chartData = chartData
    }
    
    // Expose to API ??
    let columns = [
//        GridItem(.flexible()),
        GridItem(.flexible())
        //geo.size.width / CGFloat(columns.count) / 2
    ]
    
    internal var body: some View {
        
        LazyVGrid(columns: columns, alignment: .leading) {
            ForEach(chartData.legendOrder(), id: \.self) { legend in
                
                switch legend.chartType {
                
                case .line:
                    if let stroke = legend.strokeStyle {
                        let strokeStyle = Stroke.strokeToStrokeStyle(stroke: stroke)
                        if let colour = legend.colour {
                            HStack {
                                LegendLine(width: 40)
                                    .stroke(colour, style: strokeStyle)
                                    .frame(width: 40, height: 3)
                                Text(legend.legend)
                                    .font(.caption)
                            }
                        } else if let colours = legend.colours  {
                            HStack {
                                LegendLine(width: 40)
                                    .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                                           startPoint: .leading,
                                                           endPoint: .trailing),
                                            style: strokeStyle)
                                    .frame(width: 40, height: 3)
                                Text(legend.legend)
                                    .font(.caption)
                            }
                        } else if let stops = legend.stops {
                            let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                            HStack {
                                LegendLine(width: 40)
                                    .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                                           startPoint: .leading,
                                                           endPoint: .trailing),
                                            style: strokeStyle)
                                    .frame(width: 40, height: 3)
                                Text(legend.legend)
                                    .font(.caption)
                            }
                        }
                    }
                case .bar:
                    Text("Hello")
//                    if let colour = legend.colour
//                    {
//                        HStack {
//                            Rectangle()
//                                .fill(colour)
//                                .frame(width: 20, height: 20)
//                            Text(legend.legend)
//                                .font(.caption)
//                        }
//                    } else if let colours = legend.colours,
//                              let startPoint = legend.startPoint,
//                              let endPoint = legend.endPoint
//                    {
//                        HStack {
//                            Rectangle()
//                                .fill(LinearGradient(gradient: Gradient(colors: colours),
//                                                     startPoint: startPoint,
//                                                     endPoint: endPoint))
//                                .frame(width: 20, height: 20)
//                            Text(legend.legend)
//                                .font(.caption)
//                        }
//                    } else if let stops = legend.stops,
//                              let startPoint = legend.startPoint,
//                              let endPoint = legend.endPoint
//                    {
//                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
//                        HStack {
//                            Rectangle()
//                                .fill(LinearGradient(gradient: Gradient(stops: stops),
//                                                     startPoint: startPoint,
//                                                     endPoint: endPoint))
//                                .frame(width: 20, height: 20)
//                            Text(legend.legend)
//                                .font(.caption)
//                        }
//                    }
                }
            }
        }
    }
}
