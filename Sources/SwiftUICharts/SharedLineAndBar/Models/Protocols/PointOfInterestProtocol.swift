//
//  PointOfInterestProtocol.swift
//
//
//  Created by Will Dale on 11/06/2021.
//

import SwiftUI

public protocol PointOfInterestProtocol {
    
    // MARK: Ordinate
    /**
     A type representing a Shape for displaying a line
     as a POI.
     */
    associatedtype MarkerShape: Shape
    
    /**
     Displays a line marking a Point Of Interest.
     
     In standard charts this will return a horizontal line.
     In horizontal charts this will return a vertical line.
     
     - Parameters:
        - value: Value of of the POI.
        - range: Difference between the highest and lowest values in the data set.
        - minValue: Lowest value in the data set.
     - Returns: A line shape at a specified point.
     */
    func poiMarker(value: Double, range: Double, minValue: Double) -> MarkerShape
    
    /**
     A type representing a View for displaying a label
     as a POI in an axis.
     */
    associatedtype LabelAxis: View
    /**
     Displays a label and box that mark a Point Of Interest
     in an axis.
     
     In standard charts this will display leading or trailing.
     In horizontal charts this will display bottom or top.
     */
    func poiLabelAxis(markerValue: Double, specifier: String, formatter: NumberFormatter?, labelFont: Font, labelColour: Color, labelBackground: Color, labelBorderColor: Color, customLabelShape: CustomLabelShape?, padding: CGFloat?) -> LabelAxis
    
    /**
     A type representing a View for displaying a label
     as a POI in the center.
     */
    associatedtype LabelCenter: View
    /**
     Displays a label and box that mark a Point Of Interest
     in the center.
     
     In standard charts this will display leading or trailing.
     In horizontal charts this will display bottom or top.
     */
    func poiLabelCenter(markerValue: Double, specifier: String, formatter: NumberFormatter?, labelFont: Font, labelColour: Color, labelBackground: Color, labelBorderColor: Color, strokeStyle: StrokeStyle, customLabelShape: CustomLabelShape?, padding: CGFloat?) -> LabelCenter
    
