//
//  ChartStateObject.swift
//  
//
//  Created by Will Dale on 24/01/2022.
//

import ChartMath
import SwiftUI

public final class TouchedData<DataPoint> where DataPoint: CTDataPointBaseProtocol {
    @Published public var touchPointData: [DataPoint] = []
}

public final class ChartTouchObject: ObservableObject {
    @Published public var touchLocation: CGPoint = .zero
    @Published public var isTouch: Bool = false
    
    public init() {}
}

public final class ChartStateObject: ObservableObject {
    @Published public var chartSize: CGRect = .zero
    
    @Published public var topInset: CGFloat = 0
    @Published public var leadingInset: CGFloat = 0
    @Published public var trailingInset: CGFloat = 0
    @Published public var bottomInset: CGFloat = 0
    
    internal var layoutElements = Set<Model>()
    
    private var timer: Timer?
    
    public init() {}
    
    internal func updateLayoutElement(with newItem: Model) {
        mangeNewItem(newItem)
        handleNewItem(with: newItem.element)
        postLayoutNotification(after: timer)
    }
    
    private func mangeNewItem(_ newItem: Model) {
        if let oldItem = layoutElements.first(where: { $0.element == newItem.element }) {
            layoutElements.remove(oldItem)
            layoutElements.insert(newItem)
        } else {
            layoutElements.insert(newItem)
        }
    }
    
    private func handleNewItem(with newElement: Model.Element) {
        switch newElement {
        case .topTitle:
            topElement()
        case .leadingTitle, .leadingLabels:
            leadingElement()
        case .trailingTitle:
            trailingElement()
        case .bottomTitle:
            bottomElements()
        }
    }
    
    private func topElement() {
        let newTop = layoutElements
            .filter { $0.element.insetSide == .top }
            .map(\.value)
            .reduce(0, +)
        if newTop != topInset { topInset = newTop }
    }
    
    private func leadingElement() {
        let newLeading = layoutElements
            .filter { $0.element.insetSide == .leading }
            .map(\.value)
            .reduce(0, +)
        if newLeading != leadingInset { leadingInset = newLeading }
    }
    
    private func trailingElement() {
        let newTrailing = layoutElements
            .filter { $0.element.insetSide == .trailing }
            .map(\.value)
            .reduce(0, +)
        if newTrailing != trailingInset { trailingInset = newTrailing }
    }
    
    private func bottomElements() {
        let newBottom = layoutElements
            .filter { $0.element.insetSide == .bottom }
            .map(\.value)
            .reduce(0, +)
        if newBottom != bottomInset { bottomInset = newBottom }
    }
    
    private func postLayoutNotification(after timer: Timer?) {
        var timer = timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: .updateLayoutDidFinish, object: self)
        }
    }
    
    internal struct Model: Hashable {
        let element: Element
        let value: CGFloat
        
        enum Element: Hashable {
            case topTitle
            
            case leadingLabels
            case leadingTitle
            
            case trailingTitle
            
            case bottomTitle
            
            var insetSide: Side {
                switch self {
                case .topTitle:
                    return .top
                case .leadingTitle, .leadingLabels:
                    return .leading
                case .trailingTitle:
                    return .trailing
                case .bottomTitle:
                    return .bottom
                }
            }
            
            enum Side {
                case top
                case leading
                case trailing
                case bottom
            }
        }
    }
}

// MARK: - POI
//
//
//
// MARK: Y Axis
extension ChartStateObject {
    public func horizontalLinePosition(value: Double, position: AxisMarkerStyle.Horizontal, minValue: Double, range: Double) -> CGPoint {
        switch position {
        case .leading:
            return CGPoint(x: -(leadingInset / 2),
                           y: plotPointY(value, minValue, range, chartSize.height))
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: plotPointY(value, minValue, range, chartSize.height))
        case .trailing:
            return CGPoint(x: chartSize.width + (trailingInset / 2),
                           y: plotPointY(value, minValue, range, chartSize.height))
        }
    }
}

extension ChartStateObject {
    public func verticalLinePosition(value: Double, position: AxisMarkerStyle.Vertical, minValue: Double, range: Double) -> CGPoint {
        switch position {
        case .top:
            return CGPoint(x: horizontalBarYPosition(value, minValue, range, chartSize.width),
                           y: -(topInset / 2))
        case .center:
            return CGPoint(x: horizontalBarYPosition(value, minValue, range, chartSize.width),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: horizontalBarYPosition(value, minValue, range, chartSize.width),
                           y: chartSize.height + topInset / 2)
        }
    }
}

// MARK: X Axis
//
//
//
// MARK: Line
extension ChartStateObject {
    public func verticalLineIndexedPosition(value: Int, count: Int, position: AxisMarkerStyle.Vertical) -> CGPoint {
        switch position {
        case .top:
            return CGPoint(x: lineXAxisPOIMarkerX(value, count, chartSize.width),
                           y: -(topInset / 2))
        case .center:
            return CGPoint(x: lineXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: lineXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height + topInset / 2)
        }
    }
}

extension ChartStateObject {
    public func horizontalLineIndexedPosition(value: Int, count: Int, position: AxisMarkerStyle.Horizontal) -> CGPoint {
        switch position {
        case .leading:
            return CGPoint(x: -(leadingInset / 2),
                           y: horizontalBarXAxisPOIMarkerY(value, count, chartSize.height))
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: horizontalBarXAxisPOIMarkerY(value, count, chartSize.height))
        case .trailing:
            return CGPoint(x: chartSize.width + (trailingInset / 2),
                           y: horizontalBarXAxisPOIMarkerY(value, count, chartSize.height))
        }
    }
}

// MARK: Bar
extension ChartStateObject {
    public func verticalLineIndexedBarPosition(value: Int, count: Int, position: AxisMarkerStyle.Vertical) -> CGPoint {
        switch position {
        case .top:
            return CGPoint(x: barXAxisPOIMarkerX(value, count, chartSize.width),
                           y: -(topInset / 2))
        case .center:
            return CGPoint(x: barXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: barXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height + topInset / 2)
        }
    }
}

extension ChartStateObject {
    public func horizontalLineIndexedBarPosition(value: Int, count: Int, position: AxisMarkerStyle.Horizontal) -> CGPoint {
        switch position {
        case .leading:
            return CGPoint(x: -(leadingInset / 2),
                           y: barXAxisPOIMarkerX(value, count, chartSize.height))
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: barXAxisPOIMarkerX(value, count, chartSize.height))
        case .trailing:
            return CGPoint(x: chartSize.width + (trailingInset / 2),
                           y: barXAxisPOIMarkerX(value, count, chartSize.height))
        }
    }
}
