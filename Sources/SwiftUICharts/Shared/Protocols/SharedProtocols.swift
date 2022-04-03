//
//  SharedProtocols.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

internal typealias CTChartType = (chartType: ChartType, dataSetType: DataSetType)

public typealias ChartConformance = DataHelper & Publishable & Touchable
public typealias StandardChartConformance =  ChartConformance & VerticalChart
public typealias HorizontalChartConformance = ChartConformance & HorizontalChart

// MARK: Chart Data
/**
 Main protocol for passing data around library.
 
 All Chart Data models ultimately conform to this.
 */
public protocol CTChartData: ObservableObject, Identifiable {
    
    /// A type representing a  data set. -- `CTDataSetProtocol`
    associatedtype SetType: CTDataSetProtocol

    /// A type representing a data point. -- `CTChartDataPoint`
    associatedtype DataPoint: CTDataPointBaseProtocol
    
    var id: ID { get }
    
    /// This is a read out by voice over to make it clear what is being described.
    ///
    /// The value could be what the chart title is or screen title.
    var accessibilityTitle: LocalizedStringKey { get set }
    
    /// Data model containing datapoints and styling information.
    var dataSets: SetType { get set }
    
    /// Array of `LegendData` to populate the charts legend.
    /// This is populated automatically from within each view.
    var legends: [LegendData] { get set }
    
    /// Customisable `Text` to display when where is not enough data to draw the chart.
    var noDataText: Text { get set }
    
    /// A global control to disable animations
    var shouldAnimate: Bool { get set }
    
    var chartName: ChartName { get }
    
    
    /// Data model containing the charts Title, Subtitle and the Title for Legend.
    ///
    /// Not hooked up to anything
    @available(*, deprecated, message: "Please use \"\" instead.")
    var metadata: ChartMetadata { get set }
    
    /// Data model pass data from `TouchOverlay` ViewModifier to
    /// `HeaderBox` or `InfoBox` for display.
    ///
    /// Not hooked up to anything
    @available(*, deprecated, message: "Split in to axis data")
    var infoView: InfoViewData<DataPoint> { get set }
    
    /// Data model conatining the style data for the chart.
    ///
    /// Now just a stub
    @available(*, deprecated, message: "Please use \"\" instead.")
    var chartStyle: DeprecatedCTStyle { get }
}

public struct DataSetInfo {
    public var chart: ChartName
    public var minValue: Double
    public var range: Double
    
    public init(
        chart: ChartName,
        minValue: Double,
        range: Double
    ) {
        self.minValue = minValue
        self.range = range
        self.chart = chart
    }
}

extension CTChartData where Self: DataHelper {
    public var dataSetInfo: DataSetInfo {
        DataSetInfo(chart: chartName, minValue: minValue, range: range)
    }
}

extension CTChartData {
    public var xAxisData: XAxisLabelStyle.XLabelData {
        XAxisLabelStyle.XLabelData(chart: chartName, spacing: nil)
    }
}
extension CTChartData where Self: GroupedBarChartData {
    public var xAxisData: XAxisLabelStyle.XLabelData {
        XAxisLabelStyle.XLabelData(chart: chartName, spacing: groupSpacing)
    }
}

extension CTChartData where Self: BarChartType {
    internal func markerSubView(
        markerData: MarkerData,
        chartSize: CGRect,
        touchLocation: CGPoint
    ) -> some View {
        ZStack {
            ForEach(markerData.barMarkerData, id: \.self) { marker in
                MarkerView.bar(barMarker: marker.markerType, markerData: marker)
            }
            
            ForEach(markerData.lineMarkerData, id: \.self) { marker in
                MarkerView.line(lineMarker: marker.markerType,
                                markerData: marker,
                                chartSize: chartSize,
                                touchLocation: touchLocation,
                                dataPoints: marker.dataPoints,
                                lineType: marker.lineType,
                                lineSpacing: marker.lineSpacing,
                                minValue: marker.minValue,
                                range: marker.range)
            }
        }
    }
}

