//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

/// Configurable Point of interest
internal struct YAxisPOI<T>: ViewModifier where T: LineAndBarChartData {
        
    @ObservedObject var chartData: T
    
    private let uuid = UUID()
    
    private let markerName  : String
    private var markerValue : Double
    private let lineColour  : Color
    private let strokeStyle : StrokeStyle
    
    private let labelPosition   : DisplayValue
    private let labelColour     : Color
    private let labelBackground : Color
    
    private let range       : Double
    private let minValue    : Double
    private let maxValue    : Double
        
    internal init(chartData      : T,
                  markerName     : String,
                  markerValue    : Double = 0,
                  labelPosition  : DisplayValue,
                  labelColour    : Color,
                  labelBackground: Color,
                  lineColour     : Color,
                  strokeStyle    : StrokeStyle,
                  isAverage      : Bool
    ) {
        self.chartData   = chartData
        self.markerName  = markerName
        self.lineColour  = lineColour
        self.strokeStyle = strokeStyle
        
        self.labelPosition   = labelPosition
        self.labelColour     = labelColour
        self.labelBackground = labelBackground
        
        self.markerValue = isAverage ? chartData.getAverage() : markerValue
        self.maxValue    = chartData.getMaxValue()
        self.range       = chartData.getRange()
        self.minValue    = chartData.getMinValue()
    }
    
    @State private var startAnimation : Bool = false
    
    internal func body(content: Content) -> some View {
        ZStack {
            if chartData.isGreaterThanTwo() {
                content
                marker
                valueLabel
            } else { content }
        }
        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = true
        }
        .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = false
        }
        .onAppear {
            if !chartData.legends.contains(where: { $0.legend == markerName }) { // init twice
                chartData.legends.append(LegendData(id          : uuid,
                                                    legend      : markerName,
                                                    colour      : lineColour,
                                                    strokeStyle : Stroke.strokeStyleToStroke(strokeStyle: strokeStyle),
                                                    prioity     : 2,
                                                    chartType   : .line))
            }
        }
    }
    
    var marker: some View {
        Marker(value        : markerValue,
               range        : range,
               minValue     : minValue,
               maxValue     : maxValue,
               chartType    : chartData.chartType.chartType)
            .trim(to: startAnimation ? 1 : 0)
            .stroke(lineColour, style: strokeStyle)
    }
    
    var valueLabel: some View {
        GeometryReader { geo in
            
            switch labelPosition {
            case .none:
                
                EmptyView()
                
            case .yAxis(specifier: let specifier):
                
                Text("\(markerValue, specifier: specifier)")
                    .font(.caption)
                    .foregroundColor(labelColour)
                    .padding(4)
                    .background(Color.blue)
                    .clipShape(LabelShape())
                    .overlay(LabelShape()
                                .stroke(lineColour)
                    )
                    .ifElse(self.chartData.chartStyle.yAxisLabelPosition == .leading, if: {
                        $0.position(x: -18,
                                    y: getYPoint(chartType: chartData.chartType.chartType, chartSize: geo))
                    }, else: {
                        $0.position(x: geo.size.width + 18,
                                    y: getYPoint(chartType: chartData.chartType.chartType, chartSize: geo))
                    })
                    
                
            case .center(specifier: let specifier):
                
                Text("\(markerValue, specifier: specifier)")
                    .font(.caption)
                    .foregroundColor(labelColour)
                    .padding()
                    .background(labelBackground)
                    .clipShape(DiamondShape())
                    .overlay(DiamondShape()
                                .stroke(lineColour, style: strokeStyle)
                    )
                    .position(x: startAnimation ? geo.size.width / 2 : 0,
                              y: getYPoint(chartType: chartData.chartType.chartType, chartSize: geo))
                    .opacity(startAnimation ? 1 : 0)
                    .animation(chartData.chartStyle.globalAnimation.speed(2))
            }
        }
    }
    
    func getYPoint(chartType: ChartType, chartSize: GeometryProxy) -> CGFloat {
        switch chartData.chartType.chartType {
        case .line:
            let y = chartSize.size.height / CGFloat(range)
           return (CGFloat(markerValue - minValue) * -y) + chartSize.size.height
        case .bar:
            let y = chartSize.size.height / CGFloat(maxValue)
            return  chartSize.size.height - CGFloat(markerValue) * y
        case .pie:
            return 0
        }
    }
}

