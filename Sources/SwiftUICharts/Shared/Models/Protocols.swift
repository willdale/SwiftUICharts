//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//
 
import SwiftUI

public protocol ChartData: ObservableObject, Identifiable {
    associatedtype Set      : DataSet
    associatedtype DataPoint: CTChartDataPoint
    
    var id          : UUID { get }
    var dataSets    : Set { get set }
    var metadata    : ChartMetadata? { get set }
    var xAxisLabels : [String]? { get set } // Not pie
    var legends     : [LegendData] { get set }
    var infoView    : InfoViewData<DataPoint> { get set }
    var noDataText  : Text { get set }
    var chartType   : (chartType: ChartType, dataSetType: DataSetType) { get }
    
    // Sets the order the Legends are layed out in.
    /// - Returns: Ordered array of Legends.
    func legendOrder() -> [LegendData]
    func getHeaderLocation() -> InfoBoxPlacement
    
    /// Gets the nearest data point to the touch location based on the X axis.
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [DataPoint]
    
    /// Gets the location of the data point in the view.
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint]
    
    func setupLegends()
}


extension ChartData {
    public func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}

public protocol LineAndBarChartData : ChartData {
    
    associatedtype Body    : View
    associatedtype CTStyle : CTLineAndBarChartStyle
    var viewData    : ChartViewData { get set }
    var chartStyle  : CTStyle { get set }
    
    func getXAxidLabels() -> Body
    func getYLabels() -> [Double]
    
    func getRange() -> Double
    func getMinValue() -> Double
    func getMaxValue() -> Double
    func getAverage() -> Double
}

extension LineAndBarChartData where Self: LineChartDataProtocol {
    public func getYLabels() -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double
        let minValue    : Double
        let range       : Double
        
        switch self.chartStyle.baseline {
        case .minimumValue:
            minValue  = self.getMinValue()
            dataRange = self.getRange()
            range     = dataRange / Double(self.chartStyle.yAxisNumberOfLabels)
        case .zero:
            minValue  = 0
            dataRange = self.getMaxValue()
            range     = dataRange / Double(self.chartStyle.yAxisNumberOfLabels)
        }
        labels.append(minValue)
        for index in 1...self.chartStyle.yAxisNumberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }
}
extension LineAndBarChartData where Self: BarChartDataProtocol {
    public func getYLabels() -> [Double] {
        var labels  : [Double]  = [Double]()
        let maxValue: Double    = self.getMaxValue()
        for index in 0...self.chartStyle.yAxisNumberOfLabels {
            labels.append(maxValue / Double(self.chartStyle.yAxisNumberOfLabels) * Double(index))
        }
        return labels
    }
}

extension LineAndBarChartData where Set: SingleDataSet {
    public func getRange() -> Double {
        DataFunctions.dataSetRange(from: dataSets)
    }
    public func getMinValue() -> Double {
        DataFunctions.dataSetMinValue(from: dataSets)
    }
    public func getMaxValue() -> Double {
        DataFunctions.dataSetMaxValue(from: dataSets)
    }
    public func getAverage() -> Double {
        DataFunctions.dataSetAverage(from: dataSets)
    }
}
extension LineAndBarChartData where Set: MultiDataSet {
    public func getRange() -> Double {
        DataFunctions.multiDataSetRange(from: dataSets)
    }
    public func getMinValue() -> Double {
        DataFunctions.multiDataSetMinValue(from: dataSets)
    }
    public func getMaxValue() -> Double {
        DataFunctions.multiDataSetMaxValue(from: dataSets)
    }
    public func getAverage() -> Double {
        DataFunctions.multiDataSetAverage(from: dataSets)
    }
}

public protocol LineChartDataProtocol: LineAndBarChartData {
    associatedtype Style : CTLineChartStyle
    var chartStyle  : Style { get set }
}
public protocol BarChartDataProtocol: LineAndBarChartData {
    associatedtype Style : CTBarChartStyle
    var chartStyle  : Style { get set }
}
public protocol PieChartDataProtocol : ChartData {
    associatedtype Style : CTPieChartStyle
    var chartStyle  : Style { get set }
}


// MARK: - Data Sets
public protocol DataSet: Hashable, Identifiable {
    var id : ID { get }
}
public protocol SingleDataSet: DataSet {
    associatedtype Styling   : CTColourStyle
    associatedtype DataPoint : CTChartDataPoint
    
    var dataPoints  : [DataPoint] { get set }
    var legendTitle : String { get set }
    var pointStyle  : PointStyle { get set }
    var style       : Styling { get set }
}
public protocol MultiDataSet: DataSet {
    associatedtype DataSet : SingleDataSet
    var dataSets    : [DataSet] { get set }
}


// MARK: - Styles
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
public protocol CTLineChartStyle : CTLineAndBarChartStyle {
    var baseline    : Baseline { get set }
}
public protocol CTBarChartStyle : CTLineAndBarChartStyle {
}
public protocol CTPieChartStyle: CTChartStyle {
}

public protocol CTColourStyle {
    var colourType  : ColourType { get set }
    var colour      : Color? { get set }
    var colours     : [Color]? { get set }
    var stops       : [GradientStop]? { get set }
    var startPoint  : UnitPoint? { get set }
    var endPoint    : UnitPoint? { get set }
}

// MARK: - Data Points
public protocol CTChartDataPoint: Hashable, Identifiable {
    var id               : ID { get }
    var value            : Double { get set }
    var pointDescription : String? { get set }
    var date             : Date? { get set }
}

public protocol  CTLineAndBarDataPoint: CTChartDataPoint {
    var xAxisLabel       : String? { get set }
}

public protocol  CTPieDataPoint: CTChartDataPoint {
    
}
