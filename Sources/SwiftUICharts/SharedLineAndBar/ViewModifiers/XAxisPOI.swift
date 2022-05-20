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
    private let labelBorderColor: Color
    
    private let customLabelShape: CustomLabelShape?
    private let padding: CGFloat?
    
    private let addToLegends: Bool
    
    internal init(
        chartData: T,
        markerName: String,
        markerValue: Int,
        dataPointCount: Int,
        lineColour: Color,
        labelBorderColor: Color?,
        strokeStyle: StrokeStyle,
        
        labelPosition: DisplayValue,
        labelFont: Font,
        labelColour: Color,
        labelBackground: Color,
        
        customLabelShape: CustomLabelShape?,
        padding: CGFloat?,
        
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
        self.labelBorderColor = labelBorderColor ?? lineColour
        
        self.customLabelShape = customLabelShape
        self.padding = padding
        
        self.addToLegends = addToLegends
        
        self.setupPOILegends()
    }
    
    @State private var startAnimation: Bool = false
    
    internal func body(content: Content) -> some View {
        ZStack {
            if chartData.isGreaterThanTwo() {
                content
                chartData.poiAbscissaMarker(markerValue: markerValue, dataPointCount: dataPointCount)
                    .trim(to: animationValue)
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
                                                       labelBorderColor: labelBorderColor,
                                                       customLabelShape: customLabelShape,
                                                       padding: padding)
                            .position(chartData.poiAbscissaValueLabelPositionAxis(frame: geo.frame(in: .local),
                                                                                  markerValue: markerValue,
                                                                                  count: dataPointCount))
                            .accessibilityLabel(LocalizedStringKey("P-O-I-Marker"))
                            .accessibilityValue(Text(LocalizedStringKey(String(format: NSLocalizedString("\(self.markerName) %@", comment: ""), "\(markerValue)"))))

                    case .center:
                        
                        chartData.poiAbscissaLabelCenter(marker: markerName,
                                                         labelFont: labelFont,
                                                         labelColour: labelColour,
                                                         labelBackground: labelBackground,
                                                         labelBorderColor: labelBorderColor,
                                                         strokeStyle: strokeStyle,
                                                         customLabelShape: customLabelShape,
                                                         padding: padding)
                            .position(chartData.poiAbscissaValueLabelPositionCenter(frame: geo.frame(in: .local),
                                                                                    markerValue: markerValue,
                                                                                    count: dataPointCount))
                            .accessibilityLabel(LocalizedStringKey("P-O-I-Marker"))
                            .accessibilityValue(LocalizedStringKey(String(format: NSLocalizedString("\(self.markerName) %@", comment: ""), "\(markerValue)")))

                    case .position(location: let location, _, _):
                        
                        chartData.poiAbscissaLabelPosition(location: location,
                                                           marker: markerName,
                                                           labelFont: labelFont,
                                                           labelColour: labelColour,
                                                           labelBackground: labelBackground,
                                                           labelBorderColor: labelBorderColor,
                                                           strokeStyle: strokeStyle,
                                                           customLabelShape: customLabelShape,
                                                           padding: padding)
                            .frame(width: geo.frame(in: .local).width, height: geo.frame(in: .local).height)
                            .fixedSize()
                            .position(chartData.poiAbscissaValueLabelRelativePosition(frame: geo.frame(in: .local),
                                                                                    markerValue: markerValue,
                                                                                    count: dataPointCount))
                            .accessibilityLabel(LocalizedStringKey("P-O-I-Marker"))
                            .accessibilityValue(LocalizedStringKey(String(format: NSLocalizedString("\(self.markerName) %@", comment: ""), "\(markerValue)")))
                    }
                }
                .animateOnAppear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = true
                }
                .animateOnDisappear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
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
    
    var animationValue: CGFloat {
        if chartData.disableAnimation {
            return 1
        } else {
            return startAnimation ? 1 : 0
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
        - labelBorderColor: Custom Color for the label border, if not provided lineColor will be used.
        - strokeStyle: Style of Stroke.
        - customLabelShape: Custom Shape for POI Label.
        - padding: Custom Padding between Shape and `Text`.
        - addToLegends: Whether or not to add this to the legends.
     - Returns: A  new view containing the chart with a marker line at a specified value.
     */
    public func xAxisPOI<T:CTLineBarChartDataProtocol & GetDataProtocol & PointOfInterestProtocol>(
        chartData: T,
        markerName: String,
        markerValue: Int,
        dataPointCount: Int,
        lineColour: Color = Color(.blue),
        labelBorderColor: Color? = nil,
        strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0),
        labelPosition: DisplayValue = .center(specifier: "%.0f"),
        labelFont: Font = .caption,
        labelColour: Color = Color.primary,
        labelBackground: Color = Color.systemsBackground,
        customLabelShape: CustomLabelShape? = nil,
        padding: CGFloat? = nil,
        addToLegends: Bool = true
    ) -> some View {
        self.modifier(XAxisPOI(chartData: chartData,
                               markerName: markerName,
                               markerValue: markerValue,
                               dataPointCount: dataPointCount,
                               lineColour: lineColour,
                               labelBorderColor: labelBorderColor,
                               strokeStyle: strokeStyle,
                               labelPosition: labelPosition,
                               labelFont: labelFont,
                               labelColour: labelColour,
                               labelBackground: labelBackground,
                               customLabelShape: customLabelShape,
                               padding: padding,
                               addToLegends: addToLegends))
    }
}


