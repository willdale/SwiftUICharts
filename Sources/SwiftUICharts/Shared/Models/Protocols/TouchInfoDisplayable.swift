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
