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
    func poiMarker(value: Double) -> MarkerShape
    
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
    func poiLabelAxis(markerValue: Double, specifier: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color) -> LabelAxis
    
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
    func poiLabelCenter(markerValue: Double, specifier: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color, strokeStyle: StrokeStyle) -> LabelCenter
    
    
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
    func poiValueLabelPosition(value: Double, position: YAxisPositionable, chartSize: CGSize) -> CGPoint
    
    
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
    func poiAbscissaLabelAxis(marker: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color) -> AbscissaLabelAxis
    
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
    func poiAbscissaLabelCenter(marker: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color, strokeStyle: StrokeStyle) -> AbscissaLabelCenter
    
    
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
}


// MARK: - Extensions
extension PointOfInterestProtocol where Self: CTChartData {
    public func poiMarker(value: Double) -> some Shape {
        HorizontalMarker(chartData: self, value: value)
    }
    
    public func poiLabelAxis(markerValue: Double, specifier: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color) -> some View {
        EmptyView()
//        Text(LocalizedStringKey("\(markerValue, specifier: specifier)"))
//            .font(labelFont)
//            .foregroundColor(labelColour)
//            .padding(4)
//            .background(labelBackground)
//            .ifElse(self.chartStyle.yAxisLabelPosition == .leading, if: {
//                $0
//                    .clipShape(LeadingLabelShape())
//                    .overlay(LeadingLabelShape()
//                                .stroke(lineColour)
//                    )
//            }, else: {
//                $0
//                    .clipShape(TrailingLabelShape())
//                    .overlay(TrailingLabelShape()
//                                .stroke(lineColour)
//                    )
//            })
    }
    public func poiLabelCenter(markerValue: Double, specifier: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color, strokeStyle: StrokeStyle) -> some View {
        EmptyView()
//        Text(LocalizedStringKey("\(markerValue, specifier: specifier)"))
//            .font(labelFont)
//            .foregroundColor(labelColour)
//            .padding()
//            .background(labelBackground)
//            .clipShape(DiamondShape())
//            .overlay(DiamondShape()
//                        .stroke(lineColour, style: strokeStyle)
//            )
    }
    // ---
    public func poiAbscissaMarker(markerValue: Int, dataPointCount: Int) -> some Shape {
        VerticalAbscissaMarker(chartData: self, markerValue: markerValue, dataPointCount: dataPointCount)
    }
    public func poiAbscissaLabelAxis(marker: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color) -> some View {
        Text(LocalizedStringKey(marker))
            .font(labelFont)
            .foregroundColor(labelColour)
            .padding(4)
            .padding(.vertical, 4)
            .background(labelBackground)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .stroke(lineColour)
            )
    }
    public func poiAbscissaLabelCenter(marker: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color, strokeStyle: StrokeStyle) -> some View {
        Text(LocalizedStringKey(marker))
            .font(labelFont)
            .foregroundColor(labelColour)
            .padding()
            .background(labelBackground)
            .clipShape(DiamondShape())
            .overlay(DiamondShape()
                        .stroke(lineColour, style: strokeStyle)
            )
    }
}
extension PointOfInterestProtocol where Self: CTChartData & HorizontalChart {
    public func poiMarker(value: Double) -> some Shape {
        VerticalMarker(chartData: self, value: value)
    }
    
    public func poiLabelAxis(markerValue: Double, specifier: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color) -> some View {
        EmptyView()
//        Text(LocalizedStringKey("\(markerValue, specifier: specifier)"))
//            .font(labelFont)
//            .foregroundColor(labelColour)
//            .padding(4)
//            .background(labelBackground)
//            .ifElse(self.chartStyle.xAxisLabelPosition == .bottom, if: {
//                $0
//                    .clipShape(BottomLabelShape())
//                    .overlay(BottomLabelShape()
//                                .stroke(lineColour)
//                    )
//            }, else: {
//                $0
//                    .clipShape(TopLabelShape())
//                    .overlay(TopLabelShape()
//                                .stroke(lineColour)
//                    )
//            })
    }
    // ---
    public func poiAbscissaMarker(markerValue: Int, dataPointCount: Int) -> some Shape {
        HorizontalAbscissaMarker(chartData: self, markerValue: markerValue, dataPointCount: dataPointCount)
    }
    public func poiAbscissaLabelAxis(marker: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color) -> some View {
        EmptyView()
//        Text(LocalizedStringKey(marker))
//            .font(labelFont)
//            .foregroundColor(labelColour)
//            .padding(4)
//            .background(labelBackground)
//            .ifElse(self.chartStyle.yAxisLabelPosition == .leading, if: {
//                $0
//                    .clipShape(LeadingLabelShape())
//                    .overlay(LeadingLabelShape()
//                                .stroke(lineColour)
//                    )
//            }, else: {
//                $0
//                    .clipShape(TrailingLabelShape())
//                    .overlay(TrailingLabelShape()
//                                .stroke(lineColour)
//                    )
//            })
    }
}

//let leading: CGFloat = -((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) - 4 // -4 for padding at the root view.
//let trailing: CGFloat = frame.width + ((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) + 4 // +4 for padding at the root view.
//let value: CGFloat = CGFloat(markerValue - minValue)
//let sizing: CGFloat = -(frame.height / CGFloat(range))
//return CGPoint(x: chartStyle.yAxisLabelPosition == .leading ? leading : trailing,
//               y: value * sizing + frame.height)

