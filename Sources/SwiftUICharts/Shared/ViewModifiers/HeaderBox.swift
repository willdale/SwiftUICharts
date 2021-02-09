//
//  HeaderBox.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import SwiftUI
 
internal struct HeaderBox<T>: ViewModifier where T: ChartData {
    
    @ObservedObject var chartData: T
    
    init(chartData: T) {
        self.chartData = chartData
    }
    
    var titleBox: some View {
        VStack(alignment: .leading) {
            Text(chartData.metadata.title)
                .font(.title3)
                .foregroundColor(chartData.metadata.titleColour)
            
            Text(chartData.metadata.subtitle)
                .font(.subheadline)
                .foregroundColor(chartData.metadata.subtitleColour)
        }
    }
    
    var touchOverlay: some View {
        VStack(alignment: .trailing) {
            if chartData.infoView.isTouchCurrent {
                ForEach(chartData.infoView.touchOverlayInfo, id: \.self) { info in
                    Text("\(info.value, specifier: chartData.infoView.touchSpecifier)")
                        .font(.title3)
                        .foregroundColor(chartData.chartStyle.infoBoxValueColour)
                    Text("\(info.pointDescription ?? "")")
                        .font(.subheadline)
                        .foregroundColor(chartData.chartStyle.infoBoxDescriptionColor)
                }
            } else {
                Text("")
                    .font(.title3)
                Text("")
                    .font(.subheadline)
            }
        }
    }
    
    
    internal func body(content: Content) -> some View {
        Group {
            #if !os(tvOS)
            if chartData.isGreaterThanTwo() {
                if chartData.getHeaderLocation() == .floating {
                    VStack(alignment: .leading) {
                        titleBox
                        content
                    }
                } else if chartData.getHeaderLocation() == .header {
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            HStack(spacing: 0) {
                                titleBox
                                Spacer()
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            Spacer()
                            HStack(spacing: 0) {
                                Spacer()
                                touchOverlay
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                        }
                        content
                    }
                }
            } else { content }
            #elseif os(tvOS)
            if chartData.isGreaterThanTwo() {
                VStack(alignment: .leading) {
                    titleBox
                    content
                }
            } else { content }
            #endif
        }
    }
}

extension View {
    /**
     Displays the metadata about the chart
     
     Adds a view above the chart that displays the title and subtitle.
     infoBoxPlacement is set to .header then the datapoint info will
     be displayed here as well.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view above
     to display metadata.
     
     - Tag: HeaderBox
     */
    public func headerBox<T:ChartData>(chartData: T) -> some View {
        self.modifier(HeaderBox(chartData: chartData))
    }
}
