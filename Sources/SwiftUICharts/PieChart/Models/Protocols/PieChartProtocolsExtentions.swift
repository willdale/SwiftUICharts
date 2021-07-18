//
//  PieChartProtocolExtentions.swift
//  
//
//  Created by Will Dale on 23/02/2021.
//

import SwiftUI

// MARK: - Extentions

extension CTPieDoughnutChartDataProtocol where SetType == PieDataSet, DataPoint == PieChartDataPoint {
    
    /**
     Sets up the data points in a way that can be sent to renderer for drawing.
     
     It configures each data point with startAngle and amount variables in radians.
     */
    internal func makeDataPoints() {
        let total = self.dataSets.dataPoints
            .map(\.value)
            .reduce(0, +)
        var startAngle = -Double.pi / 2
        self.dataSets.dataPoints.indices.forEach { index in
            let amount = .pi * 2 * (self.dataSets.dataPoints[index].value / total)
            self.dataSets.dataPoints[index].amount = amount
            self.dataSets.dataPoints[index].startAngle = startAngle
            startAngle += amount
        }
    }
    
    /**
     Gets the number of degrees around the chart from 'north'.
     
     # Reference
     [Atan2](http://www.cplusplus.com/reference/cmath/atan2/)
     
     [Rotate to north](https://stackoverflow.com/a/25398191)
     
     - Parameters:
     - touchLocation: Current location of the touch.
     - rect: The size of the chart view as the parent view.
     - Returns: Degrees around the chart.
     */
    func degree(from touchLocation: CGPoint, in rect: CGRect) -> CGFloat {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let coordinates = CGPoint(x: touchLocation.x - center.x,
                                  y: touchLocation.y - center.y)
        // -90 is north
        let degrees = atan2(-coordinates.x, -coordinates.y) * CGFloat(180 / Double.pi)
        if (degrees > 0) {
            return 270 - degrees
        } else {
            return -90 - degrees
        }
    }
}

extension CTPieDoughnutChartDataProtocol where Self.SetType.DataPoint.ID == UUID,
                                               Self.SetType: CTSingleDataSetProtocol,
                                               Self.SetType.DataPoint: CTPieDataPoint {
    internal func setupLegends() {
        dataSets.dataPoints.forEach { dataPoint in
            guard let legend = dataPoint.description else { return }
            self.legends.append(LegendData(id: dataPoint.id,
                                           legend: legend,
                                           colour: ColourStyle(colour: dataPoint.colour),
                                           strokeStyle: nil,
                                           prioity: 1,
                                           chartType: .pie))
        }
    }
}

extension View {
    internal func overlay<CD: CTPieDoughnutChartDataProtocol>(
        dataPoint: PieChartDataPoint,
        chartData: CD,
        rect: CGRect
    ) -> some View {
        self
            .overlay(
                Group {
                    switch dataPoint.label {
                    case .none:
                        EmptyView()
                    case .label(let text, let colour, let font, let rFactor):
                        Text(LocalizedStringKey(text))
                            .font(font)
                            .foregroundColor(colour)
                            .position(chartData.getOverlayPosition(rect: rect,
                                                                   startRad: dataPoint.startAngle,
                                                                   amountRad: dataPoint.amount,
                                                                   rFactor: rFactor))
                    case .icon(let name, let colour, let size, let rFactor):
                        Image(systemName: name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size, height: size)
                            .foregroundColor(colour)
                            .position(chartData.getOverlayPosition(rect: rect,
                                                                   startRad: dataPoint.startAngle,
                                                                   amountRad: dataPoint.amount,
                                                                   rFactor: rFactor))
                    }
                }
            )
    }
}

extension CTPieDoughnutChartDataProtocol {
    internal func getOverlayPosition(
        rect: CGRect,
        startRad: Double,
        amountRad: Double,
        rFactor: CGFloat
    ) -> CGPoint {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        let startDegree = (startRad * Double(180 / Double.pi)) + 90
        let amountDegree = amountRad * Double(180 / Double.pi)
        let segmentDegree = (startDegree + (startDegree + amountDegree)) / 2
        let segmentRad = CGFloat.pi * CGFloat(segmentDegree - 90) / 180
        
        let x = center.x + (radius * rFactor) * cos(segmentRad)
        let y = center.y + (radius * rFactor) * sin(segmentRad)
        
        return CGPoint(x: x, y: y)
    }
}