    /**
     A type representing a View for displaying a label
     as a POI at a relative location from the leading axis.
     */
    associatedtype LabelPosition: View
    /**
     Displays a label and box that mark a Point Of Interest
     at a relative location from the axis.
     
     In standard charts this will display leading or trailing.
     In horizontal charts this will display bottom or top.
     */
    func poiLabelPosition(location: CGFloat, markerValue: Double, specifier: String, formatter: NumberFormatter?, labelFont: Font, labelColour: Color, labelBackground: Color, labelBorderColor: Color, strokeStyle: StrokeStyle, customLabelShape: CustomLabelShape?, padding: CGFloat?) -> LabelPosition
    
    
    /**
     Sets the position of the POI Label when it's over
     one of the axes.
     
     - Parameters:
        - frame: Size of the chart.
        - markerValue: Value of the POI marker.
        - minValue: Lowest value in the data set.
        - range: Difference between the highest and lowest values in the data set.
     - Returns: Position of label.
     */
    func poiValueLabelPositionAxis(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint
    
    /**
     Sets the position of the POI Label when it's in
     the center of the view.
     
     - Parameters:
        - frame: Size of the chart.
        - markerValue: Value of the POI marker.
        - minValue: Lowest value in the data set.
        - range: Difference between the highest and lowest values in the data set.
     - Returns: Position of label.
     */
    func poiValueLabelPositionCenter(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint
    
    /**
     Sets the position of the POI Label when it's at
     a relative location from the leading axis.
     
     - Parameters:
        - frame: Size of the chart.
        - markerValue: Value of the POI marker.
        - minValue: Lowest value in the data set.
        - range: Difference between the highest and lowest values in the data set.
     - Returns: Position of label.
     */
    func poiValueLabelRelativePosition(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint
    
    
    
   // MARK: Abscissa
    /**
     A type representing a Shape for displaying a line
     as a POI.
     */
    associatedtype AbscissaMarkerShape: Shape
    
    /**
     Displays a line marking a Point Of Interest.
     
     In standard charts this will return a horizontal line.
     In horizontal charts this will return a vertical line.
     
     - Parameters:
        - value: Value of of the POI.
        - range: Difference between the highest and lowest values in the data set.
        - minValue: Lowest value in the data set.
     - Returns: A line shape at a specified point.
     */
    func poiAbscissaMarker(markerValue: Int, dataPointCount: Int) -> AbscissaMarkerShape
    
    /**
     A type representing a View for displaying a label
     as a POI in an axis.
     */
    associatedtype AbscissaLabelAxis: View
    /**
     Displays a label and box that mark a Point Of Interest
     in an axis.
     
     In standard charts this will display leading or trailing.
     In horizontal charts this will display bottom or top.
     */
    func poiAbscissaLabelAxis(marker: String, labelFont: Font, labelColour: Color, labelBackground: Color, labelBorderColor: Color, customLabelShape: CustomLabelShape?, padding: CGFloat?) -> AbscissaLabelAxis
    
    /**
     A type representing a View for displaying a label
     as a POI in an axis.
     */
    associatedtype AbscissaLabelCenter: View
    /**
     Displays a label and box that mark a Point Of Interest
     in an axis.
     
     In standard charts this will display leading or trailing.
     In horizontal charts this will display bottom or top.
     */
    func poiAbscissaLabelCenter(marker: String, labelFont: Font, labelColour: Color, labelBackground: Color, labelBorderColor: Color, strokeStyle: StrokeStyle, customLabelShape: CustomLabelShape?, padding: CGFloat?) -> AbscissaLabelCenter
    
    /**
     A type representing a View for displaying a label
     as a POI at a relative location from the leading axis.
     */
    associatedtype AbscissaLabelPosition: View
    /**
     Displays a label and box that mark a Point Of Interest
     at a relative location from the leading axis.
     
     In standard charts this will display leading or trailing.
     In horizontal charts this will display bottom or top.
     */
    func poiAbscissaLabelPosition(location: CGFloat, marker: String, labelFont: Font, labelColour: Color, labelBackground: Color, labelBorderColor: Color, strokeStyle: StrokeStyle, customLabelShape: CustomLabelShape?, padding: CGFloat?) -> AbscissaLabelPosition
    
    
    /**
     Sets the position of the POI Label when it's over
     one of the axes.
     
     - Parameters:
        - frame: Size of the chart.
        - markerValue: Value of the POI marker.
        - minValue: Lowest value in the data set.
        - range: Difference between the highest and lowest values in the data set.
     - Returns: Position of label.
     */
    func poiAbscissaValueLabelPositionAxis(frame: CGRect, markerValue: Int, count: Int) -> CGPoint
    
    /**
     Sets the position of the POI Label when it's in
     the center of the view.
     
     - Parameters:
        - frame: Size of the chart.
        - markerValue: Value of the POI marker.
        - minValue: Lowest value in the data set.
        - range: Difference between the highest and lowest values in the data set.
     - Returns: Position of label.
     */
    func poiAbscissaValueLabelPositionCenter(frame: CGRect, markerValue: Int, count: Int) -> CGPoint
    
    /**
     Sets the position of the POI Label when it's at
     a relative location from the leading axis.
     
     - Parameters:
        - frame: Size of the chart.
        - markerValue: Value of the POI marker.
        - minValue: Lowest value in the data set.
        - range: Difference between the highest and lowest values in the data set.
     - Returns: Position of label.
     */
    func poiAbscissaValueLabelRelativePosition(frame: CGRect, markerValue: Int, count: Int) -> CGPoint
}


// MARK: - Extensions
//
//
//
// MARK: - Ordinate
extension CTLineBarChartDataProtocol where Self: PointOfInterestProtocol {
    
    func poiLabel(value: Double, specifier: String, formatter: NumberFormatter?) -> LocalizedStringKey {
        if let formatter = formatter {
            return LocalizedStringKey(formatter.string(from: NSNumber(floatLiteral: value)) ?? "")
        } else {
            return LocalizedStringKey("\(value, specifier: specifier)")
        }
    }
    
    public func poiMarker(value: Double, range: Double, minValue: Double) -> some Shape {
        HorizontalMarker(chartData: self, value: value, range: range, minValue: minValue)
    }
    
    public func poiLabelAxis(
     markerValue: Double,
     specifier: String,
     formatter: NumberFormatter?,
     labelFont: Font,
     labelColour: Color,
     labelBackground: Color,
     labelBorderColor: Color,
     customLabelShape: CustomLabelShape?,
     padding: CGFloat?
    ) -> some View {
        Text(poiLabel(value: markerValue, specifier: specifier, formatter: formatter))
            .font(labelFont)
            .foregroundColor(labelColour)
            .padding(padding ?? 4)
            .background(labelBackground)
            .ifElse(self.chartStyle.yAxisLabelPosition == .leading, if: {
                $0
                    .clipShape(customLabelShape ?? CustomLabelShape(LeadingLabelShape()))
                    .overlay((customLabelShape ?? CustomLabelShape(LeadingLabelShape()))
                                .stroke(labelBorderColor)
                    )
            }, else: {
                $0
                    .clipShape(customLabelShape ?? CustomLabelShape(TrailingLabelShape()))
                    .overlay((customLabelShape ?? CustomLabelShape(TrailingLabelShape()))
                                .stroke(labelBorderColor)
                    )
            })
    }
    
   public func poiLabelCenter(
    markerValue: Double,
    specifier: String,
    formatter: NumberFormatter?,
    labelFont: Font,
    labelColour: Color,
    labelBackground: Color,
    labelBorderColor: Color,
    strokeStyle: StrokeStyle,
    customLabelShape: CustomLabelShape?,
    padding: CGFloat?
   ) -> some View {
       Text(poiLabel(value: markerValue, specifier: specifier, formatter: formatter))
           .font(labelFont)
           .foregroundColor(labelColour)
           .padding(.all, padding)
           .background(labelBackground)
           .clipShape(customLabelShape ?? CustomLabelShape(DiamondShape()))
           .overlay((customLabelShape ?? CustomLabelShape(DiamondShape()))
                        .stroke(labelBorderColor, style: strokeStyle)
           )
    }
    
    public func poiLabelPosition(
     location: CGFloat,
     markerValue: Double,
     specifier: String,
     formatter: NumberFormatter?,
     labelFont: Font,
     labelColour: Color,
     labelBackground: Color,
     labelBorderColor: Color,
     strokeStyle: StrokeStyle,
     customLabelShape: CustomLabelShape?,
     padding: CGFloat?
    ) -> some View {
        var distanceFromLeading: CGFloat = 0.5
        if 0...1 ~= location {
            if self.chartStyle.yAxisLabelPosition == .trailing {
                distanceFromLeading = 1 - location
            } else {
                distanceFromLeading = location
            }
        }
        
        return PositionedPOILabel(content: {
            Text(self.poiLabel(value: markerValue, specifier: specifier, formatter: formatter))
                .font(labelFont)
                .foregroundColor(labelColour)
                .padding(.all, padding)
                .background(labelBackground)
                .clipShape(customLabelShape ?? CustomLabelShape(DiamondShape()))
                .overlay((customLabelShape ?? CustomLabelShape(DiamondShape()))
                            .stroke(labelBorderColor, style: strokeStyle)
                )
        }, orientation: .horizontal, distanceFromLeading: distanceFromLeading)
    }
}
extension CTLineBarChartDataProtocol where Self: PointOfInterestProtocol & isHorizontal {
    
    public func poiMarker(value: Double, range: Double, minValue: Double) -> some Shape {
        VerticalMarker(chartData: self, value: value, range: range, minValue: minValue)
    }
    
    public func poiLabelAxis(
     markerValue: Double,
     specifier: String,
     labelFont: Font,
     labelColour: Color,
     labelBackground: Color,
     labelBorderColor: Color,
     customLabelShape: CustomLabelShape?,
     padding: CGFloat?
    ) -> some View {
        Text(LocalizedStringKey("\(markerValue, specifier: specifier)"))
            .font(labelFont)
            .foregroundColor(labelColour)
            .padding(padding ?? 4)
            .background(labelBackground)
            .ifElse(self.chartStyle.xAxisLabelPosition == .bottom, if: {
                $0
                    .clipShape(customLabelShape ?? CustomLabelShape(BottomLabelShape()))
                    .overlay((customLabelShape ?? CustomLabelShape(BottomLabelShape()))
                                .stroke(labelBorderColor)
                    )
            }, else: {
                $0
                    .clipShape(customLabelShape ?? CustomLabelShape(TopLabelShape()))
                    .overlay((customLabelShape ?? CustomLabelShape(TopLabelShape()))
                                .stroke(labelBorderColor)
                    )
            })
    }
    
    public func poiLabelPosition(
     location: CGFloat,
     markerValue: Double,
     specifier: String,
     formatter: NumberFormatter?,
     labelFont: Font,
     labelColour: Color,
     labelBackground: Color,
     labelBorderColor: Color,
     strokeStyle: StrokeStyle,
     customLabelShape: CustomLabelShape?,
     padding: CGFloat?
    ) -> some View {
        
        var distanceFromLeading: CGFloat = 0.5
        if 0...1 ~= location {
            if self.chartStyle.xAxisLabelPosition == .bottom {
                distanceFromLeading = 1 - location
            } else {
                distanceFromLeading = location
            }
        }
        
        return PositionedPOILabel(content: {
            Text(self.poiLabel(value: markerValue, specifier: specifier, formatter: formatter))
                .font(labelFont)
                .foregroundColor(labelColour)
                .padding(.all, padding)
                .background(labelBackground)
                .clipShape(customLabelShape ?? CustomLabelShape(DiamondShape()))
                .overlay((customLabelShape ?? CustomLabelShape(DiamondShape()))
                            .stroke(labelBorderColor, style: strokeStyle)
                )
        }, orientation: .vertical, distanceFromLeading: distanceFromLeading)
    }
}



// MARK: - Position
//
//
//
// MARK: Line Charts
extension CTLineBarChartDataProtocol where Self: CTLineChartDataProtocol & PointOfInterestProtocol {
    
    public func poiValueLabelPositionAxis(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint {
        let leading: CGFloat = -((self.viewData.yAxisLabelWidth.max() ?? 0) / 2) - 4 // -4 for padding at the root view.
        let trailing: CGFloat = frame.width + ((self.viewData.yAxisLabelWidth.max() ?? 0) / 2) + 4 // +4 for padding at the root view.
        let value: CGFloat = CGFloat(markerValue - minValue)
        let sizing: CGFloat = -(frame.height / CGFloat(range))
        return CGPoint(x: self.chartStyle.yAxisLabelPosition == .leading ? leading : trailing,
                       y: value * sizing + frame.height)
    }
    
    public func poiValueLabelPositionCenter(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint {
        CGPoint(x: frame.width / 2,
                y: CGFloat(markerValue - minValue) * -(frame.height / CGFloat(range)) + frame.height)
    }
    
    public func poiValueLabelRelativePosition(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint {
        let value: CGFloat = CGFloat(markerValue - minValue)
        let sizing: CGFloat = -(frame.height / CGFloat(range))
        return CGPoint(x: frame.width / 2,
                       y: value * sizing + frame.height)
    }
}

// MARK: Vertical Bar Charts
extension CTLineBarChartDataProtocol where Self: CTBarChartDataProtocol & PointOfInterestProtocol {
    
    public func poiValueLabelPositionAxis(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint {
        let leading: CGFloat = -((self.viewData.yAxisLabelWidth.max() ?? 0) / 2) - 4 // -4 for padding at the root view.
        let trailing: CGFloat = frame.width + ((self.viewData.yAxisLabelWidth.max() ?? 0) / 2) + 4 // +4 for padding at the root view.
        let value: CGFloat = divideByZeroProtection(CGFloat.self, (markerValue - minValue), range)
        return CGPoint(x: self.chartStyle.yAxisLabelPosition == .leading ? leading : trailing,
                       y: frame.height - value * frame.height)
    }
    
    public func poiValueLabelPositionCenter(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint {
        CGPoint(x: frame.width / 2,
                y: frame.height - divideByZeroProtection(CGFloat.self, (markerValue - minValue), range) * frame.height)
    }
    
    public func poiValueLabelRelativePosition(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint {
        let value: CGFloat = CGFloat(markerValue - minValue)
        let sizing: CGFloat = -(frame.height / CGFloat(range))
        return CGPoint(x: frame.width / 2,
                       y: value * sizing + frame.height)
    }
}

// MARK: Horizontal Bar Charts
extension CTLineBarChartDataProtocol where Self: CTBarChartDataProtocol & PointOfInterestProtocol,
                                           Self: isHorizontal {
    
    public func poiValueLabelPositionAxis(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint {
        let bottom: CGFloat = frame.height + ((self.viewData.xAxisLabelHeights.max() ?? 0) / 2) + 4  // +4 for padding at the root view
        let top: CGFloat = -((self.viewData.xAxisLabelHeights.max() ?? 0) / 2) - 4  // -4 for padding at the root view
        let value: CGFloat = divideByZeroProtection(CGFloat.self, (markerValue - minValue), range)
        return CGPoint(x: value * frame.width,
                y: self.chartStyle.xAxisLabelPosition == .bottom ? bottom : top)
    }
    
    public func poiValueLabelPositionCenter(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint {
        CGPoint(x: divideByZeroProtection(CGFloat.self, (markerValue - minValue), range) * frame.width,
                y: frame.height / 2)
    }
    
    public func poiValueLabelRelativePosition(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint {
        let value: CGFloat = divideByZeroProtection(CGFloat.self, (markerValue - minValue), range)
        return CGPoint(x: value * frame.width,
                y: frame.height / 2)
    }
}






// MARK: - Abscissa
extension CTLineBarChartDataProtocol where Self: PointOfInterestProtocol {
    
    public func poiAbscissaMarker(markerValue: Int, dataPointCount: Int) -> some Shape {
        VerticalAbscissaMarker(chartData: self, markerValue: markerValue, dataPointCount: dataPointCount)
    }
    
    public func poiAbscissaLabelAxis(
     marker: String,
     labelFont: Font,
     labelColour: Color,
     labelBackground: Color,
     labelBorderColor: Color,
     customLabelShape: CustomLabelShape?,
     padding: CGFloat?
    ) -> some View {
        Text(LocalizedStringKey(marker))
            .font(labelFont)
            .foregroundColor(labelColour)
            .padding(padding ?? 4)
            .padding(.vertical, 4)
            .background(labelBackground)
            .clipShape(customLabelShape ?? CustomLabelShape(RoundedRectangle(cornerRadius: 5, style: .continuous)))
            .overlay((customLabelShape ?? CustomLabelShape(RoundedRectangle(cornerRadius: 5, style: .continuous)))
                        .stroke(labelBorderColor)
            )
    }
    
    public func poiAbscissaLabelCenter(
     marker: String,
     labelFont: Font,
     labelColour: Color,
     labelBackground: Color,
     labelBorderColor: Color,
     strokeStyle: StrokeStyle,
     customLabelShape: CustomLabelShape?,
     padding: CGFloat?
    ) -> some View {
        Text(LocalizedStringKey(marker))
            .font(labelFont)
            .foregroundColor(labelColour)
            .padding(.all, padding)
            .background(labelBackground)
            .clipShape(customLabelShape ?? CustomLabelShape(DiamondShape()))
            .overlay((customLabelShape ?? CustomLabelShape(DiamondShape()))
                        .stroke(labelBorderColor, style: strokeStyle)
            )
    }
    
    public func poiAbscissaLabelPosition(
     location: CGFloat,
     marker: String,
     labelFont: Font,
     labelColour: Color,
     labelBackground: Color,
     labelBorderColor: Color,
     strokeStyle: StrokeStyle,
     customLabelShape: CustomLabelShape?,
     padding: CGFloat?
    ) -> some View {
        var distanceFromLeading: CGFloat = 0.5
        if 0...1 ~= location {
            if self.chartStyle.xAxisLabelPosition == .bottom {
                distanceFromLeading = 1 - location
            } else {
                distanceFromLeading = location
            }
        }
        
        return PositionedPOILabel(content: {
            Text(LocalizedStringKey(marker))
                .font(labelFont)
                .foregroundColor(labelColour)
                .padding(.all, padding)
                .background(labelBackground)
                .clipShape(customLabelShape ?? CustomLabelShape(DiamondShape()))
                .overlay((customLabelShape ?? CustomLabelShape(DiamondShape()))
                            .stroke(labelBorderColor, style: strokeStyle)
                )
        }, orientation: .vertical, distanceFromLeading: distanceFromLeading)
    }
}

extension CTLineBarChartDataProtocol where Self: PointOfInterestProtocol & isHorizontal {
    
    public func poiAbscissaMarker(markerValue: Int, dataPointCount: Int) -> some Shape {
        HorizontalAbscissaMarker(chartData: self, markerValue: markerValue, dataPointCount: dataPointCount)
    }
    
    public func poiAbscissaLabelAxis(
     marker: String,
     labelFont: Font,
     labelColour: Color,
     labelBackground: Color,
     labelBorderColor: Color,
     customLabelShape: CustomLabelShape?,
     padding: CGFloat?
    ) -> some View {
        Text(LocalizedStringKey(marker))
            .font(labelFont)
            .foregroundColor(labelColour)
            .padding(padding ?? 4)
            .background(labelBackground)
            .ifElse(self.chartStyle.yAxisLabelPosition == .leading, if: {
                $0
                    .clipShape(customLabelShape ?? CustomLabelShape(LeadingLabelShape()))
                    .overlay((customLabelShape ?? CustomLabelShape(LeadingLabelShape()))
                                .stroke(labelBorderColor)
                    )
            }, else: {
                $0
                    .clipShape(customLabelShape ?? CustomLabelShape(TrailingLabelShape()))
                    .overlay((customLabelShape ?? CustomLabelShape(TrailingLabelShape()))
                                .stroke(labelBorderColor)
                    )
            })
    }
    
    public func poiAbscissaLabelPosition(
     location: CGFloat,
     marker: String,
     labelFont: Font,
     labelColour: Color,
     labelBackground: Color,
     labelBorderColor: Color,
     strokeStyle: StrokeStyle,
     customLabelShape: CustomLabelShape?,
     padding: CGFloat?
    ) -> some View {
        var distanceFromLeading: CGFloat = 0.5
        if 0...1 ~= location {
            if self.chartStyle.yAxisLabelPosition == .trailing {
                distanceFromLeading = 1 - location
            } else {
                distanceFromLeading = location
            }
        }
        
        return PositionedPOILabel(content: {
            Text(LocalizedStringKey(marker))
                .font(labelFont)
                .foregroundColor(labelColour)
                .padding(.all, padding)
                .background(labelBackground)
                .clipShape(customLabelShape ?? CustomLabelShape(DiamondShape()))
                .overlay((customLabelShape ?? CustomLabelShape(DiamondShape()))
                            .stroke(labelBorderColor, style: strokeStyle)
                )
        }, orientation: .horizontal, distanceFromLeading: distanceFromLeading)
    }
}



// MARK: - Position
//
//
//
// MARK: Line Charts
extension CTLineBarChartDataProtocol where Self: CTLineChartDataProtocol & PointOfInterestProtocol {
    
    public func poiAbscissaValueLabelPositionAxis(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        let bottom: CGFloat = frame.height + ((self.viewData.xAxisLabelHeights.max() ?? 0) / 2) + 10  // +4 for padding at the root view
        let top: CGFloat = -((self.viewData.xAxisLabelHeights.max() ?? 0) / 2) - 10  // -4 for padding at the root view
        return CGPoint(x: (frame.width / CGFloat(count-1)) * CGFloat(markerValue),
                       y: self.chartStyle.xAxisLabelPosition == .bottom ? bottom : top)
    }
    
    public func poiAbscissaValueLabelPositionCenter(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        CGPoint(x: (frame.width / CGFloat(count-1)) * CGFloat(markerValue),
                y: frame.height / 2)
    }
    
    public func poiAbscissaValueLabelRelativePosition(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        CGPoint(x: (frame.width / CGFloat(count-1)) * CGFloat(markerValue),
                y: frame.height / 2)
    }
}

// MARK: Vertical Bar Charts
extension CTLineBarChartDataProtocol where Self: CTBarChartDataProtocol & PointOfInterestProtocol {
    
    public func poiAbscissaValueLabelPositionAxis(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        let bottom: CGFloat = frame.height + ((self.viewData.xAxisLabelHeights.max() ?? 0) / 2) + 10  // +4 for padding at the root view
        let top: CGFloat = -((self.viewData.xAxisLabelHeights.max() ?? 0) / 2) - 10  // -4 for padding at the root view
        return CGPoint(x: (frame.width / CGFloat(count-1)) * CGFloat(markerValue),
                       y: self.chartStyle.xAxisLabelPosition == .bottom ? bottom : top)
    }
    
    public func poiAbscissaValueLabelPositionCenter(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        CGPoint(x: (frame.width / CGFloat(count)) * CGFloat(markerValue) + ((frame.width / CGFloat(count)) / 2),
                y: frame.height / 2)
    }
    
    public func poiAbscissaValueLabelRelativePosition(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        CGPoint(x: (frame.width / CGFloat(count)) * CGFloat(markerValue) + ((frame.width / CGFloat(count)) / 2),
                y: frame.height / 2)
    }
}

// MARK: Horizontal Bar Charts
extension CTLineBarChartDataProtocol where Self: CTBarChartDataProtocol & PointOfInterestProtocol,
                                           Self: isHorizontal {
    
    public func poiAbscissaValueLabelPositionAxis(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        let leading: CGFloat = -((self.viewData.xAxisLabelHeights.max() ?? 0) / 2) - 8  // -4 for padding at the root view
        let trailing: CGFloat = frame.width + ((self.viewData.xAxislabelWidths.max() ?? 0) / 2) + 8  // +4 for padding at the root view
        return CGPoint(x: self.chartStyle.yAxisLabelPosition == .leading ? leading : trailing,
                       y: ((frame.height / CGFloat(count)) * CGFloat(markerValue) + ((frame.height / CGFloat(count)) / 2)))
    }
    
    public func poiAbscissaValueLabelPositionCenter(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        CGPoint(x: frame.width / 2,
                y: ((frame.height / CGFloat(count)) * CGFloat(markerValue) + ((frame.height / CGFloat(count)) / 2)))
    }
    
    public func poiAbscissaValueLabelRelativePosition(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        CGPoint(x: frame.width / 2,
                y: ((frame.height / CGFloat(count)) * CGFloat(markerValue) + ((frame.height / CGFloat(count)) / 2)))
    }
}
