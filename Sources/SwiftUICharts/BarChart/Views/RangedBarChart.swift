//
//  RangedBarChart.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

public struct RangedBarChart<ChartData>: View where ChartData: RangedBarChartData {
    
    @ObservedObject var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be RangedBarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        if chartData.isGreaterThanTwo() {
            HStack(spacing: 0) {
                
                switch chartData.barStyle.colourFrom {
                case .barStyle:
                    
                    RangedBarChartBarStyleSubView(chartData: chartData)
                        .accessibilityLabel( Text("\(chartData.metadata.title)"))
                case .dataPoints:
                    
                    RangedBarChartDataPointSubView(chartData: chartData)
                        .accessibilityLabel( Text("\(chartData.metadata.title)"))
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}

internal struct RangedBarChartBarStyleSubView<CD:RangedBarChartData>: View {
    
    private let chartData : CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    var body: some View {
        
        if chartData.barStyle.colour.colourType == .colour,
           let colour = chartData.barStyle.colour.colour {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GeometryReader { geo in
                    RangedBarChartColourCell(chartData : chartData,
                                             dataPoint : dataPoint,
                                             colour    : colour,
                                             barSize   : geo.frame(in: .local))
                }
            }
        } else if chartData.barStyle.colour.colourType == .gradientColour,
                  let colours    = chartData.barStyle.colour.colours,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint   = chartData.barStyle.colour.endPoint {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GeometryReader { geo in
                    RangedBarChartColoursCell(chartData : chartData,
                                              dataPoint : dataPoint,
                                              colours   : colours,
                                              startPoint: startPoint,
                                              endPoint  : endPoint,
                                              barSize   : geo.frame(in: .local))
                }
            }
        } else if chartData.barStyle.colour.colourType == .gradientStops,
                  let stops      = chartData.barStyle.colour.stops,
                  let startPoint = chartData.barStyle.colour.startPoint,
                  let endPoint   = chartData.barStyle.colour.endPoint {
            
            let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
            
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                GeometryReader { geo in
                    RangedBarChartStopsCell(chartData : chartData,
                                            dataPoint : dataPoint,
                                            stops     : safeStops,
                                            startPoint: startPoint,
                                            endPoint  : endPoint,
                                            barSize   : geo.frame(in: .local))
                }
            }
        }
    }
}

internal struct RangedBarChartDataPointSubView<CD:RangedBarChartData>: View {

    private let chartData : CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        
        ForEach(chartData.dataSets.dataPoints) { dataPoint in
            GeometryReader { geo in
                if dataPoint.colour.colourType == .colour,
                   let colour = dataPoint.colour.colour {
                    
                    RangedBarChartColourCell(chartData : chartData,
                                             dataPoint : dataPoint,
                                             colour    : colour,
                                             barSize   : geo.frame(in: .local))
                    
                } else if dataPoint.colour.colourType == .gradientColour,
                          let colours    = dataPoint.colour.colours,
                          let startPoint = dataPoint.colour.startPoint,
                          let endPoint   = dataPoint.colour.endPoint {
                    
                    RangedBarChartColoursCell(chartData : chartData,
                                              dataPoint : dataPoint,
                                              colours   : colours,
                                              startPoint: startPoint,
                                              endPoint  : endPoint,
                                              barSize   : geo.frame(in: .local))
                } else if dataPoint.colour.colourType == .gradientStops,
                          let stops      = dataPoint.colour.stops,
                          let startPoint = dataPoint.colour.startPoint,
                          let endPoint   = dataPoint.colour.endPoint {
                    let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                    
                    RangedBarChartStopsCell(chartData : chartData,
                                            dataPoint : dataPoint,
                                            stops     : safeStops,
                                            startPoint: startPoint,
                                            endPoint  : endPoint,
                                            barSize   : geo.frame(in: .local))
                }
            }
        }
    }
}

internal struct RangedBarChartColourCell<CD:RangedBarChartData>: View {
     
    private let chartData: CD
    private let dataPoint: CD.Set.DataPoint
    private let colour   : Color
    private let barSize  : CGRect
    
    internal init(chartData : CD,
                  dataPoint : CD.Set.DataPoint,
                  colour    : Color,
                  barSize   : CGRect
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.colour    = colour
        self.barSize   = barSize
    }
    
    @State private var startAnimation : Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.bottom)
            .fill(colour)
            
            .scaleEffect(y: startAnimation ? CGFloat((dataPoint.upperValue - dataPoint.lowerValue) / chartData.range) : 0, anchor: .center)
            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
            .position(x: barSize.midX,
                      y: chartData.getBarPositionX(dataPoint: dataPoint, height: barSize.height))
            
            .background(Color(.gray).opacity(0.000000001))
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
            .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
    }
}


internal struct RangedBarChartColoursCell<CD:RangedBarChartData>: View {
     
    private let chartData  : CD
    private let dataPoint  : CD.Set.DataPoint
    private let colours    : [Color]
    private let startPoint : UnitPoint
    private let endPoint   : UnitPoint
    private let barSize    : CGRect
    
    internal init(chartData : CD,
                  dataPoint : CD.Set.DataPoint,
                  colours   : [Color],
                  startPoint: UnitPoint,
                  endPoint  : UnitPoint,
                  barSize   : CGRect
    ) {
        self.chartData  = chartData
        self.dataPoint  = dataPoint
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.barSize    = barSize
    }
    
    @State private var startAnimation : Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.bottom)
            .fill(LinearGradient(gradient   : Gradient(colors: colours),
                                 startPoint : startPoint,
                                 endPoint   : endPoint))

            .scaleEffect(y: startAnimation ? CGFloat((dataPoint.upperValue - dataPoint.lowerValue) / chartData.range) : 0, anchor: .center)
            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
            .position(x: barSize.midX,
                      y: chartData.getBarPositionX(dataPoint: dataPoint, height: barSize.height))

            .background(Color(.gray).opacity(0.000000001))
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
            .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
    }
}

internal struct RangedBarChartStopsCell<CD:RangedBarChartData>: View {
     
    private let chartData  : CD
    private let dataPoint  : CD.Set.DataPoint
    private let stops      : [Gradient.Stop]
    private let startPoint : UnitPoint
    private let endPoint   : UnitPoint
    private let barSize    : CGRect
    
    internal init(chartData : CD,
                  dataPoint : CD.Set.DataPoint,
                  stops     : [Gradient.Stop],
                  startPoint: UnitPoint,
                  endPoint  : UnitPoint,
                  barSize   : CGRect
    ) {
        self.chartData  = chartData
        self.dataPoint  = dataPoint
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.barSize    = barSize
    }
    
    @State private var startAnimation : Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.bottom)
            .fill(LinearGradient(gradient   : Gradient(stops: stops),
                                 startPoint : startPoint,
                                 endPoint   : endPoint))
            
            .scaleEffect(y: startAnimation ? CGFloat((dataPoint.upperValue - dataPoint.lowerValue) / chartData.range) : 0, anchor: .center)
            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
            .position(x: barSize.midX,
                      y: chartData.getBarPositionX(dataPoint: dataPoint, height: barSize.height))
            
            .background(Color(.gray).opacity(0.000000001))
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
            .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
    }
}
