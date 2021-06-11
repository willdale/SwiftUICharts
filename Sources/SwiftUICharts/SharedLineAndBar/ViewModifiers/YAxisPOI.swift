//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

/**
 Configurable Point of interest
 */
internal struct YAxisPOI<T>: ViewModifier where T: CTLineBarChartDataProtocol & GetDataProtocol & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: T
    
    private let uuid: UUID = UUID()
    
    private let markerName: String
    private var markerValue: Double
    private let lineColour: Color
    private let strokeStyle: StrokeStyle
    
    private let labelPosition: DisplayValue
    private let labelFont: Font
    private let labelColour: Color
    private let labelBackground: Color
    
    private let range: Double
    private let minValue: Double
    private let maxValue: Double
    
    internal init(
        chartData: T,
        markerName: String,
        markerValue: Double = 0,
        labelPosition: DisplayValue,
        labelFont: Font,
        labelColour: Color,
        labelBackground: Color,
        lineColour: Color,
        strokeStyle: StrokeStyle,
        isAverage: Bool
    ) {
        self.chartData = chartData
        self.markerName = markerName
        self.lineColour = lineColour
        self.strokeStyle = strokeStyle
        
        self.labelPosition = labelPosition
        self.labelFont = labelFont
        self.labelColour = labelColour
        self.labelBackground = labelBackground
        
        self.markerValue = isAverage ? chartData.average : markerValue
        self.maxValue = chartData.maxValue
        self.range = chartData.range
        self.minValue = chartData.minValue
        
        self.setupPOILegends()
    }
    
    @State private var startAnimation: Bool = false
    
    internal func body(content: Content) -> some View {
        ZStack {
            if chartData.isGreaterThanTwo() {
                content
                chartData.poiMarker(value: markerValue,
                                    range: range,
                                    minValue: minValue)
                    .trim(to: startAnimation ? 1 : 0)
                    .stroke(lineColour, style: strokeStyle)
                
                GeometryReader { geo in
                    switch labelPosition {
                    case .none:
                        EmptyView()
                    case .yAxis(specifier: let specifier):
                        ValueLabelYAxisSubView(chartData: chartData,
                                               markerValue: markerValue,
                                               specifier: specifier,
                                               labelFont: labelFont,
                                               labelColour: labelColour,
                                               labelBackground: labelBackground,
                                               lineColour: lineColour)
                            
                            .position(chartData.poiValueLabelPositionAxis(frame: geo.frame(in: .local), markerValue: markerValue, minValue: minValue, range: range))
                            
                            .accessibilityLabel(Text("P O I Marker"))
                            .accessibilityValue(Text("\(markerName), \(markerValue, specifier: specifier)"))
                    case .center(specifier: let specifier):
                        ValueLabelCenterSubView(chartData: chartData,
                                                markerValue: markerValue,
                                                specifier: specifier,
                                                labelFont: labelFont,
                                                labelColour: labelColour,
                                                labelBackground: labelBackground,
                                                lineColour: lineColour,
                                                strokeStyle: strokeStyle)
                            
                            .position(chartData.poiValueLabelPositionCenter(frame: geo.frame(in: .local), markerValue: markerValue, minValue: minValue, range: range))
                            
                            .accessibilityLabel(Text("P O I Marker"))
                            .accessibilityValue(Text("\(markerName), \(markerValue, specifier: specifier)"))
                    }
                }
                .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = true
                }
                .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = false
                }
            } else { content }
        }
    }
    
    private func setupPOILegends() {
        if !chartData.legends.contains(where: { $0.legend == markerName }) { // init twice
            chartData.legends.append(LegendData(id: uuid,
                                                legend: markerName,
                                                colour: ColourStyle(colour: lineColour),
                                                strokeStyle: strokeStyle.toStroke(),
                                                prioity: 2,
                                                chartType: .line))
        }
    }
}

extension View {
    /**
     Horizontal line marking a custom value.
     
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
     
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     # Available for:
     
     - Line Chart
     - Multi Line Chart
     - Filled Line Chart
     - Ranged Line Chart
     - Bar Chart
     - Grouped Bar Chart
     - Stacked Bar Chart
     - Ranged Bar Chart
     
     # Unavailable for:
     
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
        - chartData: Chart data model.
        - markerName: Title of marker, for the legend.
        - markerValue: Value to mark
        - labelPosition: Option to display the markers’ value inline with the marker.
        - labelFont: Font for the label.
        - labelColour: Colour of the `Text`.
        - labelBackground: Colour of the background.
        - lineColour: Line Colour.
        - strokeStyle: Style of Stroke.
     - Returns: A  new view containing the chart with a marker line at a specified value.
     */
    public func yAxisPOI<T:CTLineBarChartDataProtocol & GetDataProtocol & PointOfInterestProtocol>(
        chartData: T,
        markerName: String,
        markerValue: Double,
        labelPosition: DisplayValue = .center(specifier: "%.0f"),
        labelFont: Font = .caption,
        labelColour: Color = Color.primary,
        labelBackground: Color = Color.systemsBackground,
        lineColour: Color = Color(.blue),
        strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(chartData: chartData,
                               markerName: markerName,
                               markerValue: markerValue,
                               labelPosition: labelPosition,
                               labelFont: labelFont,
                               labelColour: labelColour,
                               labelBackground: labelBackground,
                               lineColour: lineColour,
                               strokeStyle: strokeStyle,
                               isAverage: false))
    }
    
    
    /**
     Horizontal line marking the average.
     
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
     
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     # Available for:
     
     - Line Chart
     - Multi Line Chart
     - Filled Line Chart
     - Ranged Line Chart
     - Bar Chart
     - Grouped Bar Chart
     - Stacked Bar Chart
     - Ranged Bar Chart
     
     # Unavailable for:
     
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
        - chartData: Chart data model.
        - markerName: Title of marker, for the legend.
        - labelPosition: Option to display the markers’ value inline with the marker.
        - labelFont: Font for the label.
        - labelColour: Colour of the `Text`.
        - labelBackground: Colour of the background.
        - lineColour: Line Colour.
        - strokeStyle: Style of Stroke.
     - Returns: A  new view containing the chart with a marker line at the average.
     */
    public func averageLine<T:CTLineBarChartDataProtocol & GetDataProtocol & PointOfInterestProtocol>(
        chartData: T,
        markerName: String = "Average",
        labelPosition: DisplayValue = .yAxis(specifier: "%.0f"),
        labelFont: Font = .caption,
        labelColour: Color = Color.primary,
        labelBackground: Color = Color.systemsBackground,
        lineColour: Color = Color.primary,
        strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(chartData: chartData,
                               markerName: markerName,
                               labelPosition: labelPosition,
                               labelFont: labelFont,
                               labelColour: labelColour,
                               labelBackground: labelBackground,
                               lineColour: lineColour,
                               strokeStyle: strokeStyle,
                               isAverage: true))
    }
}
