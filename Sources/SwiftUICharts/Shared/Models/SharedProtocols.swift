//
//  SharedProtocols.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//
 
import SwiftUI


// MARK: Chart Data
/**
 Main protocol for passing data around library.
 
 All Chart Data models ultimately conform to this.
 
 - Tag: ChartData
 */
public protocol ChartData: ObservableObject, Identifiable {
    associatedtype Set      : DataSet
    associatedtype DataPoint: CTChartDataPoint
    associatedtype CTStyle  : CTChartStyle
    
    var id: ID { get }
    
    /**
     Data model containing datapoints and styling information.
    
     `Set` is either `SingleData` or `MultiDataSet`.
    */
    var dataSets: Set { get set }
    
    /**
     Data model containing the charts Title, Subtitle and the Title for Legend.
     
     # Reference
     [ChartMetadata](x-source-tag://ChartMetadata)
    */
    var metadata: ChartMetadata { get set }
    
    /**
     Array of `LegendData` to populate the chart legend.

     This is populated automatically from within each view.
    */
    var legends: [LegendData] { get set }
    
    /**
     Data model to hold temporary data from `TouchOverlay` ViewModifier and pass the data points to display in the `HeaderView`.
    */
    var infoView: InfoViewData<DataPoint> { get set }
    
    /**
     Data model conatining the style data for the chart.
     
     # Reference
     [CTChartStyle](x-source-tag://CTChartStyle)
     */
    var chartStyle: CTStyle { get set }
    
    /**
     Customisable `Text` to display when where is not enough data to draw the chart.
    */
    var noDataText: Text { get set }
    
    /**
     Holds data about the charts type.
     
     Allows for internal logic based on the type of chart.
     
     This might get removed in favour of a more protocol based approach.
     
     # Reference
     [ChartType](x-source-tag://ChartType)
    
     [DataSetType](x-source-tag://DataSetType)
     
    */
    var chartType: (chartType: ChartType, dataSetType: DataSetType) { get }
    
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
     Configures the legends based on the type of chart.
     
     - Tag: setupLegends
     */
    func setupLegends()
    
    /**
     Returns whether there are two or more dataPoints
     */
    func isGreaterThanTwo() -> Bool
    
    // MARK: Touch
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
}

extension ChartData {
    public func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}

extension ChartData where Set: SingleDataSet {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count > 2
    }
}
extension ChartData where Set: MultiDataSet {
    public func isGreaterThanTwo() -> Bool {
        var returnValue: Bool = true
        dataSets.dataSets.forEach { dataSet in
            returnValue = dataSet.dataPoints.count > 2
        }
        return returnValue
    }
}

// MARK: - Data Sets
/**
 Main protocol set conformace for types of Data Sets.
 
 - Tag: DataSet
 */
public protocol DataSet: Hashable, Identifiable {
    var id : ID { get }
}

/**
 Protocol for data sets that only require a single set of data .
  
 - Tag: SingleDataSet
 */
public protocol SingleDataSet: DataSet {
    associatedtype Styling   : CTColourStyle
    associatedtype DataPoint : CTChartDataPoint
    
    /**
     Array of data points.
     
     [See CTChartDataPoint](x-source-tag://CTChartDataPoint)
     */
    var dataPoints  : [DataPoint] { get set }
    
    /**
     Label to display in the legend.
     */
    var legendTitle : String { get set }
    
    
    
    /**
     Sets the style for the Data Set (as opposed to Chart Data Style).
     */
    var style       : Styling { get set }
}

/**
 Protocol for data sets that require a multiple sets of data .
  
 - Tag: MultiDataSet
 */
public protocol MultiDataSet: DataSet {
    associatedtype DataSet : SingleDataSet
    /**
     Array of DataSets.
     [See SingleDataSet](x-source-tag://SingleDataSet)
     */
    var dataSets    : [DataSet] { get set }
}




// MARK: - Styles
/**
 Protocol to set the styling data for the chart.
 
  - Tag: CTChartStyle
 */
public protocol CTChartStyle {
    
    /**
     Placement of the information box that appears on touch input.
     
     # Reference
     [See InfoBoxPlacement](x-source-tag://InfoBoxPlacement)
     */
    var infoBoxPlacement        : InfoBoxPlacement { get set }
    
    /**
     Colour of the value part of the touch info.
     */
    var infoBoxValueColour      : Color { get set }
    
    /**
     Colour of the description part of the touch info.
     */
    var infoBoxDescriptionColor : Color { get set }
    
    /**
     Global control of animations.
         
     ```
     Animation.linear(duration: 1)
     ```
     */
    var globalAnimation  : Animation { get set }
}


/**
 A protocol to set varius colour styles.
 
 Allows for single colour, gradient or gradient with stops control.
  
 - Tag: CTColourStyle
 */
public protocol CTColourStyle {
    
    /**
     Selection for the style of colour.
     
     [See ColourType](x-source-tag://ColourType)
     */
    var colourType: ColourType { get set }
    
    /// Single Colour
    var colour: Color? { get set }
    
    /// Array of colours for gradient
    var colours: [Color]? { get set }
    
    /**
     Array of Gradient Stops.
     
     GradientStop is a Hashable version of Gradient.Stop
     
     [See GradientStop](x-source-tag://GradientStop)
     */
    var stops: [GradientStop]? { get set }
    
    /// Start point for the gradient
    var startPoint: UnitPoint? { get set }
    
    /// End point for the gradient
    var endPoint: UnitPoint? { get set }
}




// MARK: - Data Points

/**
 Protocol to set base configuration for data points.
 
 - Tag: CTChartDataPoint
 
 */
public protocol CTChartDataPoint: Hashable, Identifiable {
    
    var id               : ID { get }
    
    /**
     Value of the data point
     */
    var value            : Double { get set }
    
    /**
     A laabel that can be displayed on touch input
    
     It can eight be displayed in a floating box that tracks the users input location
     or placed in the header. [See InfoBoxPlacement](x-source-tag://InfoBoxPlacement).
    */
    var pointDescription : String? { get set }
    
    /**
     Date can be used for performing additional calculations.
     
     [See Calculations](x-source-tag://Calculations)
     */
    var date             : Date? { get set }
    
}
