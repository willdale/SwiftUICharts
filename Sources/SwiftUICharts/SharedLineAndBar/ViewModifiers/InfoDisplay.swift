//
//  InfoDisplay.swift
//  
//
//  Created by Will Dale on 02/10/2021.
//

import SwiftUI

// MARK: - Protocols
/// Required chart data protocols for displaying touched data
public typealias InfoData = CTChartData & Publishable & TouchInfoDisplayable

/// Type for creating a View to display data when touched
public protocol InfoDisplayable {
    associatedtype ChartData: InfoData
    associatedtype Content: View
    
    var chartData: ChartData { get set }
    var content: Content { get }
}

internal struct InfoDisplay<ChartData, Info>: ViewModifier
where ChartData: InfoData,
      Info: InfoDisplayable {
    
    @ObservedObject private var chartData: ChartData
    internal var infoView: Info
    internal var position: (_ touchLocation: CGPoint, _ chartSize: CGRect) -> CGPoint
        
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
    
    /// Customisable display of the data from ``touchOverlay``.
    ///
    /// This the most customisable version of ``infoDisplay``.
    /// Other versions of ``infoDisplay`` use a template system, this just publicly exposes how the templates are built.
    ///
    ///  ```
    ///  .infoDisplay(chartData: data, infoView: customInfoBox) { setBoxLocation($0, $1) }
    ///  ```
    ///  ```
    ///  var customInfoBox: some InfoDisplayable {
    ///      CustomInfoBox(chartData: data, boxFrame: $size)
    ///  }
    ///
    ///  func setBoxLocation(_ touchLocation: CGPoint, _ chartSize: CGRect) -> CGPoint {
    ///      CGPoint(x: data.setBoxLocation(touchLocation: touchLocation.x,
    ///                                     boxFrame: size,
    ///                                     chartSize: chartSize),
    ///              y: 35)
    ///  }
    ///  ```
    ///
    ///  The ``infoView`` parameter takes in a Struct that conforms to ``InfoDisplayable`` which returns `some View`.
    ///
    ///  ```
    ///  struct CustomInfoBox<ChartData>: InfoDisplayable where ChartData: InfoData {
    ///
    ///      @ObservedObject var chartData: ChartData
    ///      @Binding var boxFrame: CGRect
    ///
    ///      var content: some View {
    ///          VStack(alignment: .leading, spacing: 0) {
    ///              ForEach(chartData.touchPointData, id: \.id) { point in
    ///                  chartData.infoDescription(info: point)
    ///                      .font(chartData.chartStyle.infoBoxDescriptionFont)
    ///                      .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
    ///                  chartData.infoValueUnit(info: point)
    ///                      .font(chartData.chartStyle.infoBoxValueFont)
    ///                      .foregroundColor(chartData.chartStyle.infoBoxValueColour)
    ///                  chartData.infoLegend(info: point)
    ///                      .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
    ///              }
    ///          }
    ///          .border(Color.accentColor, width: 1)
    ///          .background(
    ///              GeometryReader { geo in
    ///                  EmptyView()
    ///                      .onChange(of: geo.frame(in: .local)) { frame in
    ///                          self.boxFrame = frame
    ///                      }
    ///              }
    ///          )
    ///      }
    ///  }
    ///  ```
    ///
    /// - Parameters:
    ///    - chartData: Data model
    ///    - infoView: The view displaying the touched data.
    ///    - position: A closure providing the touch location and chart size, returning where the `infoView` should be positioned.
    /// - Returns: A custom view to display data corresponding to the location of touch input.
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplay<ChartData, Info>(
        chartData: ChartData,
        infoView: Info,
        position: @escaping (_ touchLocation: CGPoint, _ chartSize: CGRect) -> CGPoint
    ) -> some View
    where ChartData: InfoData,
          Info: InfoDisplayable
    {
        self.modifier(InfoDisplay(chartData: chartData, infoView: infoView, position: position))
    }
    
    
    /// Displays data from ``touchOverlay`` using a templated view set in a selectable shape.
    ///
    /// An Example:
    /// ```
    /// .infoDisplay(.verticle(chartData: data), style: .bordered, shape: Rectangle())
    /// ```
    ///
    /// If more control is required use the overload of:
    /// ```
    /// .infoDisplay(chartData:infoView:position:)
    /// ```
    ///
    /// - Parameters:
    ///    - infoBox: Template layout.
    ///    - style: Styling data for the view. Default: .bordered
    ///    - shape: Shape of the view. Default: `RoundedRectangle`
    /// - Returns: A  view to display data corresponding to the location of touch input.
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplay<ChartData, S>(
        _ infoBox: InfoBoxType<ChartData>,
        style: InfoBoxStyle = .bordered,
        shape: S = RoundedRectangle(cornerRadius: 5.0, style: .continuous) as! S
    ) -> some View
    where ChartData: InfoData,
          S: Shape
    {
        infoBox.modifier(of: self, with: style, and: shape)
    }
    
    /// Displays data from ``touchOverlay`` using a templated view.
    ///
    /// An Example:
    /// ```
    /// .infoDisplay(.verticle(chartData: data), style: .bordered)
    /// ```
    ///
    /// If more control is required use an overload:
    /// ```
    /// .infoDisplay(infoBox:style:shape:)
    /// ```
    /// ```
    /// .infoDisplay(chartData:infoView:position:)
    /// ```
    ///
    /// - Parameters:
    ///    - infoBox: Template layout.
    ///    - style: Styling data for the view. Default: .bordered
    /// - Returns: A  view to display data corresponding to the location of touch input.
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplay<ChartData>(
       _ infoBox: InfoBoxType<ChartData>,
       style: InfoBoxStyle = .bordered
    ) -> some View
    where ChartData: InfoData {
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