extension CTChartData where Self: LineChartType {
    internal func markerSubView(
        markerData: MarkerData,
        chartSize: CGRect,
        touchLocation: CGPoint
    ) -> some View {
        ForEach(markerData.lineMarkerData, id: \.self) { marker in
            MarkerView.line(lineMarker: marker.markerType,
                            markerData: marker,
                            chartSize: chartSize,
                            touchLocation: touchLocation,
                            dataPoints: marker.dataPoints,
                            lineType: marker.lineType,
                            lineSpacing: marker.lineSpacing,
                            minValue: marker.minValue,
                            range: marker.range)
        }
    }
}

// MARK: - Data Sets
/**
 Main protocol to set conformace for types of Data Sets.
 */
public protocol CTDataSetProtocol: Hashable, Identifiable {
    var id: ID { get }
    
    var dataWidth: Int { get }
    
    var dataLabels: [String] { get }
}

/**
 Protocol for data sets that only require a single set of data .
 */
public protocol CTSingleDataSetProtocol: CTDataSetProtocol {
    
    /// A type representing a data point. -- `CTChartDataPoint`
    associatedtype DataPoint: CTDataPointBaseProtocol
    
    /**
     Array of data points.
     */
    var dataPoints: [DataPoint] { get set }
    
}

extension CTSingleDataSetProtocol {
    public var dataWidth: Int {
        dataPoints.count
    }
}
extension CTSingleDataSetProtocol where Self.DataPoint: CTLineBarDataPointProtocol {
    public var dataLabels: [String] {
        dataPoints.compactMap(\.xAxisLabel)
    }
}

/**
 Protocol for data sets that require a multiple sets of data .
 */
public protocol CTMultiDataSetProtocol: CTDataSetProtocol {
    
    /// A type representing a single data set -- `SingleDataSet`
    associatedtype DataSet: CTSingleDataSetProtocol
    
    /**
     Array of single data sets.
     */
    var dataSets: [DataSet] { get set }
}

extension CTMultiDataSetProtocol {
    public var dataWidth: Int {
        guard let ordered = dataSets.max(by: { $0.dataPoints.count < $1.dataPoints.count }) else { return 0 }
        return ordered.dataPoints.count
    }
}

extension CTMultiDataSetProtocol where Self.DataSet.DataPoint: CTLineBarDataPointProtocol {
    public var dataLabels: [String] {
        guard let dataSet = dataSets.first else { return [] }
        return dataSet.dataPoints.compactMap(\.xAxisLabel)
    }
}

extension CTSingleDataSetProtocol where Self.DataPoint: CTPieDataPoint {
    public var dataLabels: [String] {
        return dataPoints.compactMap(\.description)
    }
}

// MARK: - Data Points
/**
 Protocol to set base configuration for data points.
 */
public protocol CTDataPointBaseProtocol: Hashable, Identifiable {
    
    var id: ID { get }
    
    /**
     A label that can be displayed on touch input
     
     It can be displayed in a floating box that tracks the users input location
     or placed in the header.
     */
    var description: String? { get set }
    
    /**
     Date can be used for optionally performing additional calculations.
     */
//    var date: Date? { get set }
    
    /**
     Internal property that has to be exposed publicly through the protocol.
     
     This is used for displaying legends outside of the `.legends()`
     view modifier.
     
     
     Do __Not__ Use.
     */
    var _legendTag: String { get set }
    
    /**
     Gets the relevant value(s) from the data point.
     
     - Parameter specifier: Specifier
     - Returns: Value as a string.
     */
    @available(*, deprecated, message: "")
    func valueAsString(specifier: String) -> String
}

/**
 A protocol to extend functionality of `CTDataPointBaseProtocol` for any chart
 type that needs a value.
 */
public protocol CTStandardDataPointProtocol: CTDataPointBaseProtocol {
    
    /**
     Value of the data point
     */
    var value: Double { get set }
}

/**
 A protocol to extend functionality of `CTDataPointBaseProtocol` for any chart
 type that needs a upper and lower values.
 */
public protocol CTRangeDataPointProtocol: CTDataPointBaseProtocol {
    /// Value of the upper range of the data point.
    var upperValue: Double { get set }
    
    /// Value of the lower range of the data point.
    var lowerValue: Double { get set }
}

public protocol CTisRanged {}
public protocol CTnotRanged {}

// MARK: deprecated
public struct DeprecatedCTStyle {}
extension CTChartData {
    public var chartStyle: DeprecatedCTStyle {
        DeprecatedCTStyle()
    }
}
