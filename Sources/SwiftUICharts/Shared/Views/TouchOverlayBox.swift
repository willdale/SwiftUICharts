//
//  TouchOverlayBox.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

/**
View that displays information from the touch events.
 */
internal struct TouchOverlayBox<T: CTChartData>: View {
    
<<<<<<< HEAD
    private var selectedPoint   : ChartDataPoint?
    private var specifier       : String
    private var units           : Units
    private var ignoreZero      : Bool
=======
    @ObservedObject var chartData: T
>>>>>>> version-2
    
    @Binding private var boxFrame:  CGRect
    
<<<<<<< HEAD
    internal init(selectedPoint  : ChartDataPoint?,
         specifier      : String = "%.0f",
         units          : Units,
         boxFrame       : Binding<CGRect>,
         ignoreZero     : Bool
    ) {
        self.selectedPoint  = selectedPoint
        self.specifier      = specifier
        self.units          = units
        self._boxFrame      = boxFrame
        self.ignoreZero     = ignoreZero
    }
    
    internal var body: some View {
        VStack {
            if ignoreZero && selectedPoint?.value != 0 {
                switch units {
                case .none:
                    Text("\(selectedPoint?.value ?? 0, specifier: specifier)")
                        .font(.subheadline)
                case .prefix(of: let value):
                    Text("\(value) \(selectedPoint?.value ?? 0, specifier: specifier)")
                        .font(.subheadline)
                case .suffix(of: let value):
                    Text("\(selectedPoint?.value ?? 0, specifier: specifier) \(value)")
                        .font(.subheadline)
                }
            } else if !ignoreZero {
                switch units {
                case .none:
                    Text("\(selectedPoint?.value ?? 0, specifier: specifier)")
                        .font(.subheadline)
                case .prefix(of: let value):
                    Text("\(value) \(selectedPoint?.value ?? 0, specifier: specifier)")
                        .font(.subheadline)
                case .suffix(of: let value):
                    Text("\(selectedPoint?.value ?? 0, specifier: specifier) \(value)")
                        .font(.subheadline)
                }
            }
            if let label = selectedPoint?.pointDescription {
                Text(label)
                    .font(.subheadline)
            } else if let label = selectedPoint?.xAxisLabel {
                Text(label)
                    .font(.subheadline)
=======
    internal init(chartData: T,
                  boxFrame : Binding<CGRect>
    ) {
        self.chartData = chartData
        self._boxFrame = boxFrame
    }
    
    internal var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
                
                chartData.infoDescription(info: point)
                    .font(.subheadline)
                    .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                
                chartData.infoValueUnit(info: point)
                    .font(.title3)
                    .foregroundColor(chartData.chartStyle.infoBoxValueColour)

                chartData.infoLegend(info: point)
                    .font(.subheadline)
                    .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                Spacer()
>>>>>>> version-2
            }
        }
        
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                if chartData.infoView.isTouchCurrent {
                    RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                        .fill(chartData.chartStyle.infoBoxBackgroundColour)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                                    .stroke(chartData.chartStyle.infoBoxBorderColour, style: chartData.chartStyle.infoBoxBorderStyle)
                            )
                        .onAppear {
                            self.boxFrame = geo.frame(in: .local)
                        }
                        .onChange(of: geo.frame(in: .local)) { frame in
                            self.boxFrame = frame
                        }
                }
            }
        )
    }
}
