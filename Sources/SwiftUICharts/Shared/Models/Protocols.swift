//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public protocol ChartData: ObservableObject, Identifiable {
    associatedtype Set      : DataSet
    associatedtype DataPoint: ChartDataPoint
    
    var id          : UUID { get }
    var dataSets    : Set { get set }
    var metadata    : ChartMetadata? { get set }
    var xAxisLabels : [String]? { get set } // Not pie
    var legends     : [LegendData] { get set }
    var viewData    : ChartViewData<DataPoint> { get set }
    var noDataText  : Text { get set }
    var chartType   : (chartType: ChartType, dataSetType: DataSetType) { get }
    func legendOrder() -> [LegendData]
    func getHeaderLocation() -> InfoBoxPlacement
}
extension ChartData {
    /// Sets the order the Legends are layed out in.
    /// - Returns: Ordered array of Legends.
    public func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}
public protocol LineAndBarChartData : ChartData {
    associatedtype Style : CTLineAndBarChartStyle
    
    var chartStyle  : Style { get set }
    
   
}
public protocol PieChartDataProtocol : ChartData {
    associatedtype Style : CTPieChartStyle
    
    var chartStyle  : Style { get set }
}



public protocol DataSet: Hashable, Identifiable {
    var id : ID { get }
}
public protocol SingleDataSet: DataSet {
    associatedtype Styling   : CTColourStyle
    associatedtype DataPoint : ChartDataPoint
    
    var dataPoints  : [DataPoint] { get set }
    var legendTitle : String { get set }
    var pointStyle  : PointStyle { get set }
    var style       : Styling { get set }
}
public protocol MultiDataSet: DataSet {
    associatedtype DataSet : SingleDataSet
    
    var dataSets    : [DataSet] { get set }
}



public protocol CTChartStyle {
    var infoBoxPlacement : InfoBoxPlacement { get set }
    var globalAnimation  : Animation { get set }
}
public protocol CTLineAndBarChartStyle: CTChartStyle {
    var xAxisGridStyle      : GridStyle { get set }
    var yAxisGridStyle      : GridStyle { get set }
    var xAxisLabelPosition  : XAxisLabelPosistion { get set }
    var xAxisLabelsFrom     : LabelsFrom { get set }
    var yAxisLabelPosition  : YAxisLabelPosistion { get set }
    var yAxisNumberOfLabels : Int { get set }
}
public protocol CTPieChartStyle: CTChartStyle {}

public protocol CTColourStyle {
    var colourType  : ColourType { get set }
    var colour      : Color? { get set }
    var colours     : [Color]? { get set }
    var stops       : [GradientStop]? { get set }
    var startPoint  : UnitPoint? { get set }
    var endPoint    : UnitPoint? { get set }
}




public protocol ChartDataPoint: Hashable, Identifiable {
    var id               : ID { get }
    var value            : Double { get set }
    var xAxisLabel       : String? { get set } // Not Pie
    var pointDescription : String? { get set }
    var date             : Date? { get set }
}


public enum DataSetType {
    case single
    case multi
}

