//
//  API.swift
//  
//
//  Created by Will Dale on 07/03/2021.
//

import SwiftUI

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
        EmptyView()
//        Group {
//            switch self.chartType {
//            case .line:
//                if let stroke = self.strokeStyle {
//                    let strokeStyle = stroke.strokeToStrokeStyle()
//                    if let colour = self.colour.colour {
//                        HStack {
//                            LegendLine(width: width)
//                                .stroke(colour, style: strokeStyle)
//                                .frame(width: width, height: 3)
//                            Text(LocalizedStringKey(self.legend))
//                                .font(font)
//                                .foregroundColor(textColor)
//                        }
//                    } else if let colours = self.colour.colours  {
//                        HStack {
//                            LegendLine(width: width)
//                                .stroke(LinearGradient(gradient: Gradient(colors: colours),
//                                                       startPoint: .leading,
//                                                       endPoint: .trailing),
//                                        style: strokeStyle)
//                                .frame(width: width, height: 3)
//                            Text(LocalizedStringKey(self.legend))
//                                .font(font)
//                                .foregroundColor(textColor)
//                        }
//                    } else if let stops = self.colour.stops {
//                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
//                        HStack {
//                            LegendLine(width: width)
//                                .stroke(LinearGradient(gradient: Gradient(stops: stops),
//                                                       startPoint: .leading,
//                                                       endPoint: .trailing),
//                                        style: strokeStyle)
//                                .frame(width: width, height: 3)
//                            Text(LocalizedStringKey(self.legend))
//                                .font(font)
//                                .foregroundColor(textColor)
//                        }
//                    }
//                }
//
//            case.bar:
//                Group {
//                    if let colour = self.colour.colour {
//                        HStack {
//                            Rectangle()
//                                .fill(colour)
//                                .frame(width: width / 2, height: width / 2)
//                            Text(LocalizedStringKey(self.legend))
//                                .font(font)
//                        }
//                    } else if let colours = self.colour.colours,
//                              let startPoint = self.colour.startPoint,
//                              let endPoint = self.colour.endPoint
//                    {
//                        HStack {
//                            Rectangle()
//                                .fill(LinearGradient(gradient: Gradient(colors: colours),
//                                                     startPoint: startPoint,
//                                                     endPoint: endPoint))
//                                .frame(width: width / 2, height: width / 2)
//                            Text(LocalizedStringKey(self.legend))
//                                .font(font)
//                        }
//                    } else if let stops = self.colour.stops,
//                              let startPoint = self.colour.startPoint,
//                              let endPoint = self.colour.endPoint
//                    {
//                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
//                        HStack {
//                            Rectangle()
//                                .fill(LinearGradient(gradient: Gradient(stops: stops),
//                                                     startPoint: startPoint,
//                                                     endPoint: endPoint))
//                                .frame(width: width / 2, height: width / 2)
//                            Text(LocalizedStringKey(self.legend))
//                                .font(font)
//                        }
//                    }
//                }
//            case .pie:
//                if let colour = self.colour.colour {
//                    HStack {
//                        Circle()
//                            .fill(colour)
//                            .frame(width: width / 2, height: width / 2)
//                        Text(LocalizedStringKey(self.legend))
//                            .font(font)
//                    }
//                } else if let colours = self.colour.colours,
//                          let startPoint = self.colour.startPoint,
//                          let endPoint = self.colour.endPoint
//                {
//                    HStack {
//                        Circle()
//                            .fill(LinearGradient(gradient: Gradient(colors: colours),
//                                                 startPoint: startPoint,
//                                                 endPoint: endPoint))
//                            .frame(width: width / 2, height: width / 2)
//                        Text(LocalizedStringKey(self.legend))
//                            .font(font)
//                    }
//
//                } else if let stops = self.colour.stops,
//                          let startPoint = self.colour.startPoint,
//                          let endPoint = self.colour.endPoint
//                {
//                    let stops = GradientStop.convertToGradientStopsArray(stops: stops)
//                    HStack {
//                        Circle()
//                            .fill(LinearGradient(gradient: Gradient(stops: stops),
//                                                 startPoint: startPoint,
//                                                 endPoint: endPoint))
//                            .frame(width: width / 2, height: width / 2)
//                        Text(LocalizedStringKey(self.legend))
//                            .font(font)
//                    }
//                }
//            case .extraLine:
//                EmptyView()
//            }
//        }
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
        EmptyView()
//        Group {
//            if let colour = self.colour.colour {
//                HStack {
//                    Circle()
//                        .fill(colour)
//                        .frame(width: width, height: width)
//                    Text(LocalizedStringKey(self.legend))
//                        .font(font)
//                        .foregroundColor(textColor)
//                }
//            } else if let colours = self.colour.colours  {
//                HStack {
//                    Circle()
//                        .fill(LinearGradient(gradient: Gradient(colors: colours),
//                                             startPoint: .leading,
//                                             endPoint: .trailing))
//                        .frame(width: width, height: width)
//                    Text(LocalizedStringKey(self.legend))
//                        .font(font)
//                        .foregroundColor(textColor)
//                }
//            } else if let stops = self.colour.stops {
//                let stops = GradientStop.convertToGradientStopsArray(stops: stops)
//                HStack {
//                    Circle()
//                        .fill(LinearGradient(gradient: Gradient(stops: stops),
//                                             startPoint: .leading,
//                                             endPoint: .trailing))
//                        .frame(width: width, height: width)
//                    Text(LocalizedStringKey(self.legend))
//                        .font(font)
//                        .foregroundColor(textColor)
//                }
//            } else { EmptyView() }
//        }
    }
}
