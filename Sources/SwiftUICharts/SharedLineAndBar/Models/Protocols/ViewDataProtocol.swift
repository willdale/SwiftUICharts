//
//  ViewDataProtocol.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import Foundation
import CoreGraphics.CGGeometry

public typealias ViewDataProtocol = XAxisViewDataProtocol & YAxisViewDataProtocol

public protocol XAxisViewDataProtocol: ObservableObject {
    var xAxisViewData: XAxisViewData { get set }
}

extension XAxisViewDataProtocol {
    var axisPadding: CGFloat {
        (xAxisViewData.xAxisLabelHeights.max() ?? 0) + xAxisViewData.xAxisTitleHeight + (xAxisViewData.hasXAxisLabels ? 4 : 0)
    }
}

public protocol YAxisViewDataProtocol: ObservableObject {
    var yAxisViewData: YAxisViewData { get set }
}

extension YAxisViewDataProtocol {
    var axisPadding: CGFloat {
        (yAxisViewData.yAxisLabelWidth.max() ?? 0) + yAxisViewData.yAxisTitleWidth + (yAxisViewData.hasYAxisLabels ? 4 : 0)
    }
}
