//
//  API.swift
//  
//
//  Created by Will Dale on 07/03/2021.
//

import SwiftUI

/**
 Displays the data points value with the unit.
 */
public struct InfoValue<T>: View where T: CTChartData {
    
    @ObservedObject private var chartData: T
    
    public init(chartData: T) {
        self.chartData = chartData
    }
    
    public var body: some View {
        ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
            chartData.infoValueUnit(info: point)
        }
    }
}

/**
 Displays the data points description.
 */
public struct InfoDescription<T>: View where T: CTChartData {
    
    @ObservedObject private var chartData: T
    
    public init(chartData: T) {
        self.chartData = chartData
    }
    
    public var body: some View {
        ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
            chartData.infoDescription(info: point)
        }
    }
}

/**
 Option the as a String between the Value and the Description.
 */
public struct InfoExtra<T>: View where T: CTChartData {
    
    @ObservedObject private var chartData: T
    private let text: String
    
    public init(chartData: T, text: String) {
        self.chartData = chartData
        self.text = text
    }
    
    public var body: some View {
        if chartData.infoView.isTouchCurrent {
            Text(LocalizedStringKey(text))
        } else {
            EmptyView()
        }
    }
}

extension LegendData {
    /**
     Get the legend as a view.
     
     - Parameter textColor: Colour of the text
     - Returns: The relevent legend as a view.
     */
    public func getLegend(
        width: CGFloat = 40,
        font: Font = .caption,
        textColor: Color = .primary
    ) -> some View {
        Group {
            switch self.chartType {
            case .line:
                if let stroke = self.strokeStyle {
                    let strokeStyle = stroke.strokeToStrokeStyle()
                    if let colour = self.colour.colour {
                        HStack {
                            LegendLine(width: width)
                                .stroke(colour, style: strokeStyle)
                                .frame(width: width, height: 3)
                            Text(LocalizedStringKey(self.legend))
                                .font(font)
                                .foregroundColor(textColor)
                        }
                    } else if let colours = self.colour.colours  {
                        HStack {
                            LegendLine(width: width)
                                .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                                       startPoint: .leading,
                                                       endPoint: .trailing),
                                        style: strokeStyle)
                                .frame(width: width, height: 3)
                            Text(LocalizedStringKey(self.legend))
                                .font(font)
                                .foregroundColor(textColor)
                        }
                    } else if let stops = self.colour.stops {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        HStack {
                            LegendLine(width: width)
                                .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                                       startPoint: .leading,
                                                       endPoint: .trailing),
                                        style: strokeStyle)
                                .frame(width: width, height: 3)
                            Text(LocalizedStringKey(self.legend))
                                .font(font)
                                .foregroundColor(textColor)
                        }
                    }
                }
                
            case.bar:
                Group {
                    if let colour = self.colour.colour {
                        HStack {
                            Rectangle()
                                .fill(colour)
                                .frame(width: width / 2, height: width / 2)
                            Text(LocalizedStringKey(self.legend))
                                .font(font)
                        }
                    } else if let colours = self.colour.colours,
                              let startPoint = self.colour.startPoint,
                              let endPoint = self.colour.endPoint
                    {
                        HStack {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: colours),
                                                     startPoint: startPoint,
                                                     endPoint: endPoint))
                                .frame(width: width / 2, height: width / 2)
                            Text(LocalizedStringKey(self.legend))
                                .font(font)
                        }
                    } else if let stops = self.colour.stops,
                              let startPoint = self.colour.startPoint,
                              let endPoint = self.colour.endPoint
                    {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        HStack {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(stops: stops),
                                                     startPoint: startPoint,
                                                     endPoint: endPoint))
                                .frame(width: width / 2, height: width / 2)
                            Text(LocalizedStringKey(self.legend))
                                .font(font)
                        }
                    }
                }
            case .pie:
                if let colour = self.colour.colour {
                    HStack {
                        Circle()
                            .fill(colour)
                            .frame(width: width / 2, height: width / 2)
                        Text(LocalizedStringKey(self.legend))
                            .font(font)
                    }
                } else if let colours = self.colour.colours,
                          let startPoint = self.colour.startPoint,
                          let endPoint = self.colour.endPoint
                {
                    HStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                                 startPoint: startPoint,
                                                 endPoint: endPoint))
                            .frame(width: width / 2, height: width / 2)
                        Text(LocalizedStringKey(self.legend))
                            .font(font)
                    }
                    
                } else if let stops = self.colour.stops,
                          let startPoint = self.colour.startPoint,
                          let endPoint = self.colour.endPoint
                {
                    let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                    HStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(stops: stops),
                                                 startPoint: startPoint,
                                                 endPoint: endPoint))
                            .frame(width: width / 2, height: width / 2)
                        Text(LocalizedStringKey(self.legend))
                            .font(font)
                    }
                }
            }
        }
    }
    /**
     Get the legend as a view where the colour is indicated by a Circle.
     
     - Parameter textColor: Colour of the text
     - Returns: The relevent legend as a view.
     */
    public func getLegendAsCircle(
        width: CGFloat = 12,
        font: Font = .caption,
        textColor: Color
    ) -> some View {
        Group {
            if let colour = self.colour.colour {
                HStack {
                    Circle()
                        .fill(colour)
                        .frame(width: width, height: width)
                    Text(LocalizedStringKey(self.legend))
                        .font(font)
                        .foregroundColor(textColor)
                }
            } else if let colours = self.colour.colours  {
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: colours),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: width, height: width)
                    Text(LocalizedStringKey(self.legend))
                        .font(font)
                        .foregroundColor(textColor)
                }
            } else if let stops = self.colour.stops {
                let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: width, height: width)
                    Text(LocalizedStringKey(self.legend))
                        .font(font)
                        .foregroundColor(textColor)
                }
            } else { EmptyView() }
        }
    }
    
    internal func accessibilityLegendLabel() -> String {
        switch self.chartType {
        case .line:
            if self.prioity == 1 {
                return "Line-Chart-Legend"
            } else {
                return "P-O-I-Marker-Legend"
            }
        case .bar:
            if self.prioity == 1 {
                return "Bar-Chart-Legend"
            } else {
                return "P-O-I-Marker-Legend"
            }
        case .pie:
            if self.prioity == 1 {
                return "Pie-Chart-Legend"
            } else {
                return "P-O-I-Marker-Legend"
            }
        }
    }
}
