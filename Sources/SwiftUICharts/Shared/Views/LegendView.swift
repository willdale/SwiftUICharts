//
//  LegendView.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

internal struct LegendView<T>: View where T: ChartData {
    
    @ObservedObject var chartData : T
    private let columns     : [GridItem]
    private let textColor   : Color
            
    internal init(chartData: T,
                  columns  : [GridItem],
                  textColor: Color
    ) {
        self.chartData = chartData
        self.columns   = columns
        self.textColor = textColor
    }
    
    internal var body: some View {
        
        LazyVGrid(columns: columns, alignment: .leading) {
            ForEach(chartData.legends) { legend in
                
                switch legend.chartType {

                case .line:

                    line(legend)

                case .bar:

                    bar(legend)
                        .if(scaleLegendBar(legend: legend)) { $0.scaleEffect(1.2, anchor: .leading) }
                case .pie:

                    pie(legend)
                        .if(scaleLegendPie(legend: legend)) {
                            $0.scaleEffect(1.2, anchor: .leading)
                        }
                }
            }
        }.id(UUID())
    }
    private func scaleLegendBar(legend: LegendData) -> Bool {
        
        if chartData is BarChartData {
            if let datapointID = chartData.infoView.touchOverlayInfo.first?.id as? UUID {
                return chartData.infoView.isTouchCurrent && legend.id == datapointID
            } else {
                return false
            }
        } else if chartData is GroupedBarChartData || chartData is StackedBarChartData {
            if let datapoint = chartData.infoView.touchOverlayInfo.first as? GroupedBarChartDataPoint {
                return chartData.infoView.isTouchCurrent && legend.colour == datapoint.group.colour
            } else {
                return false
            }
        } else {
            return false
        }
    }
    private func scaleLegendPie(legend: LegendData) -> Bool {
        
        if chartData is PieChartData || chartData is DoughnutChartData {
            if let datapointID = chartData.infoView.touchOverlayInfo.first?.id as? UUID {
                return chartData.infoView.isTouchCurrent && legend.id == datapointID
            } else {
                return false
            }
        } else {
           return false
       }
    }
    
    func line(_ legend: LegendData) -> some View {
        Group {
            if let stroke = legend.strokeStyle {
                let strokeStyle = Stroke.strokeToStrokeStyle(stroke: stroke)
                if let colour = legend.colour {
                    HStack {
                        LegendLine(width: 40)
                            .stroke(colour, style: strokeStyle)
                            .frame(width: 40, height: 3)
                        Text(legend.legend)
                            .font(.caption)
                            .foregroundColor(textColor)
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
                            .foregroundColor(textColor)
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
                            .foregroundColor(textColor)
                    }
                }
            }
        }
    }
    
    func bar(_ legend: LegendData) -> some View {
        Group {
            if let colour = legend.colour
            {
                HStack {
                    Rectangle()
                        .fill(colour)
                        .frame(width: 20, height: 20)
                    Text(legend.legend)
                        .font(.caption)
                }
            } else if let colours = legend.colours,
                      let startPoint = legend.startPoint,
                      let endPoint = legend.endPoint
            {
                HStack {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: colours),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                        .frame(width: 20, height: 20)
                    Text(legend.legend)
                        .font(.caption)
                }
            } else if let stops = legend.stops,
                      let startPoint = legend.startPoint,
                      let endPoint = legend.endPoint
            {
                let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                HStack {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                        .frame(width: 20, height: 20)
                    Text(legend.legend)
                        .font(.caption)
                }
            }
        }
    }
    
    func pie(_ legend: LegendData) -> some View {
        Group {
            if let colour = legend.colour {
                HStack {
                    Circle()
                        .fill(colour)
                        .frame(width: 20, height: 20)
                    Text(legend.legend)
                        .font(.caption)
                }
                
            } else if let colours = legend.colours,
                      let startPoint = legend.startPoint,
                      let endPoint = legend.endPoint
            {
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: colours),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                        .frame(width: 20, height: 20)
                    Text(legend.legend)
                        .font(.caption)
                }
                
            } else if let stops = legend.stops,
                      let startPoint = legend.startPoint,
                      let endPoint = legend.endPoint
            {
                let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                        .frame(width: 20, height: 20)
                    Text(legend.legend)
                        .font(.caption)
                }
            }
        }
    }
}
