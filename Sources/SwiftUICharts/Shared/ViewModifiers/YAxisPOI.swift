//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

/// Configurable Point of interest
///
/// This is a mess - tidied up in V2
internal struct YAxisPOI: ViewModifier {
        
    @EnvironmentObject var chartData: ChartData
    
    private let markerName     : String
    private let markerValue    : Double
    private let lineColour     : Color
    private let strokeStyle    : StrokeStyle
    private let labelPosition  : DisplayValue
    private let labelBackground: Color
    private let isAverage      : Bool
        
    internal init(markerName    : String,
                  markerValue   : Double,
                  labelPosition : DisplayValue,
                  labelBackground: Color,
                  lineColour    : Color,
                  strokeStyle   : StrokeStyle,
                  isAverage     : Bool
    ) {
        self.markerName     = markerName
        self.markerValue    = markerValue
        self.labelPosition  = labelPosition
        self.labelBackground = labelBackground
        self.lineColour     = lineColour
        self.strokeStyle    = strokeStyle
        self.isAverage      = isAverage
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            if chartData.dataPoints.count > 2 {
                                
                ZStack {
                    
                    Marker(chartData    : chartData,
                           markerValue  : markerValue,
                           isAverage    : isAverage,
                           chartType    : chartData.viewData.chartType)
                        
                        .stroke(lineColour, style: strokeStyle)
                        .onAppear {
                            if !chartData.legends.contains(where: { $0.legend == markerName }) { // init twice
                                chartData.legends.append(LegendData(legend      : markerName,
                                                                    colour      : lineColour,
                                                                    strokeStyle : Stroke.strokeStyleToStroke(strokeStyle: strokeStyle),
                                                                    prioity     : 2,
                                                                    chartType   : .line))
                            }
                        }
                    ValuePositionView(chartData     : chartData,
                                      markerValue   : markerValue,
                                      lineColour    : lineColour,
                                      strokeStyle   : strokeStyle,
                                      labelPosition : labelPosition,
                                      labelBackground: labelBackground,
                                      isAverage     : isAverage)
                }
            }
        }
    }
}

internal struct ValuePositionView: View {
    
    private let chartData       : ChartData
    private let minValue        : Double
    private let range           : Double
    
    private let markerValue     : Double
    private let lineColour      : Color
    private let strokeStyle     : StrokeStyle
    
    private let labelPosition   : DisplayValue
    private let labelBackground : Color
    
    private let isAverage       : Bool
    
    internal init(chartData       : ChartData,
                  markerValue     : Double,
                  lineColour      : Color,
                  strokeStyle     : StrokeStyle,
                  labelPosition   : DisplayValue,
                  labelBackground : Color,
                  isAverage       : Bool
    ) {
        self.chartData       = chartData
        self.markerValue     = markerValue
        self.lineColour      = lineColour
        self.strokeStyle     = strokeStyle
        self.labelPosition   = labelPosition
        self.labelBackground = labelBackground
        self.isAverage       = isAverage
        
        switch chartData.lineStyle.baseline {
        case .minimumValue:
            self.minValue = chartData.minValue()
            self.range    = chartData.range()
        case .minimumWithMaximum(of: let value):
            self.minValue = min(chartData.minValue(), value)
            self.range    = chartData.maxValue() - min(chartData.minValue(), value)
        case .zero:
            self.minValue = 0
            self.range    = chartData.maxValue()
        }
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            let value   : Double = isAverage ? chartData.average() : markerValue
            
            let y = geo.size.height / CGFloat(range)
            let pointY = (CGFloat(value - minValue) * -y) + geo.size.height
            
            switch labelPosition {
            case .none:
                
                EmptyView()
                
            case .yAxis(specifier: let specifier):
                
                Text("\(value, specifier: specifier)")
                    .padding(4)
                    .background(labelBackground)
                    .font(.caption)
                    .ifElse(self.chartData.chartStyle.yAxisLabelPosition == .leading, if: {
                        $0.position(x: -18,
                                    y: pointY)
                    }, else: {
                        $0.position(x: geo.size.width + 18,
                                    y: pointY)
                    })
                
            case .center(specifier: let specifier):
                
                Text("\(value, specifier: specifier)")
                    .font(.caption)
                    .padding()
                    .background(labelBackground)
                    .clipShape(DiamondShape())
                    .overlay(DiamondShape()
                                .stroke(lineColour, style: strokeStyle)
                    )
                    .position(x: geo.size.width / 2, y: pointY)
            }
        }
    }
}

extension View {
    /// Shows a marker line at chosen point.
    /// - Parameters:
    ///   - markerName: Title of marker, for the legend
    ///   - markerValue : Chosen point.
    ///   - labelPosition: Option to add a label inline with the marker.
    ///   - labelBackground: Background colour for optional label.
    ///   - lineColour: Line Colour
    ///   - strokeStyle: Style of Stroke
    /// - Returns: A marker line at the average of all the data points.
    public func yAxisPOI(markerName     : String,
                         markerValue    : Double,
                         labelPosition  : DisplayValue = .none,
                         labelBackground: Color        = Color(.clear),
                         lineColour     : Color        = Color(.blue),
                         strokeStyle    : StrokeStyle  = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(markerName   : markerName,
                               markerValue  : markerValue,
                               labelPosition: labelPosition,
                               labelBackground: labelBackground,
                               lineColour   : lineColour,
                               strokeStyle  : strokeStyle,
                               isAverage    : false))
    }
    
    
    /// Shows a marker line at the average of all the data points.
    /// - Parameters:
    ///   - markerName: Title of marker, for the legend.
    ///   - labelPosition: Option to add a label inline with the marker.
    ///   - labelBackground: Background colour for optional label.
    ///   - lineColour: Line Colour
    ///   - strokeStyle: Style of Stroke
    /// - Returns: A marker line at the average of all the data points.
    public func averageLine(markerName      : String        = "Average",
                            labelPosition   : DisplayValue  = .none,
                            labelBackground : Color         = Color(.clear),
                            lineColour      : Color         = Color.primary,
                            strokeStyle     : StrokeStyle   = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(markerName   : markerName,
                               markerValue  : 0,
                               labelPosition: labelPosition,
                               labelBackground: labelBackground,
                               lineColour   : lineColour,
                               strokeStyle  : strokeStyle,
                               isAverage    : true))
    }
}
