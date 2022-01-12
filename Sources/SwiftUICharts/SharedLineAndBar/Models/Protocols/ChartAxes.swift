//
//  ChartAxes.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import SwiftUI

public typealias ChartAxes = AxisX & AxisY

// MARK: - AxisY
public protocol AxisY: AnyObject {
    /// Array of strings for the labels on the Y Axis instead of the labels generated from data point values.
    @available(*, deprecated, message: "Moved to view please use \".yAxisLabels\" instead")
    var yAxisLabels: [String]? { get set }
    
    /// Displays a view for the labels on the Y Axis.
    @available(*, deprecated, message: "Moved to view please use \".yAxisLabels\" instead")
    func getYAxisLabels()
    
    /// Maybe not needed ???
    func yAxisSectionSizing(count: Int, size: CGFloat) -> CGFloat
    
    /// Maybe not needed ???
    func yAxisLabelOffSet(index: Int, size: CGFloat, count: Int) -> CGFloat
}



import ChartMath

extension AxisY {
    @available(*, deprecated, message: "Moved to view please use \".yAxisLabels\" instead")
    public func getYAxisLabels() {}
    
    public func yAxisSectionSizing(count: Int, size: CGFloat) -> CGFloat {
        return divide(size, count)
    }
    
    public func yAxisLabelOffSet(index: Int, size: CGFloat, count: Int) -> CGFloat {
       return CGFloat(index) * divide(size, count - 1)
    }
}

// MARK: - AxisX
public protocol AxisX: AnyObject {
    /// Array of strings for the labels on the X Axis instead of the labels in the data points.
    @available(*, deprecated, message: "Move to view, please use \".xAxisLabels\"")
    var xAxisLabels: [String]? { get set }
    
    func xAxisSectionSizing(count: Int, size: CGFloat) -> CGFloat
    
    func xAxisLabelOffSet(index: Int, size: CGFloat, count: Int) -> CGFloat
}