// MARK: - Position
//
//
//
// MARK: Line Charts
extension PointOfInterestProtocol where Self: CTChartData & ViewDataProtocol & DataHelper,
                                        Self: VerticalChart,
                                        Self: LineChartType {
    public func poiValueLabelPosition(value: Double, position: YAxisPositionable, chartSize: CGSize) -> CGPoint {
        let ctValue = CGFloat(value - minValue)
        let sizing: CGFloat = -(chartSize.height / CGFloat(range))
        let padding: CGFloat = 4.0
        switch position as? YAxisPOIStyle.HorizontalPosition {
        case .leading:
            return CGPoint(x: -((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) - padding,
                           y: ctValue * sizing + chartSize.height)
        case .trailing:
            return CGPoint(x: chartSize.width + ((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) + padding,
                           y: ctValue * sizing + chartSize.height)
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: ctValue * sizing + chartSize.height)
        default:
            return .zero
        }
    }

    // ---
    public func poiAbscissaValueLabelPositionAxis(frame: CGRect, markerValue: Int, count: Int) -> CGPoint { .zero
//        let bottom: CGFloat = frame.height + ((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) + 10  // +10 for padding at the root view
//        let top: CGFloat = -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - 10  // -10 for padding at the root view
//        return CGPoint(x: (frame.width / CGFloat(count-1)) * CGFloat(markerValue),
//                       y: chartStyle.xAxisLabelPosition == .bottom ? bottom : top)
    }
    public func poiAbscissaValueLabelPositionCenter(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        CGPoint(x: (frame.width / CGFloat(count-1)) * CGFloat(markerValue),
                y: frame.height / 2)
    }
}

// MARK: Vertical Bar Charts
extension PointOfInterestProtocol where Self: CTChartData & PointOfInterestProtocol & ViewDataProtocol & DataHelper,
                                        Self: VerticalChart,
                                        Self: BarChartType {
    public func poiValueLabelPosition(value: Double, position: YAxisPositionable, chartSize: CGSize) -> CGPoint {
        let value: CGFloat = divideByZeroProtection(CGFloat.self, (value - minValue), range)
        let padding: CGFloat = 4.0
        switch position as? YAxisPOIStyle.HorizontalPosition {
        case .leading:
            return CGPoint(x: -((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) - padding,
                           y: chartSize.height - value * chartSize.height)
        case .trailing:
            return CGPoint(x: chartSize.width + ((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) + padding,
                           y: chartSize.height - value * chartSize.height)
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: chartSize.height - value * chartSize.height)
        default:
            return .zero
        }
    }
    
    // ---
    public func poiAbscissaValueLabelPositionAxis(frame: CGRect, markerValue: Int, count: Int) -> CGPoint { .zero
//        let bottom: CGFloat = frame.height + ((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) + 10  // +4 for padding at the root view
//        let top: CGFloat = -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - 10  // -4 for padding at the root view
//        return CGPoint(x: (frame.width / CGFloat(count-1)) * CGFloat(markerValue),
//                       y: chartStyle.xAxisLabelPosition == .bottom ? bottom : top)
    }
    public func poiAbscissaValueLabelPositionCenter(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        CGPoint(x: (frame.width / CGFloat(count)) * CGFloat(markerValue) + ((frame.width / CGFloat(count)) / 2),
                y: frame.height / 2)
    }
}

// MARK: Horizontal Bar Charts
extension PointOfInterestProtocol where Self: CTChartData & PointOfInterestProtocol & XAxisViewDataProtocol & DataHelper,
                                        Self: HorizontalChart,
                                        Self: BarChartType {
    public func poiValueLabelPosition(value: Double, position: YAxisPositionable, chartSize: CGSize) -> CGPoint {
        let ctValue: CGFloat = divideByZeroProtection(CGFloat.self, (value - minValue), range)
        let padding: CGFloat = 4.0
        switch position as? YAxisPOIStyle.VerticalPosition {
        case .top:
            return CGPoint(x: ctValue * chartSize.width,
                           y: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding)
        case .center:
            return CGPoint(x: ctValue * chartSize.width,
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: ctValue * chartSize.width,
                           y: chartSize.height + ((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) + padding)
        default:
            return .zero
        }
    }
    // ---
    public func poiAbscissaValueLabelPositionAxis(frame: CGRect, markerValue: Int, count: Int) -> CGPoint { .zero
//        let leading: CGFloat = -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - 8  // -4 for padding at the root view
//        let trailing: CGFloat = frame.width + ((xAxisViewData.xAxislabelWidths.max() ?? 0) / 2) + 8  // +4 for padding at the root view
//        return CGPoint(x: chartStyle.yAxisLabelPosition == .leading ? leading : trailing,
//                       y: ((frame.height / CGFloat(count)) * CGFloat(markerValue) + ((frame.height / CGFloat(count)) / 2)))
    }
    public func poiAbscissaValueLabelPositionCenter(frame: CGRect, markerValue: Int, count: Int) -> CGPoint {
        CGPoint(x: frame.width / 2,
                y: ((frame.height / CGFloat(count)) * CGFloat(markerValue) + ((frame.height / CGFloat(count)) / 2)))
    }
}
