//
//  LineChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - Chart Data
/**
 A protocol to extend functionality of `CTLineBarChartDataProtocol` specifically for Line Charts.
 */
public protocol CTLineChartDataProtocol: CTLineBarChartDataProtocol {

    /// A type representing opaque View
    associatedtype Points : View
    /// A type representing opaque View
    associatedtype Access : View
    
    /**
     Displays Shapes over the data points.
     
     - Returns: Relevent view containing point markers based the chosen parameters.
     */
    func getPointMarker() -> Points
    
    /**
     Ensures that line charts have an accessibility layer.
     
     - Returns: A view with invisible rectangles over the data point.
     */
    func getAccessibility() -> Access
}

extension CTLineChartDataProtocol where Self.Set.ID == UUID,
                                        Self.Set: CTLineChartDataSet {
   internal func setupLegends() {
        
        if dataSets.style.lineColour.colourType == .colour,
           let colour = dataSets.style.lineColour.colour
        {
            self.legends.append(LegendData(id         : dataSets.id,
                                           legend     : dataSets.legendTitle,
                                           colour     : ColourStyle(colour: colour),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))

        } else if dataSets.style.lineColour.colourType == .gradientColour,
                  let colours = dataSets.style.lineColour.colours
        {
            self.legends.append(LegendData(id         : dataSets.id,
                                           legend     : dataSets.legendTitle,
                                           colour     : ColourStyle(colours: colours,
                                                                   startPoint: .leading,
                                                                   endPoint: .trailing),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))

        } else if dataSets.style.lineColour.colourType == .gradientStops,
                  let stops = dataSets.style.lineColour.stops
        {
            self.legends.append(LegendData(id         : dataSets.id,
                                           legend     : dataSets.legendTitle,
                                           colour     : ColourStyle(stops: stops,
                                                                   startPoint: .leading,
                                                                   endPoint: .trailing),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))
        }
    }
}
extension CTLineChartDataProtocol where Self.Set.ID == UUID,
                                        Self.Set: CTRangedLineChartDataSet,
                                        Self.Set.Styling: CTRangedLineStyle {
    internal func setupRangeLegends() {
        if dataSets.style.fillColour.colourType == .colour,
           let colour = dataSets.style.fillColour.colour
        {
            self.legends.append(LegendData(id         : UUID(),
                                           legend     : dataSets.legendFillTitle,
                                           colour     : ColourStyle(colour: colour),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .bar))

        } else if dataSets.style.fillColour.colourType == .gradientColour,
                  let colours = dataSets.style.fillColour.colours
        {
            self.legends.append(LegendData(id         : UUID(),
                                           legend     : dataSets.legendFillTitle,
                                           colour     : ColourStyle(colours: colours,
                                                                   startPoint: .leading,
                                                                   endPoint: .trailing),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))

        } else if dataSets.style.fillColour.colourType == .gradientStops,
                  let stops = dataSets.style.fillColour.stops
        {
            self.legends.append(LegendData(id         : UUID(),
                                           legend     : dataSets.legendFillTitle,
                                           colour     : ColourStyle(stops: stops,
                                                                   startPoint: .leading,
                                                                   endPoint: .trailing),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))
        }
    }
}
extension CTLineChartDataProtocol where Self.Set == MultiLineDataSet {
   internal func setupLegends() {
        for dataSet in dataSets.dataSets {
            if dataSet.style.lineColour.colourType == .colour,
               let colour = dataSet.style.lineColour.colour
            {
                self.legends.append(LegendData(id         : dataSet.id,
                                               legend     : dataSet.legendTitle,
                                               colour     : ColourStyle(colour: colour),
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
                
            } else if dataSet.style.lineColour.colourType == .gradientColour,
                      let colours = dataSet.style.lineColour.colours
            {
                self.legends.append(LegendData(id         : dataSet.id,
                                               legend     : dataSet.legendTitle,
                                               colour     : ColourStyle(colours: colours,
                                                                       startPoint: .leading,
                                                                       endPoint: .trailing),
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
                
            } else if dataSet.style.lineColour.colourType == .gradientStops,
                      let stops = dataSet.style.lineColour.stops
            {
                self.legends.append(LegendData(id         : dataSet.id,
                                               legend     : dataSet.legendTitle,
                                               colour     : ColourStyle(stops: stops,
                                                                       startPoint: .leading,
                                                                       endPoint: .trailing),
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
            }
        }
    }
}

// MARK: - Style
/**
 A protocol to extend functionality of `CTLineBarChartStyle` specifically for  Line Charts.
 */
public protocol CTLineChartStyle : CTLineBarChartStyle {}

public protocol CTLineStyle {
    /// Drawing style of the line.
    var lineType   : LineType { get set }
    
    /// Colour styling of the line.
    var lineColour : ColourStyle { get set }
    
    /**
     Styling for stroke
     
     Replica of Apple’s StrokeStyle that conforms to Hashable
     */
    var strokeStyle : Stroke { get set }
}

/**
 A protocol to extend functionality of `CTLineStyle` specifically for Ranged Line Charts.
 */
public protocol CTRangedLineStyle: CTLineStyle {
    /// Drawing style of the range fill.
    var fillColour : ColourStyle { get set }
}



// MARK: - DataSet
/**
 A protocol to extend functionality of `SingleDataSet` specifically for Line Charts.
 */
public protocol CTLineChartDataSet: CTSingleDataSetProtocol {
    
    /// A type representing colour styling
    associatedtype Styling   : CTLineStyle
    
    /**
     Label to display in the legend.
     */
    var legendTitle : String { get set }
    
    /**
     Sets the style for the Data Set (as opposed to Chart Data Style).
     */
    var style : Styling { get set }
    
    /**
     Sets the look of the markers over the data points.
     
     The markers are layed out when the ViewModifier `PointMarkers`
     is applied.
     */
    var pointStyle : PointStyle { get set }
}
public protocol CTRangedLineChartDataSet: CTLineChartDataSet {
    var legendFillTitle : String { get set }
}

public protocol CTMultiLineChartDataSet: CTMultiDataSetProtocol {}



// MARK: - Data Point
/**
 A protocol to extend functionality of `CTLineBarDataPointProtocol` specifically for Line and Bar Charts.
 */
public protocol CTLineDataPointProtocol: CTLineBarDataPointProtocol {}

/**
 A protocol to extend functionality of `CTChartDataPointProtocol` specifically for Ranged Line Charts.
 */
public protocol CTRangedLineDataPoint: CTLineDataPointProtocol {
    /// Value of the upper range of the data point.
    var upperValue : Double { get set }
    
    /// Value of the lower range of the data point.
    var lowerValue : Double { get set }
}
