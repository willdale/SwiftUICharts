//
//  HeaderBox.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import SwiftUI

internal struct HeaderBox: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    let showTitle   : Bool
    let showSubtitle: Bool
    
    init(showTitle      : Bool = true,
         showSubtitle   : Bool = true
    ) {
        self.showTitle     = showTitle
        self.showSubtitle  = showSubtitle
    }
    
    var titleBox: some View {
        VStack(alignment: .leading) {
            if showTitle, let title = chartData.metadata?.title {
                Text(title)
                    .font(.title3)
            }  else {
                Text("")
                    .font(.title3)
            }
            if showSubtitle, let subtitle = chartData.metadata?.subtitle {
                Text(subtitle)
                    .font(.subheadline)
            } else {
                Text("")
                    .font(.subheadline)
            }
        }
    }
    
    var touchOverlay: some View {
        VStack(alignment: .trailing) {
            if chartData.viewData.isTouchCurrent, let value = chartData.viewData.touchOverlayInfo?.value {
                Text("\(value, specifier: chartData.viewData.touchSpecifier)")
                    .font(.title3)
            } else {
                Text("")
                    .font(.title3)
            }
            if chartData.viewData.isTouchCurrent, let label = chartData.viewData.touchOverlayInfo?.pointDescription {
                Text("\(label)")
                    .font(.subheadline)
            } else {
                Text("")
                    .font(.subheadline)
            }
        }
    }
    
    @ViewBuilder
    internal func body(content: Content) -> some View {
        
        #if !os(tvOS)
        if chartData.chartStyle.infoBoxPlacement == .floating {
            
            VStack(alignment: .leading) {
                titleBox
                content
            }
            
        } else if chartData.chartStyle.infoBoxPlacement == .header {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        titleBox
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                        touchOverlay
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                content
            }
        }
        #elseif os(tvOS)
        VStack(alignment: .leading) {
            titleBox
            content
        }
        #endif
        }
}

extension View {
    
    /// Displays the metadata about the chart
    /// - Returns: Chart title and subtitle.
    public func headerBox() -> some View {
        self.modifier(HeaderBox())
    }
}
