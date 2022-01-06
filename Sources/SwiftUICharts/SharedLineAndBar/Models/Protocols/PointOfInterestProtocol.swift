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
    func yAxisPOIMarker(value: Double) -> MarkerShape
    
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
    func xAxisPOIMarker(value: Int, total: Int) -> AbscissaMarkerShape
    
    func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint
}


// MARK: - Extensions
extension PointOfInterestProtocol where Self: CTChartData & VerticalChart {
    public func yAxisPOIMarker(value: Double) -> some Shape {
        HorizontalMarker(chartData: self, value: value)
    }
    
    // ---
    public func xAxisPOIMarker(value: Int, total: Int) -> some Shape {
        VerticalAbscissaMarker(chartData: self, value: value, total: total)
    }
}
extension PointOfInterestProtocol where Self: CTChartData & HorizontalChart {
    public func yAxisPOIMarker(value: Double) -> some Shape {
        VerticalMarker(chartData: self, value: value)
    }
    
    // ---
    public func xAxisPOIMarker(value: Int, total: Int) -> some Shape {
        HorizontalAbscissaMarker(chartData: self, value: value, total: total)
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
        let ctValue = CGFloat(value - minValue)
        let sizing: CGFloat = -(chartSize.height / CGFloat(range))
        let padding: CGFloat = 4.0
        switch position as? PoiStyle.HorizontalPosition {
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
    public func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint {
        let padding: CGFloat = 10
        switch position as? PoiStyle.VerticalPosition {
        case .top:
            return CGPoint(x: (chartSize.width / CGFloat(count-1)) * CGFloat(value),
                           y: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding)
        case .center:
            return CGPoint(x: (chartSize.width / CGFloat(count-1)) * CGFloat(value),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: (chartSize.width / CGFloat(count-1)) * CGFloat(value),
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
        let value: CGFloat = divideByZeroProtection(CGFloat.self, (value - minValue), range)
        let padding: CGFloat = 4.0
        switch position as? PoiStyle.HorizontalPosition {
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
    public func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint {
        let padding: CGFloat = 10.0
        switch position as? PoiStyle.VerticalPosition {
        case .top:
            return CGPoint(x: (chartSize.width / CGFloat(count-1)) * CGFloat(value),
                           y: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding)
        case .center:
            return CGPoint(x: (chartSize.width / CGFloat(count)) * CGFloat(value) + ((chartSize.width / CGFloat(count)) / 2),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: (chartSize.width / CGFloat(count-1)) * CGFloat(value),
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
        let ctValue: CGFloat = divideByZeroProtection(CGFloat.self, (value - minValue), range)
        let padding: CGFloat = 4.0
        switch position as? PoiStyle.VerticalPosition {
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
    public func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint {
        let padding: CGFloat = 8.0
        switch position as? PoiStyle.HorizontalPosition {
        case .leading:
            return CGPoint(x: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding,
                           y: ((chartSize.height / CGFloat(count)) * CGFloat(value) + ((chartSize.height / CGFloat(count)) / 2)))
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: ((chartSize.height / CGFloat(count)) * CGFloat(value) + ((chartSize.height / CGFloat(count)) / 2)))
        case .trailing:
            return CGPoint(x: chartSize.width + ((xAxisViewData.xAxislabelWidths.max() ?? 0) / 2) + padding,
                           y: ((chartSize.height / CGFloat(count)) * CGFloat(value) + ((chartSize.height / CGFloat(count)) / 2)))
        default:
            return .zero
        }
    }
}
