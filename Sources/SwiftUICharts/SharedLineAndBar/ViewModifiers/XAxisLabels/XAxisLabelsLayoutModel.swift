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
