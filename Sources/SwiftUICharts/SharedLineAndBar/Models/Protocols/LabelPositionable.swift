//
//  LabelPositionable.swift
//  
//
//  Created by Will Dale on 09/01/2022.
//

import Foundation

public protocol LabelPositionable {}

extension LabelPositionable {
    internal var type: _LabelPositionType {
        switch self {
        case is HorizontalLabelPosition:
            return .horizontal
        case is VerticalLabelPosition:
            return .vertical
        default:
            return .none
        }
    }
    
    var isLeading: Bool {
        switch self as? HorizontalLabelPosition {
        case .leading:
            return true
        default:
            return false
        }
    }
    
    var isTrailing: Bool {
        switch self as? HorizontalLabelPosition {
        case .trailing:
            return true
        default:
            return false
        }
    }
    
    var isHorizontal: Bool {
        isLeading || isTrailing
    }
    
    var isTop: Bool {
        switch self as? VerticalLabelPosition {
        case .top:
            return true
        default:
            return false
        }
    }
    
    var isBottom: Bool {
        switch self as? VerticalLabelPosition {
        case .bottom:
            return true
        default:
            return false
        }
    }
    
    var isVertical: Bool {
        isTop || isBottom
    }
}

public enum HorizontalLabelPosition: LabelPositionable {
    case none
    case leading
    case trailing
}

public enum VerticalLabelPosition: LabelPositionable {
    case none
    case top
    case bottom
}

internal enum _LabelPositionType {
    case none
    case horizontal
    case vertical
}
