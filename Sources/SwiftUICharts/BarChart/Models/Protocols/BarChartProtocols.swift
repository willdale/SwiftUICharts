//
//  BarChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - Chart Data
/**
 A protocol to extend functionality of `CTLineBarChartDataProtocol` specifically for Bar Charts.
 */
public protocol CTBarChartDataProtocol: CTLineBarChartDataProtocol {
    
    associatedtype BarStyle : CTBarStyle
    /**
     Overall styling for the bars
     */
    var barStyle : BarStyle { get set }
}

extension CTBarChartDataProtocol where Self.CTStyle.Mark == BarMarkerType {
    internal func markerSubView<DS: CTDataSetProtocol>
    (dataSet         : DS,
     touchLocation   : CGPoint,
     chartSize       : CGRect) -> some View {
        Group {
            if let position = self.getPointLocation(dataSet: dataSets as! Self.SetPoint,
                                                    touchLocation: touchLocation,
                                                    chartSize: chartSize) {
                switch self.chartStyle.markerType {
                case .none:
                    EmptyView()
                case .vertical:
                    
                    MarkerFull(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                case .full:
                    
                    MarkerFull(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                case .bottomLeading:
                    
                    MarkerBottomLeading(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                    
                case .bottomTrailing:
                    
                    MarkerBottomTrailing(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                    
                case .topLeading:
                    
                    MarkerTopLeading(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                    
                case .topTrailing:
                    
                    MarkerTopTrailing(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                }
            }
        }
    }
}


extension CTBarChartDataProtocol where Self.Set.ID == UUID,
                                       Self.Set.DataPoint.ID == UUID,
                                       Self.Set: CTStandardBarChartDataSet,
                                       Self.Set.DataPoint: CTStandardBarDataPoint {
    internal func setupLegends() {
        
        switch self.barStyle.colourFrom {
        case .barStyle:
            if self.barStyle.fillColour.colourType == .colour,
               let colour = self.barStyle.fillColour.colour
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
                                               colour     : ColourStyle(colour: colour),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if self.barStyle.fillColour.colourType == .gradientColour,
                      let colours = self.barStyle.fillColour.colours
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
                                               colour     : ColourStyle(colours: colours,
                                                                       startPoint: .leading,
                                                                       endPoint: .trailing),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if self.barStyle.fillColour.colourType == .gradientStops,
                      let stops = self.barStyle.fillColour.stops
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
                                               colour     : ColourStyle(stops: stops,
                                                                       startPoint: .leading,
                                                                       endPoint: .trailing),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            }
        case .dataPoints:

            for data in dataSets.dataPoints {

                if data.fillColour.colourType == .colour,
                   let colour = data.fillColour.colour,
                   let legend = data.pointDescription
                {
                    self.legends.append(LegendData(id         : data.id,
                                                   legend     : legend,
                                                   colour     : ColourStyle(colour: colour),
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                } else if data.fillColour.colourType == .gradientColour,
                          let colours = data.fillColour.colours,
                          let legend = data.pointDescription
                {
                    self.legends.append(LegendData(id         : data.id,
                                                   legend     : legend,
                                                   colour     : ColourStyle(colours: colours,
                                                                           startPoint: .leading,
                                                                           endPoint: .trailing),
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                } else if data.fillColour.colourType == .gradientStops,
                          let stops = data.fillColour.stops,
                          let legend = data.pointDescription
                {
                    self.legends.append(LegendData(id         : data.id,
                                                   legend     : legend,
                                                   colour     : ColourStyle(stops: stops,
                                                                           startPoint: .leading,
                                                                           endPoint: .trailing),
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                }
            }
        }
    }
}

/**
 A protocol to extend functionality of `CTBarChartDataProtocol` specifically for Multi Part Bar Charts.
 */
public protocol CTMultiBarChartDataProtocol: CTBarChartDataProtocol {
    
    /**
     Grouping data to inform the chart about the relationship between the datapoints.
     */
    var groups : [GroupingData] { get set }
}

extension CTMultiBarChartDataProtocol {
    internal func setupLegends() {
        
        for group in self.groups {
            
            if group.fillColour.colourType == .colour,
               let colour = group.fillColour.colour
            {
                self.legends.append(LegendData(id         : group.id,
                                               legend     : group.title,
                                               colour     : ColourStyle(colour: colour),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if group.fillColour.colourType == .gradientColour,
                      let colours = group.fillColour.colours
            {
                self.legends.append(LegendData(id         : group.id,
                                               legend     : group.title,
                                               colour     : ColourStyle(colours: colours,
                                                                       startPoint: .leading,
                                                                       endPoint: .trailing),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if group.fillColour.colourType == .gradientStops,
                      let stops  = group.fillColour.stops
            {
                self.legends.append(LegendData(id         : group.id,
                                               legend     : group.title,
                                               colour     : ColourStyle(stops: stops,
                                                                       startPoint: .leading,
                                                                       endPoint: .trailing),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            }
        }
    }
}




// MARK: - Style
/**
 A protocol to extend functionality of `CTLineBarChartStyle` specifically for  Bar Charts.
 */
public protocol CTBarChartStyle: CTLineBarChartStyle {}

public protocol CTBarStyle: Hashable {
    /// How much of the available width to use. 0...1
    var barWidth    : CGFloat { get set }
    /// Corner radius of the bar shape.
    var cornerRadius: CornerRadius { get set }
    /// Where to get the colour data from.
    var colourFrom  : ColourFrom { get set }
    /// Drawing style of the fill.
    var fillColour : ColourStyle { get set }
}






// MARK: - DataSet
/**
 A protocol to extend functionality of `CTSingleDataSetProtocol` specifically for Standard Bar Charts.
 */
public protocol CTStandardBarChartDataSet: CTSingleDataSetProtocol {
    /**
     Label to display in the legend.
     */
    var legendTitle : String { get set }
}

/**
 A protocol to extend functionality of `CTSingleDataSetProtocol` specifically for Multi Part Bar Charts.
 */
public protocol CTMultiBarChartDataSet: CTSingleDataSetProtocol  {}








// MARK: - DataPoints
/**
 A protocol to extend functionality of `CTLineBarDataPointProtocol` specifically for standard Bar Charts.
 */
public protocol CTBarDataPoint: CTLineBarDataPointProtocol {}

/**
 A protocol to extend functionality of `CTLineBarDataPointProtocol` specifically for standard Bar Charts.
 */
public protocol CTStandardBarDataPoint: CTBarDataPoint {
    /// Drawing style of the range fill.
    var fillColour : ColourStyle { get set }
}

/**
 A protocol to extend functionality of `CTLineBarDataPointProtocol` specifically for multi part Bar Charts.
 i.e: Grouped or Stacked
 */
public protocol CTMultiBarDataPoint: CTBarDataPoint {
    
    /**
     For grouping data points together so they can be drawn in the correct groupings.
     */
    var group : GroupingData { get set }
    
}
