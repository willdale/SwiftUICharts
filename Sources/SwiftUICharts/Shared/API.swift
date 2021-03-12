//
//  API.swift
//  
//
//  Created by Will Dale on 07/03/2021.
//

import SwiftUI

public struct InfoValue<T> : View where T: CTChartData {
    
    @ObservedObject var chartData: T
    
    public init(chartData: T) {
        self.chartData = chartData
    }
    
    public var body: some View {
        ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
            chartData.infoValueUnit(info: point)
        }
    }
}

public struct InfoDescription<T> : View where T: CTChartData {
    
    @ObservedObject var chartData: T
    
    public init(chartData: T) {
        self.chartData = chartData
    }
    
    public var body: some View {
        ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
            chartData.infoDescription(info: point)
        }
    }
}

public struct InfoExtra<T>: View where T: CTChartData {
    
    @ObservedObject var chartData: T
    
    private let text: String
    
    public init(chartData: T, text: String) {
        self.chartData = chartData
        self.text = text
    }

    public var body: some View {
        if chartData.infoView.isTouchCurrent {
            Text(text)
        } else {
            EmptyView()
        }
    }
}

extension LegendData {
    public func getLegend(textColor: Color) -> some View {
        Group {
            switch self.chartType {
            case .line:
                if let stroke = self.strokeStyle {
                    let strokeStyle = stroke.strokeToStrokeStyle()
                    if let colour = self.colour.colour {
                        HStack {
                            LegendLine(width: 40)
                                .stroke(colour, style: strokeStyle)
                                .frame(width: 40, height: 3)
                            Text(self.legend)
                                .font(.caption)
                                .foregroundColor(textColor)
                        }
                        
                    } else if let colours = self.colour.colours  {
                        HStack {
                            LegendLine(width: 40)
                                .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                                       startPoint: .leading,
                                                       endPoint: .trailing),
                                        style: strokeStyle)
                                .frame(width: 40, height: 3)
                            Text(self.legend)
                                .font(.caption)
                                .foregroundColor(textColor)
                        }
                    } else if let stops = self.colour.stops {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        HStack {
                            LegendLine(width: 40)
                                .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                                       startPoint: .leading,
                                                       endPoint: .trailing),
                                        style: strokeStyle)
                                .frame(width: 40, height: 3)
                            Text(self.legend)
                                .font(.caption)
                                .foregroundColor(textColor)
                        }
                    }
                }
                
            case.bar:
                Group {
                    if let colour = self.colour.colour
                    {
                        HStack {
                            Rectangle()
                                .fill(colour)
                                .frame(width: 20, height: 20)
                            Text(self.legend)
                                .font(.caption)
                        }
                    } else if let colours    = self.colour.colours,
                              let startPoint = self.colour.startPoint,
                              let endPoint   = self.colour.endPoint
                    {
                        HStack {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: colours),
                                                     startPoint: startPoint,
                                                     endPoint: endPoint))
                                .frame(width: 20, height: 20)
                            Text(self.legend)
                                .font(.caption)
                        }
                    } else if let stops      = self.colour.stops,
                              let startPoint = self.colour.startPoint,
                              let endPoint   = self.colour.endPoint
                    {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        HStack {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(stops: stops),
                                                     startPoint: startPoint,
                                                     endPoint: endPoint))
                                .frame(width: 20, height: 20)
                            Text(self.legend)
                                .font(.caption)
                        }
                    }
                }
            case .pie:
                if let colour = self.colour.colour {
                    HStack {
                        Circle()
                            .fill(colour)
                            .frame(width: 20, height: 20)
                        Text(self.legend)
                            .font(.caption)
                    }
                    
                } else if let colours    = self.colour.colours,
                          let startPoint = self.colour.startPoint,
                          let endPoint   = self.colour.endPoint
                {
                    HStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                                 startPoint: startPoint,
                                                 endPoint: endPoint))
                            .frame(width: 20, height: 20)
                        Text(self.legend)
                            .font(.caption)
                    }
                    
                } else if let stops      = self.colour.stops,
                          let startPoint = self.colour.startPoint,
                          let endPoint   = self.colour.endPoint
                {
                    let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                    HStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(stops: stops),
                                                 startPoint: startPoint,
                                                 endPoint: endPoint))
                            .frame(width: 20, height: 20)
                        Text(self.legend)
                            .font(.caption)
                    }
                }
            }
        }
    }
    public func getLegendAsCircle(textColor: Color) -> some View {
        Group {
            if let colour = self.colour.colour {
                HStack {
                    Circle()
                        .fill(colour)
                        .frame(width: 12, height: 12)
                    Text(self.legend)
                        .font(.caption)
                        .foregroundColor(textColor)
                }
                
            } else if let colours = self.colour.colours  {
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: colours),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: 12, height: 12)
                    Text(self.legend)
                        .font(.caption)
                        .foregroundColor(textColor)
                }
            } else if let stops = self.colour.stops {
                let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: 12, height: 12)
                    Text(self.legend)
                        .font(.caption)
                        .foregroundColor(textColor)
                }
            } else { EmptyView() }
        }
    }
                
    internal func accessibilityLegendLabel() -> String {
        switch self.chartType {
        case .line:
            if self.prioity == 1 {
                return "Line Chart Legend"
            } else {
                return "P O I Marker Legend"
            }
        case .bar:
            if self.prioity == 1 {
                return "Bar Chart Legend"
            } else {
                return "P O I Marker Legend"
            }
        case .pie:
            if self.prioity == 1 {
                return "Pie Chart Legend"
            } else {
                return "P O I Marker Legend"
            }
        }
    }
}
