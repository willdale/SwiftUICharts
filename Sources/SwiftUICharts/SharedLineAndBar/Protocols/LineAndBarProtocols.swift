//
//  LineAndBarProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - DataPoints
/**
 A protocol to extend functionality of `CTStandardDataPointProtocol` specifically for Line and Bar Charts.
 */
public protocol CTLineBarDataPointProtocol: CTDataPointBaseProtocol {
    /// Data points label for the X axis.
    var xAxisLabel: String? { get set }
}

extension CTLineBarDataPointProtocol {
    /// Unwarpped xAxisLabel
    var wrappedXAxisLabel: String {
        self.xAxisLabel ?? ""
    }
}
