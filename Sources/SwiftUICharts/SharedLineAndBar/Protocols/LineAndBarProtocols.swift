//
//  LineAndBarProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - DataPoints

public protocol CTXAxisLabelable {
    /// Data points label for the X axis.
    var xAxisLabel: String? { get set }
}

extension CTXAxisLabelable {
    /// Unwarpped xAxisLabel
    var wrappedXAxisLabel: String {
        self.xAxisLabel ?? ""
    }
}
