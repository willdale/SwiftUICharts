//
//  XAxisLabelsLayoutModel.swift
//  
//
//  Created by Will Dale on 13/03/2022.
//

import Foundation
import CoreGraphics.CGGeometry
import ChartMath

internal final class XAxisLabelsLayoutModel: ObservableObject  {
        
    @Published internal var sizes = Set<Model>()
    @Published internal var maxWidth: CGFloat = 0
    @Published internal var maxHeight: CGFloat = 0
    @Published internal var minWidth: CGFloat = 0
    @Published internal var isRotated: Bool = false
    
    internal var orientation: XAxisLabelStyle.AxisOrientation = .vertical
        
    internal func update(with newItem: Model) {
        if let oldItem = sizes.first(where: { $0.id == newItem.id }) {
            sizes.remove(oldItem)
            sizes.insert(newItem)
        } else {
            sizes.insert(newItem)
        }
        maxWidth = sizes
            .map(\.width)
            .max() ?? 0
        maxHeight = sizes
            .map(\.height)
            .max() ?? 0
        
        minWidth = sizes
            .map(\.height)
            .min() ?? 0
    }
    
    internal func width(for index: Int) -> CGFloat {
        return sizes.first(where: { $0.id == index })?.width ?? 0
    }
    
    internal struct Model: Hashable {
        internal let id: Int
        internal let width: CGFloat
        internal let height: CGFloat
    }
}

// MARK: - Math
extension XAxisLabelsLayoutModel {
    static internal func xAxisSectionSizing(
        data: XAxisLabelStyle.XLabelData,
        count: Int,
        size: CGFloat,
        minLabel: CGFloat,
        padding: CGFloat
    ) -> CGFloat {
        switch data.chart {
        case .line,
             .filledLine,
             .multiLine,
             .rangedLine:
            let section = divide(size - padding, count)
            let value = min(section, minLabel)
            return value > 0 ? value : 0
            
        case .bar,
             .rangedBar,
             .stackedBar,
             .horizontalBar:
            let value = divide(size - padding, count)
            return value > 0 ? value : 0
            
        case .groupedBar:
            let superXSection = divide(size - padding, count)
            let spaceSection = (data.spacing ?? 0) * CGFloat(count - 1)
            let compensation = divide(spaceSection, count)
            let section = superXSection - compensation
            return section > 0 ? section : 0
            
        default:
            return .zero
        }
    }
    
    static internal func xAxisLabelOffSet(
        data: XAxisLabelStyle.XLabelData,
        index: Int,
        count: Int,
        size: CGFloat,
        minLabel: CGFloat,
        padding: CGFloat
    ) -> CGFloat {
        switch data.chart {
        case .line,
             .filledLine,
             .multiLine,
             .rangedLine:
            return (CGFloat(index) * divide(size - padding, count - 1)) + (padding / 2)
            
        case .bar,
             .rangedBar,
             .stackedBar,
             .horizontalBar:
            let value = CGFloat(index) * divide(size - padding, count)
            let offSet = xAxisSectionSizing(data: data, count: count, size: size, minLabel: minLabel, padding: padding) / 2
            let pad = padding / 2
            return value + offSet + pad
            
        case .groupedBar:
            let superXSection = divide(size - padding, count)
            let compensation = (((data.spacing ?? 0) * CGFloat(count - 1)) / CGFloat(count))
            let section = (CGFloat(index) * superXSection) + ((CGFloat(index) * compensation) / CGFloat(count))
            let offSet = xAxisSectionSizing(data: data, count: count, size: size, minLabel: minLabel, padding: padding) / 2
            let pad = padding / 2
            return section + offSet + pad
        default:
            return .zero
        }
    }
}
