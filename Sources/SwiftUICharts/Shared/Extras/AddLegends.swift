//
//  Legends.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

internal struct AddLegends {
    static func setupLine<T: ChartData>(chartData: inout T, dataSet: LineDataSet) {
        if dataSet.style.colourType == .colour,
           let colour = dataSet.style.colour
        {
            chartData.legends.append(LegendData(legend     : dataSet.legendTitle,
                                                colour     : colour,
                                                strokeStyle: dataSet.style.strokeStyle,
                                                prioity    : 1,
                                                chartType  : .line))
            
        } else if dataSet.style.colourType == .gradientColour,
                  let colours = dataSet.style.colours
        {
            chartData.legends.append(LegendData(legend     : dataSet.legendTitle,
                                                colours    : colours,
                                                startPoint : .leading,
                                                endPoint   : .trailing,
                                                strokeStyle: dataSet.style.strokeStyle,
                                                prioity    : 1,
                                                chartType  : .line))
            
        } else if dataSet.style.colourType == .gradientStops,
                  let stops = dataSet.style.stops
        {
            chartData.legends.append(LegendData(legend     : dataSet.legendTitle,
                                                stops      : stops,
                                                startPoint : .leading,
                                                endPoint   : .trailing,
                                                strokeStyle: dataSet.style.strokeStyle,
                                                prioity    : 1,
                                                chartType  : .line))
        }
//        chartData.viewData.chartType = .line
    }
    
    static func setupBar<T: BarChartData>(chartData: inout T, dataSet: BarDataSet) {

        switch chartData.dataSets.style.colourFrom {
        case .barStyle:
            if dataSet.style.colourType == .colour,
               let colour = dataSet.style.colour
            {
                chartData.legends.append(LegendData(legend     : dataSet.legendTitle,
                                                         colour     : colour,
                                                         strokeStyle: nil,
                                                         prioity    : 1,
                                                         chartType  : .bar))
            } else if dataSet.style.colourType == .gradientColour,
                      let colours = dataSet.style.colours
            {
                chartData.legends.append(LegendData(legend     : dataSet.legendTitle,
                                                         colours    : colours,
                                                         startPoint : .leading,
                                                         endPoint   : .trailing,
                                                         strokeStyle: nil,
                                                         prioity    : 1,
                                                         chartType  : .bar))
            } else if dataSet.style.colourType == .gradientStops,
                      let stops = dataSet.style.stops
            {
                chartData.legends.append(LegendData(legend     : dataSet.legendTitle,
                                                         stops      : stops,
                                                         startPoint : .leading,
                                                         endPoint   : .trailing,
                                                         strokeStyle: nil,
                                                         prioity    : 1,
                                                         chartType  : .bar))
            }
        case .dataPoints:
            Text("")
        }
    }
}
