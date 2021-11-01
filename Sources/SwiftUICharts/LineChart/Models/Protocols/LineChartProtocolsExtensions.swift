//
//  LineChartProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

// MARK: - Box Location
extension CTLineBarChartDataProtocol {
    public func setBoxLocationation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {        
        var returnPoint: CGFloat = .zero
        if touchLocation < chartSize.minX + (boxFrame.width / 2) {
            returnPoint = chartSize.minX + (boxFrame.width / 2)
        } else if touchLocation > chartSize.maxX - (boxFrame.width / 2) {
            returnPoint = chartSize.maxX - (boxFrame.width / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint + (self.viewData.yAxisLabelWidth.max() ?? 0) + self.viewData.yAxisTitleWidth + (self.viewData.hasYAxisLabels ? 4 : 0) // +4 For Padding
    }
}
extension CTLineBarChartDataProtocol where Self: isHorizontal {
    public func setBoxLocationation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        var returnPoint: CGFloat = .zero
        if touchLocation < chartSize.minY + (boxFrame.height / 2) {
            returnPoint = chartSize.minY + (boxFrame.height / 2)
        } else if touchLocation > chartSize.maxY - (boxFrame.height / 2) {
            returnPoint = chartSize.maxY - (boxFrame.height / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint
    }
}

// MARK: - Markers
extension CTLineChartDataProtocol {
    internal func markerSubView(
        markerData: MarkerData,
        chartSize: CGRect,
        touchLocation: CGPoint
    ) -> some View {
        ForEach(markerData.lineMarkerData, id: \.self) { marker in
            MarkerView.line(lineMarker: marker.markerType,
                            markerData: marker,
                            chartSize: chartSize,
                            touchLocation: touchLocation,
                            dataPoints: marker.dataPoints,
                            lineType: marker.lineType,
                            lineSpacing: marker.lineSpacing,
                            minValue: marker.minValue,
                            range: marker.range,
                            ignoreZero: marker.ignoreZero)
        }
    }
}


// MARK: - Legends
extension CTLineChartDataProtocol where Self.SetType.ID == UUID,
                                        Self.SetType: CTLineChartDataSet {
    internal func setupLegends() {
        lineLegendSetup(dataSet: dataSets)
    }
}

extension CTLineChartDataProtocol where Self.SetType == MultiLineDataSet {
    internal func setupLegends() {
        dataSets.dataSets.forEach { lineLegendSetup(dataSet: $0) }
    }
}

extension CTLineChartDataProtocol {
    internal func lineLegendSetup<DS: CTLineChartDataSet>(dataSet: DS) where DS.ID == UUID {
//        if dataSet.style.lineColour.colourType == .colour,
//           let colour = dataSet.style.lineColour.colour
//        {
//            self.legends.append(LegendData(id: dataSet.id,
//                                           legend: dataSet.legendTitle,
//                                           colour: ColourStyle(colour: colour),
//                                           strokeStyle: dataSet.style.strokeStyle,
//                                           prioity: 1,
//                                           chartType: .line))
//        } else if dataSet.style.lineColour.colourType == .gradientColour,
//                  let colours = dataSet.style.lineColour.colours
//        {
//            self.legends.append(LegendData(id: dataSet.id,
//                                           legend: dataSet.legendTitle,
//                                           colour: ColourStyle(colours: colours,
//                                                               startPoint: .leading,
//                                                               endPoint: .trailing),
//                                           strokeStyle: dataSet.style.strokeStyle,
//                                           prioity: 1,
//                                           chartType: .line))
//        } else if dataSet.style.lineColour.colourType == .gradientStops,
//                  let stops = dataSet.style.lineColour.stops
//        {
//            self.legends.append(LegendData(id: dataSet.id,
//                                           legend: dataSet.legendTitle,
//                                           colour: ColourStyle(stops: stops,
//                                                               startPoint: .leading,
//                                                               endPoint: .trailing),
//                                           strokeStyle: dataSet.style.strokeStyle,
//                                           prioity: 1,
//                                           chartType: .line))
//        }
    }
}

extension CTLineChartDataProtocol where Self.SetType.ID == UUID,
                                        Self.SetType: CTRangedLineChartDataSet,
                                        Self.SetType.Styling: CTRangedLineStyle {
    internal func setupRangeLegends() {
//        if dataSets.style.fillColour.colourType == .colour,
//           let colour = dataSets.style.fillColour.colour
//        {
//            self.legends.append(LegendData(id: UUID(),
//                                           legend: dataSets.legendFillTitle,
//                                           colour: ColourStyle(colour: colour),
//                                           strokeStyle: dataSets.style.strokeStyle,
//                                           prioity: 1,
//                                           chartType: .bar))
//        } else if dataSets.style.fillColour.colourType == .gradientColour,
//                  let colours = dataSets.style.fillColour.colours
//        {
//            self.legends.append(LegendData(id: UUID(),
//                                           legend: dataSets.legendFillTitle,
//                                           colour: ColourStyle(colours: colours,
//                                                               startPoint: .leading,
//                                                               endPoint: .trailing),
//                                           strokeStyle: dataSets.style.strokeStyle,
//                                           prioity: 1,
//                                           chartType: .bar))
//        } else if dataSets.style.fillColour.colourType == .gradientStops,
//                  let stops = dataSets.style.fillColour.stops
//        {
//            self.legends.append(LegendData(id: UUID(),
//                                           legend: dataSets.legendFillTitle,
//                                           colour: ColourStyle(stops: stops,
//                                                               startPoint: .leading,
//                                                               endPoint: .trailing),
//                                           strokeStyle: dataSets.style.strokeStyle,
//                                           prioity: 1,
//                                           chartType: .bar))
//        }
    }
}

// MARK: - Accessibility
extension CTLineChartDataProtocol where SetType: CTLineChartDataSet {
    public func getAccessibility() -> some View {
        ForEach(dataSets.dataPoints.indices, id: \.self) { point in
            AccessibilityRectangle(dataPointCount: self.dataSets.dataPoints.count,
                                   dataPointNo: point)
                .foregroundColor(Color(.gray).opacity(0.000000001))
                .accessibilityLabel(self.accessibilityTitle)
                .accessibilityValue(self.dataSets.dataPoints[point].getCellAccessibilityValue(specifier: self.infoView.touchSpecifier))
        }
    }
}
