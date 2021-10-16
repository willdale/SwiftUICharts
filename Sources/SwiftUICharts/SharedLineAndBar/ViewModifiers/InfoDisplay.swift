//
//  InfoDisplay.swift
//  
//
//  Created by Will Dale on 02/10/2021.
//

import SwiftUI

public typealias InfoData = CTChartData & Publishable

public protocol InfoDisplayable {
    associatedtype Content: View
    associatedtype Data: InfoData
    
    var chartData: Data { get set }
    var content: Content { get }
}

internal struct InfoDisplay<ChartData, Info>: ViewModifier
where ChartData: InfoData, Info: InfoDisplayable {
    
    @ObservedObject private var chartData: ChartData
    var infoView: Info
    
    var position: (_ touchLocation: CGPoint, _ chartSize: CGRect) -> CGPoint
        
    internal init(
        chartData: ChartData,
        infoView: Info,
        position: @escaping (_ touchLocation: CGPoint, _ chartSize: CGRect) -> CGPoint
    ) {
        self.chartData = chartData
        self.infoView = infoView
        self.position = position
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            infoView.content
                .position(position(chartData.infoView.touchLocation, chartData.infoView.chartSize))
                .zIndex(1)
        }
    }
}

// MARK: - Extension
extension View {
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplay<ChartData, Info>(
        chartData: ChartData,
        infoView: Info,
        position: @escaping (_ touchLocation: CGPoint, _ chartSize: CGRect) -> CGPoint
    ) -> some View
    where ChartData: InfoData, Info: InfoDisplayable {
        self.modifier(InfoDisplay(chartData: chartData, infoView: infoView, position: position))
    }
    
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplay<ChartData, S>(
       _ infoBox: InfoBoxType<ChartData>,
       style: InfoBoxStyle = .bordered,
       shape: S = RoundedRectangle(cornerRadius: 5.0, style: .continuous) as! S
    ) -> some View
    where ChartData: CTLineBarChartDataProtocol & InfoData,
          S: Shape {
        infoBox.modifier(of: self, with: style, and: shape)
    }
    
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplay<ChartData>(
       _ infoBox: InfoBoxType<ChartData>,
       style: InfoBoxStyle = .bordered
    ) -> some View
    where ChartData: CTLineBarChartDataProtocol & InfoData {
        infoBox.modifier(of: self, with: style, and: RoundedRectangle(cornerRadius: 5.0, style: .continuous))
    }
}

// MARK: Info Display Spacer
internal struct InfoDisplaySpacer: ViewModifier {
    
    let height: CGFloat?
    
    func body(content: Content) -> some View {
        VStack {
            Spacer()
                .frame(height: height)
            content
        }
    }
    
}
// MARK: - Extension
extension View {
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplaySpacer(height: CGFloat?) -> some View {
        self.modifier(InfoDisplaySpacer(height: height))
    }
}
