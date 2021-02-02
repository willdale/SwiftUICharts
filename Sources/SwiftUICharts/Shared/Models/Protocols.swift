//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//
 
import SwiftUI

/// The main
public protocol ChartData: ObservableObject, Identifiable {
    associatedtype Set      : DataSet
    associatedtype DataPoint: CTChartDataPoint
    
    
    var id          : UUID { get }
    /// Data model containing the datapoints.
    /// - Note:
    /// `Set` is either `SingleData` or `MultiDataSet`.
    var dataSets    : Set { get set }
    
    /// Data model containing: the charts Title, the charts Subtitle and the Line Legend.
    var metadata    : ChartMetadata? { get set }
    
    /// Array of strings for the labels on the X Axis instead of the labels in the data points.
    /// - Note:
    /// To control where the labels should come from; set `xAxisLabelsFrom` in `ChartStyle`.
    var xAxisLabels : [String]? { get set } // Not Pie
    
    /// Array of `LegendData` to populate the chart legend.
    /// - Note:
    /// This is populated automatically from within each view.
    var legends     : [LegendData] { get set }
    
    /// Data model to hold temporary data from `TouchOverlay` ViewModifier and pass the data points to display in the `HeaderView`.
    var infoView    : InfoViewData<DataPoint> { get set }
    
    /// Customisable `Text` to display when where is not enough data to draw the chart.
    var noDataText  : Text { get set }
    
    /**
     Holds metadata about the chart.
     
     Allows for internal logic based on the type of chart.
     
     This might get removed in favour of a more protocol based approach.
     
     # Reference
     [ChartType](x-source-tag://ChartType)
    
     [DataSetType](x-source-tag://DataSetType)
    */
    var chartType   : (chartType: ChartType, dataSetType: DataSetType) { get }
    
    /**
    Sets the order the Legends are layed out in.
     - Returns: Ordered array of Legends.
     
     # Reference
     [LegendData](x-source-tag://LegendData)
     - Tag: legendOrder
    */
    func legendOrder() -> [LegendData]
    
    /**
     Gets the where to display the touch overlay information.
     - Returns: Where to display the data points
     
     # Reference
     [InfoBoxPlacement](x-source-tag://InfoBoxPlacement)
     
     - Tag: getHeaderLocation
     */
    func getHeaderLocation() -> InfoBoxPlacement
    
    /**
    Gets the nearest data points to the touch location.
    - Parameters:
      - touchLocation: Current location of the touch
      - chartSize: The size of the chart view as the parent view.
    - Returns: Array of data points.
     
    - Tag: getDataPoint
    */
    func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [DataPoint]
    
    /**
    Gets the location of the data point in the view.
    - Parameters:
      - touchLocation: Current location of the touch
      - chartSize: The size of the chart view as the parent view.
    - Returns: Array of points with the location on screen of data points
     
    - Tag: getDataPoint
    */
    func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint]
    
    /// Configures the legends based on the type of chart.
    func setupLegends()
}




public protocol LineAndBarChartData : ChartData {
    
    associatedtype Body    : View
    associatedtype CTStyle : CTLineAndBarChartStyle
    /// Data model to hold data about the Views layout.
    ///
    /// This informs some `ViewModifiers` whether the chart has X and/or Y axis labels so they can configure thier layouts appropriately.
    var viewData    : ChartViewData { get set }
    var chartStyle  : CTStyle { get set }
    
    func getXAxidLabels() -> Body
    func getYLabels() -> [Double]
    
    func getRange() -> Double
    func getMinValue() -> Double
    func getMaxValue() -> Double
    func getAverage() -> Double
}
public protocol LineChartDataProtocol: LineAndBarChartData where CTStyle: CTLineChartStyle {
    var chartStyle  : CTStyle { get set }
    var isFilled    : Bool { get set}
}
public protocol BarChartDataProtocol: LineAndBarChartData where CTStyle: CTBarChartStyle {
    var chartStyle  : CTStyle { get set }
}




public protocol PieAndDoughnutChartDataProtocol: ChartData {
    associatedtype CTStyle : CTPieAndDoughnutChartStyle
    var chartStyle  : CTStyle { get set }
}

public protocol PieChartDataProtocol : PieAndDoughnutChartDataProtocol where CTStyle: CTPieChartStyle {
    var chartStyle  : CTStyle { get set }
}
public protocol DoughnutChartDataProtocol : PieAndDoughnutChartDataProtocol where CTStyle: CTDoughnutChartStyle {
    var chartStyle  : CTStyle { get set }
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
public protocol CTBarChartStyle : CTLineAndBarChartStyle {}


public protocol CTPieAndDoughnutChartStyle: CTChartStyle {}

public protocol CTPieChartStyle: CTPieAndDoughnutChartStyle {}

public protocol CTDoughnutChartStyle: CTPieAndDoughnutChartStyle {
    var strokeWidth : CGFloat { get set }
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
public protocol CTLineAndBarDataPoint: CTChartDataPoint {
    var xAxisLabel       : String? { get set }
}
public protocol CTPieDataPoint: CTChartDataPoint {
    
}



// MARK: - Extensions

extension ChartData {
    public func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}

extension LineAndBarChartData {
    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }
}

// MARK: - Line and Bar
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


// MARK: - Pie and Doughnut
extension PieAndDoughnutChartDataProtocol {
    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }
}
extension PieAndDoughnutChartDataProtocol where Set == PieDataSet {

    internal func makeDataPoints() {
        let total       = self.dataSets.dataPoints.reduce(0) { $0 + $1.value }
        var startAngle  = -Double.pi / 2
        self.dataSets.dataPoints.indices.forEach { (point) in
            let amount = .pi * 2 * (self.dataSets.dataPoints[point].value / total)
            self.dataSets.dataPoints[point].amount = amount
            self.dataSets.dataPoints[point].startAngle = startAngle
            startAngle += amount
        }
    }
    
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [PieChartDataPoint] {
        var points : [PieChartDataPoint] = []
        let touchDegree = degree(from: touchLocation, in: chartSize.frame(in: .local))
                
        let dataPoint = self.dataSets.dataPoints.first(where: { $0.startAngle * Double(180 / Double.pi) <= Double(touchDegree) && ($0.startAngle * Double(180 / Double.pi)) + ($0.amount * Double(180 / Double.pi)) >= Double(touchDegree) } )
        if let data = dataPoint {
            points.append(data)
        }
        return points
    }
    
    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        return [HashablePoint(x: touchLocation.x, y: touchLocation.y)]
    }
    
    public func setupLegends() {
        for data in dataSets.dataPoints {
            if let legend = data.pointDescription {
                self.legends.append(LegendData(id         : data.id,
                                               legend     : legend,
                                               colour     : data.colour,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .pie))
            }
        }
    }
    
    func degree(from touchLocation: CGPoint, in rect: CGRect) -> CGFloat {
        // http://www.cplusplus.com/reference/cmath/atan2/
        // https://stackoverflow.com/a/25398191
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let coordinates = CGPoint(x: touchLocation.x - center.x,
                                  y: touchLocation.y - center.y)
        // -90 is north
        let degrees = atan2(-coordinates.x, -coordinates.y) * CGFloat(180 / Double.pi)
        if (degrees > 0) {
            return 270 - degrees
        } else {
            return -90 - degrees
        }
    }
}
