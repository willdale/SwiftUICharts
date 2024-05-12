//
//  SharedProtocols.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public final class TouchedData<DataPoint> where DataPoint: CTDataPointBaseProtocol {
    @Published public var touchPointData: [DataPoint] = []
}

internal typealias CTChartType = (chartType: ChartType, dataSetType: DataSetType)
public typealias ChartConformance = DataHelper & Publishable & Touchable

// MARK: Chart Data

/// Main protocol for passing data around library.
///
/// All Chart Data models ultimately conform to this.
public protocol CTChartData: ObservableObject, Identifiable {
    
    /// A type representing a  data set. -- `CTDataSetProtocol`
    associatedtype SetType: CTDataSetProtocol
    
    var id: ID { get }
    
    /// This is a read out by voice over to make it clear what is being described.
    ///
    /// The value could be what the chart title is or screen title.
    var accessibilityTitle: LocalizedStringKey { get set }
    
    /// Data model containing datapoints and styling information.
    var dataSets: SetType { get set }
    
    /// Customisable `Text` to display when where is not enough data to draw the chart.
    var noDataText: Text { get set }
    
    /// A global control to disable animations
    var disableAnimation: Bool { get set }
    
    var chartName: ChartName { get }
}

extension CTChartData {
    
    internal var spacing: CGFloat {
        return 0
    }
}

// MARK: - Data Sets

/// Main protocol to set conformace for types of Data Sets.
public protocol CTDataSetProtocol: Hashable, Identifiable {
    var id: ID { get }
}

/// Protocol for data sets that only require a single set of data.
public protocol CTSingleDataSetProtocol: CTDataSetProtocol {
    
    /// A type representing a data point. -- `CTChartDataPoint`
    associatedtype DataPoint: CTDataPointBaseProtocol
    
    /// Array of data points.
    var dataPoints: [DataPoint] { get set }
}

/// Protocol for data sets that require a multiple sets of data.
public protocol CTMultiDataSetProtocol: CTDataSetProtocol {
    
    /// A type representing a single data set -- `SingleDataSet`
    associatedtype DataSet: CTSingleDataSetProtocol
    
    /// Array of single data sets.
    var dataSets: [DataSet] { get set }
}

// MARK: - Data Points

/// Protocol to set base configuration for data points.
public protocol CTDataPointBaseProtocol: Hashable, Identifiable {
    
    var id: ID { get }
    
    /// A label that can be displayed on touch input
    ///
    /// It can be displayed in a floating box that tracks the users input location
    /// or placed in the header.
    var description: String? { get set }
}


/// A protocol to extend functionality of ``CTDataPointBaseProtocol`` for any chart
/// type that needs a value.
public protocol CTStandardDataPointProtocol: CTDataPointBaseProtocol {
    
    /// Value of the data point
    var value: Double { get set }
}


/// A protocol to extend functionality of `CTDataPointBaseProtocol` for any chart
/// type that needs a upper and lower values.
public protocol CTRangeDataPointProtocol: CTDataPointBaseProtocol {
    
    /// Value of the upper range of the data point.
    var upperValue: Double { get set }
    
    /// Value of the lower range of the data point.
    var lowerValue: Double { get set }
}
