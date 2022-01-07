//
//  PointOfInterestProtocol.swift
//  
//
//  Created by Will Dale on 11/06/2021.
//

import SwiftUI
import ChartMath

public protocol PointOfInterestProtocol {
    
    /**
     A type representing a Shape for displaying a line
     as a POI.
     */
    associatedtype YAxisMarkerShape: Shape
    
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
    func yAxisPOIMarker(value: Double) -> YAxisMarkerShape
    
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
    func yAxisPOIMarkerPosition(value: Double, position: PoiPositionable, chartSize: CGSize) -> CGPoint
    
    // MARK: Abscissa
    /**
     A type representing a Shape for displaying a line
     as a POI.
     */
    associatedtype XAxisMarkerShape: Shape
    
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
    func xAxisPOIMarker(value: Int, total: Int) -> XAxisMarkerShape
    
    func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint
}


// MARK: - Extensions
extension PointOfInterestProtocol where Self: CTChartData & VerticalChart {
    public func yAxisPOIMarker(value: Double) -> some Shape {
        YAxisHorizontalMarker(chartData: self, value: value)
    }
    
    public func xAxisPOIMarker(value: Int, total: Int) -> some Shape {
        XAxisVerticalMarker(chartData: self, value: value, total: total)
    }
}

extension PointOfInterestProtocol where Self: CTChartData & HorizontalChart {
    public func yAxisPOIMarker(value: Double) -> some Shape {
        YAxisVerticalMarker(chartData: self, value: value)
    }
    
    public func xAxisPOIMarker(value: Int, total: Int) -> some Shape {
        XAxisHorizontalMarker(chartData: self, value: value, total: total)
    }
}

// MARK: - Position
//
//
//
// MARK: Line Charts
extension PointOfInterestProtocol where Self: CTChartData & ViewDataProtocol & DataHelper,
                                        Self: VerticalChart,
                                        Self: LineChartType {
    public func yAxisPOIMarkerPosition(value: Double, position: PoiPositionable, chartSize: CGSize) -> CGPoint {
        let padding: CGFloat = 4.0
        switch position as? PoiStyle.HorizontalPosition {
        case .leading:
            return CGPoint(x: -((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) - padding,
                           y: plotPointY(value, minValue, range, chartSize.height))
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: plotPointY(value, minValue, range, chartSize.height))
        case .trailing:
            return CGPoint(x: chartSize.width + ((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) + padding,
                           y: plotPointY(value, minValue, range, chartSize.height))
        default:
            return .zero
        }
    }
    
    public func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint {
        let padding: CGFloat = 10
        switch position as? PoiStyle.VerticalPosition {
        case .top:
            return CGPoint(x: lineXAxisPOIMarkerX(value, count, chartSize.width),
                           y: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding)
        case .center:
            return CGPoint(x: lineXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: lineXAxisPOIMarkerX(value, count, chartSize.width),
                           y:  chartSize.height + ((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) + padding)
        default:
            return .zero
        }
    }
}

// MARK: Vertical Bar Charts
extension PointOfInterestProtocol where Self: CTChartData & PointOfInterestProtocol & ViewDataProtocol & DataHelper,
                                        Self: VerticalChart,
                                        Self: BarChartType {
    public func yAxisPOIMarkerPosition(value: Double, position: PoiPositionable, chartSize: CGSize) -> CGPoint {
        let padding: CGFloat = 4.0
        switch position as? PoiStyle.HorizontalPosition {
        case .leading:
            return CGPoint(x: -((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) - padding,
                           y: barYAxisPOIMarkerX(value, minValue, range, chartSize.height))
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: barYAxisPOIMarkerX(value, minValue, range, chartSize.height))
        case .trailing:
            return CGPoint(x: chartSize.width + ((yAxisViewData.yAxisLabelWidth.max() ?? 0) / 2) + padding,
                           y: barYAxisPOIMarkerX(value, minValue, range, chartSize.height))
        default:
            return .zero
        }
    }
    
    public func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint {
        let padding: CGFloat = 10.0
        switch position as? PoiStyle.VerticalPosition {
        case .top:
            return CGPoint(x: barXAxisPOIMarkerX(value, count, chartSize.width),
                           y: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding)
        case .center:
            // (chartSize.width / CGFloat(count)) * CGFloat(value) + ((chartSize.width / CGFloat(count)) / 2)
            return CGPoint(x: barXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: barXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height + ((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) + padding)
        default:
            return .zero
        }
    }
}

// MARK: Horizontal Bar Charts
extension PointOfInterestProtocol where Self: CTChartData & PointOfInterestProtocol & XAxisViewDataProtocol & DataHelper,
                                        Self: HorizontalChart,
                                        Self: BarChartType {
    public func yAxisPOIMarkerPosition(value: Double, position: PoiPositionable, chartSize: CGSize) -> CGPoint {
        let padding: CGFloat = 4.0
        switch position as? PoiStyle.VerticalPosition {
        case .top:
            return CGPoint(x: horizontalBarYPosition(value, minValue, range, chartSize.width),
                           y: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding)
        case .center:
            return CGPoint(x: horizontalBarYPosition(value, minValue, range, chartSize.width),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: horizontalBarYPosition(value, minValue, range, chartSize.width),
                           y: chartSize.height + ((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) + padding)
        default:
            return .zero
        }
    }
    
    public func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint {
        let padding: CGFloat = 8.0
        switch position as? PoiStyle.HorizontalPosition {
        case .leading:
            return CGPoint(x: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding,
                           y: horizontalBarXAxisPOIMarkerY(value, count, chartSize.height))
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: horizontalBarXAxisPOIMarkerY(value, count, chartSize.height))
        case .trailing:
            return CGPoint(x: chartSize.width + ((xAxisViewData.xAxislabelWidths.max() ?? 0) / 2) + padding,
                           y: horizontalBarXAxisPOIMarkerY(value, count, chartSize.height))
        default:
            return .zero
        }
    }
}
