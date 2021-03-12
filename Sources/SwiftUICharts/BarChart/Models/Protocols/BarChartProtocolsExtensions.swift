//
//  BarChartProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 03/03/2021.
//

import SwiftUI

// MARK: - Markers
extension CTBarChartDataProtocol where Self.CTStyle.Mark == BarMarkerType {
    internal func markerSubView() -> some View {
        Group {
            if let position = self.getPointLocation(dataSet: dataSets as! Self.SetPoint,
                                                    touchLocation: self.infoView.touchLocation,
                                                    chartSize: self.infoView.chartSize) {
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

// MARK: - Legends
// MARK: Standard / Ranged
extension CTBarChartDataProtocol where Self.Set.ID == UUID,
                                       Self.Set.DataPoint.ID == UUID,
                                       Self.Set: CTStandardBarChartDataSet,
                                       Self.Set.DataPoint: CTBarColourProtocol {
    internal func setupLegends() {
        switch self.barStyle.colourFrom {
        case .barStyle:
            if self.barStyle.colour.colourType == .colour,
               let colour = self.barStyle.colour.colour
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
                                               colour     : ColourStyle(colour: colour),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if self.barStyle.colour.colourType == .gradientColour,
                      let colours = self.barStyle.colour.colours
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
                                               colour     : ColourStyle(colours: colours,
                                                                        startPoint: .leading,
                                                                        endPoint: .trailing),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if self.barStyle.colour.colourType == .gradientStops,
                      let stops = self.barStyle.colour.stops
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
                
                if data.colour.colourType == .colour,
                   let colour = data.colour.colour,
                   let legend = data.description
                {
                    self.legends.append(LegendData(id         : data.id,
                                                   legend     : legend,
                                                   colour     : ColourStyle(colour: colour),
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                } else if data.colour.colourType == .gradientColour,
                          let colours = data.colour.colours,
                          let legend = data.description
                {
                    self.legends.append(LegendData(id         : data.id,
                                                   legend     : legend,
                                                   colour     : ColourStyle(colours: colours,
                                                                            startPoint: .leading,
                                                                            endPoint: .trailing),
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                } else if data.colour.colourType == .gradientStops,
                          let stops = data.colour.stops,
                          let legend = data.description
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

// MARK: Multi Bar
extension CTMultiBarChartDataProtocol {
    internal func setupLegends() {
        
        for group in self.groups {
            
            if group.colour.colourType == .colour,
               let colour = group.colour.colour
            {
                self.legends.append(LegendData(id         : group.id,
                                               legend     : group.title,
                                               colour     : ColourStyle(colour: colour),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if group.colour.colourType == .gradientColour,
                      let colours = group.colour.colours
            {
                self.legends.append(LegendData(id         : group.id,
                                               legend     : group.title,
                                               colour     : ColourStyle(colours: colours,
                                                                       startPoint: .leading,
                                                                       endPoint: .trailing),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if group.colour.colourType == .gradientStops,
                      let stops  = group.colour.stops
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
