//
//  ValueLabelYAxisSubView.swift
//  
//
//  Created by Will Dale on 27/02/2021.
//

import SwiftUI

internal struct ValueLabelYAxisSubView<T>: View where T: CTLineBarChartDataProtocol & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: T
    private let markerValue: Double
    private let specifier: String
    private let labelFont: Font
    private let labelColour: Color
    private let labelBackground: Color
    private let lineColour: Color
    
    internal init(
        chartData: T,
        markerValue: Double,
        specifier: String,
        labelFont: Font,
        labelColour: Color,
        labelBackground: Color,
        lineColour: Color
    ) {
        self.chartData = chartData
        self.markerValue = markerValue
        self.specifier = specifier
        self.labelFont = labelFont
        self.labelColour = labelColour
        self.labelBackground = labelBackground
        self.lineColour = lineColour
    }
    
    var body: some View {
        chartData.poiLabelAxis(markerValue: markerValue,
                               specifier: specifier,
                               labelFont: labelFont,
                               labelColour: labelColour,
                               labelBackground: labelBackground,
                               lineColour: lineColour)
    }
}
