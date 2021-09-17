//
//  XAxisPOI.swift
//  
//
//  Created by Will Dale on 19/06/2021.
//

import SwiftUI

/**
 Configurable Point of interest
 */
internal struct XAxisPOI<T>: ViewModifier where T: CTLineBarChartDataProtocol & GetDataProtocol & PointOfInterestProtocol {
    
    private let uuid: UUID = UUID()
    
    @ObservedObject private var chartData: T
    private let markerName: String
    private let markerValue: Int
    private let dataPointCount: Int
    
    private let lineColour: Color
    private let strokeStyle: StrokeStyle
    
    private let labelPosition: DisplayValue
    private let labelFont: Font
    private let labelColour: Color
    private let labelBackground: Color
    
    private let addToLegends: Bool
    
    internal init(
        chartData: T,
        markerName: String,
        markerValue: Int,
        dataPointCount: Int,
        lineColour: Color,
        strokeStyle: StrokeStyle,
        
        labelPosition: DisplayValue,
        labelFont: Font,
        labelColour: Color,
        labelBackground: Color,
        
        addToLegends: Bool
    ) {
        self.chartData = chartData
        self.markerName = markerName
        self.markerValue = markerValue
        self.dataPointCount = dataPointCount
        
        self.lineColour = lineColour
        self.strokeStyle = strokeStyle
        
        self.labelPosition = labelPosition
        self.labelFont = labelFont
        self.labelColour = labelColour
        self.labelBackground = labelBackground
        
        self.addToLegends = addToLegends
        
        self.setupPOILegends()
    }
    
    @State private var startAnimation: Bool = false
    
    internal func body(content: Content) -> some View {
        ZStack {
            if chartData.isGreaterThanTwo() {
                content
                chartData.poiAbscissaMarker(markerValue: markerValue, dataPointCount: dataPointCount)
                    .trim(to: startAnimation ? 1 : 0)
                    .stroke(lineColour, style: strokeStyle)
                
                GeometryReader { geo in
                    switch labelPosition {
                    case .none:
                        EmptyView()
                    case .yAxis:
                        
                        chartData.poiAbscissaLabelAxis(marker: markerName,
                                                       labelFont: labelFont,
                                                       labelColour: labelColour,
                                                       labelBackground: labelBackground,
                                                       lineColour: lineColour)
                            .position(chartData.poiAbscissaValueLabelPositionAxis(frame: geo.frame(in: .local),
                                                                                  markerValue: markerValue,
                                                                                  count: dataPointCount))
                            .ctAccessibilityLabel("P-O-I-Marker")
                            .ctAccessibilityValue(String(format: NSLocalizedString("\(self.markerName) %@", comment: ""), "\(markerValue)"))
                                                    
                    case .center:
                        
                        chartData.poiAbscissaLabelCenter(marker: markerName,
                                                         labelFont: labelFont,
                                                         labelColour: labelColour,
                                                         labelBackground: labelBackground,
                                                         lineColour: lineColour,
                                                         strokeStyle: strokeStyle)
                            .position(chartData.poiAbscissaValueLabelPositionCenter(frame: geo.frame(in: .local),
                                                                                    markerValue: markerValue,
                                                                                    count: dataPointCount))
                            
                            .ctAccessibilityLabel("P-O-I-Marker")
                            .ctAccessibilityValue(String(format: NSLocalizedString("\(self.markerName) %@", comment: ""), "\(markerValue)"))
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
        if addToLegends && !chartData.legends.contains(where: { $0.legend == markerName }) { // init twice
            chartData.legends.append(LegendData(id: uuid,
                                                legend: markerName,
                                                colour: ColourStyle(colour: lineColour),
                                                strokeStyle: strokeStyle.toStroke(),
                                                prioity: 2,
                                                chartType: .line))
        }
    }
}


// MARK: - Extension
extension View {
    /**
     Vertical line marking a custom value.
     
     Shows a marker line at a specified value.
     
     
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
        - markerValue: Value to mark.
        - dataPointCount: Total number of data points in data set.
        - labelPosition: Option to display the markers’ value inline with the marker.
        - labelFont: Font for the label.
        - labelColour: Colour of the `Text`.
        - labelBackground: Colour of the background.
        - lineColour: Line Colour.
        - strokeStyle: Style of Stroke.
        - addToLegends: Whether or not to add this to the legends.
     - Returns: A  new view containing the chart with a marker line at a specified value.
     */
    public func xAxisPOI<T:CTLineBarChartDataProtocol & GetDataProtocol & PointOfInterestProtocol>(
        chartData: T,
        markerName: String,
        markerValue: Int,
        dataPointCount: Int,
        lineColour: Color = Color(.blue),
        strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0),
        labelPosition: DisplayValue = .center(specifier: "%.0f"),
        labelFont: Font = .caption,
        labelColour: Color = Color.primary,
        labelBackground: Color = Color.systemsBackground,
        addToLegends: Bool = true
    ) -> some View {
        self.modifier(XAxisPOI(chartData: chartData,
                               markerName: markerName,
                               markerValue: markerValue,
                               dataPointCount: dataPointCount,
                               lineColour: lineColour,
                               strokeStyle: strokeStyle,
                               labelPosition: labelPosition,
                               labelFont: labelFont,
                               labelColour: labelColour,
                               labelBackground: labelBackground,
                               addToLegends: addToLegends))
    }
}

extension View {
    @ViewBuilder
    func iOS13Support<Content14: View, Content13: View>(
        if14 ifTransform: (Self) -> Content14,
        else elseTransform: (Self) -> Content13
    ) -> some View {
        if #available(iOS 14, *) {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
}
/*
 .iOS13Support(if14: {
     $0
 }, else: {
     $0
 })
 */

struct CTAccessibilityLabel: ViewModifier {
    
    private var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 14, *) {
            content
                .accessibilityLabel(LocalizedStringKey(text))
        } else {
            content
                .accessibility(label: Text(LocalizedStringKey(text)))
        }
    }
}

extension View {
    func ctAccessibilityLabel(_ text: String) -> some View {
        self.modifier(CTAccessibilityLabel(text))
    }
}

struct CTAccessibilityValue: ViewModifier {
    
    private var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 14, *) {
            content
                .accessibilityValue(LocalizedStringKey(text))
        } else {
            content
                .accessibility(value: Text(LocalizedStringKey(text)))
        }
    }
}

extension View {
    func ctAccessibilityValue(_ text: String) -> some View {
        self.modifier(CTAccessibilityValue(text))
    }
}
