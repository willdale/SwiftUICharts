//
//  BarChartProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 03/03/2021.
//

import SwiftUI

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