extension View {
    /**
     Horizontal line marking a custom value
     
     Shows a marker line at a specified value.
     
     # Example
     ```
     .yAxisPOI(chartData: data,
                  markerName: "Marker",
                  markerValue: 110,
                  labelPosition: .center(specifier: "%.0f"),
                  labelColour: Color.white,
                  labelBackground: Color.red,
                  lineColour: .blue,
                  strokeStyle: StrokeStyle(lineWidth: 2,
                                           lineCap: .round,
                                           lineJoin: .round,
                                           miterLimit: 10,
                                           dash: [8],
                                           dashPhase: 0))
     ```
     
     - Requires:
     Chart Data to conform to LineAndBarChartData.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Bar Chart
     - Grouped Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
        - chartData: Chart data model.
        - markerName: Title of marker, for the legend.
        - markerValue: Value to mark
        - labelPosition: Option to display the markers’ value inline with the marker.
        - labelColour: Colour of the`Text`.
        - labelBackground: Colour of the background.
        - lineColour: Line Colour.
        - strokeStyle: Style of Stroke.
     - Returns: A  new view containing the chart with a marker line at a specified value.
     
     - Tag: YAxisPOI
    */
    public func yAxisPOI<T:LineAndBarChartData>(chartData      : T,
                                                markerName     : String,
                                                markerValue    : Double,
                                                labelPosition  : DisplayValue = .center(specifier: "%.0f"),
                                                labelColour    : Color        = Color.primary,
                                                labelBackground: Color        = Color.systemsBackground,
                                                lineColour     : Color        = Color(.blue),
                                                strokeStyle    : StrokeStyle  = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(chartData      : chartData,
                               markerName     : markerName,
                               markerValue    : markerValue,
                               labelPosition  : labelPosition,
                               labelColour    : labelColour,
                               labelBackground: labelBackground,
                               lineColour     : lineColour,
                               strokeStyle    : strokeStyle,
                               isAverage      : false))
    }
    
    
    /**
     Horizontal line marking the average
     
     Shows a marker line at the average of all the data points within
     the relevant data set(s).
     
     # Example
     ```
     .averageLine(chartData: data,
                  markerName: "Average",
                  labelPosition: .center(specifier: "%.0f"),
                  labelColour: Color.white,
                  labelBackground: Color.red,
                  lineColour: .primary,
                  strokeStyle: StrokeStyle(lineWidth: 2,
                                           lineCap: .round,
                                           lineJoin: .round,
                                           miterLimit: 10,
                                           dash: [8],
                                           dashPhase: 0))
     ```
     
     - Requires:
     Chart Data to conform to LineAndBarChartData.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Bar Chart
     - Grouped Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
        - chartData: Chart data model.
        - markerName: Title of marker, for the legend.
        - labelPosition: Option to display the markers’ value inline with the marker.
        - labelColour: Colour of the`Text`.
        - labelBackground: Colour of the background.
        - lineColour: Line Colour.
        - strokeStyle: Style of Stroke.
     - Returns: A  new view containing the chart with a marker line at the average.
     
    - Tag: AverageLine
    */
    public func averageLine<T:LineAndBarChartData>(chartData      : T,
                                                   markerName     : String        = "Average",
                                                   labelPosition  : DisplayValue  = .yAxis(specifier: "%.0f"),
                                                   labelColour    : Color         = Color.primary,
                                                   labelBackground: Color         = Color.systemsBackground,
                                                   lineColour     : Color         = Color.primary,
                                                   strokeStyle    : StrokeStyle   = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(chartData      : chartData,
                               markerName     : markerName,
                               labelPosition  : labelPosition,
                               labelColour    : labelColour,
                               labelBackground: labelBackground,
                               lineColour     : lineColour,
                               strokeStyle    : strokeStyle,
                               isAverage      : true))
    }
}
