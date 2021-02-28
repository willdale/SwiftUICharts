//
//  TouchOverlayBox.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

internal struct TouchOverlayBox: View {
    
    private var selectedPoint   : ChartDataPoint?
    private var specifier       : String
    private var units           : Units
    private var ignoreZero      : Bool
    
    @Binding private var boxFrame   :  CGRect
    
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
            }
        }
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                ZStack {
                    #if os(iOS)
                    RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                        .shadow(color: Color(.systemGray), radius: 6, x: 0, y: 0)
                    RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                        .fill(Color(.systemBackground))
                    #elseif os(macOS)
                    RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                        .shadow(color: Color(.highlightColor), radius: 6, x: 0, y: 0)
                    RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                        .fill(Color(.windowBackgroundColor))
                    #endif
                    
                }
                .overlay(
                    Group {
                        #if os(iOS)
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(Color.primary, lineWidth: 1)
                        #elseif os(macOS)
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(Color.primary, lineWidth: 2)
                        #endif
                    }
                )
                .onChange(of: geo.frame(in: .local)) { frame in
                    self.boxFrame = frame
                }
            }
        )
    }
}
