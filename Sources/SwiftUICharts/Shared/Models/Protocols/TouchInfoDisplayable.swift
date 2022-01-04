//
//  TouchInfoDisplayable.swift
//  
//
//  Created by Will Dale on 30/10/2021.
//

import SwiftUI

public protocol TouchInfoDisplayable {
    /**
     Sets the data point info box location while keeping it within the parent view.
     
     - Parameters:
        - touchLocation: Location the user has pressed.
        - boxFrame: The size of the point info box.
        - chartSize: The size of the chart view as the parent view.
     */
    func setBoxLocation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat
}

extension TouchInfoDisplayable where Self: YAxisViewDataProtocol,
                                     Self: VerticalChart {
    public func setBoxLocation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        var returnPoint: CGFloat = .zero
        if touchLocation < chartSize.minX + (boxFrame.width / 2) {
            returnPoint = chartSize.minX + (boxFrame.width / 2)
        } else if touchLocation > chartSize.maxX - (boxFrame.width / 2) {
            returnPoint = chartSize.maxX - (boxFrame.width / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint + axisPadding
    }
}

extension TouchInfoDisplayable where Self: XAxisViewDataProtocol,
                                     Self: HorizontalChart {
    public func setBoxLocation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        var returnPoint: CGFloat = .zero
        if touchLocation < chartSize.minY + (boxFrame.height / 2) {
            returnPoint = chartSize.minY + (boxFrame.height / 2)
        } else if touchLocation > chartSize.maxY - (boxFrame.height / 2) {
            returnPoint = chartSize.maxY - (boxFrame.height / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint + axisPadding
    }
}

extension TouchInfoDisplayable {
    public func setBoxLocation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        touchLocation
    }
}
