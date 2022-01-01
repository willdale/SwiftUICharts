//
//  deprecated+DataPointProtocol.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import Foundation

extension CTStandardDataPointProtocol where Self: CTBarDataPointBaseProtocol {
    /// Data point's value as a string
    @available(*, deprecated, message: "")
    public func valueAsString(specifier: String) -> String {
            return String(format: specifier, self.value)
    }
}
extension CTStandardDataPointProtocol where Self: CTLineDataPointProtocol & Ignorable {
    /// Data point's value as a string
    @available(*, deprecated, message: "")
    public func valueAsString(specifier: String) -> String {
        if !self.ignore {
            return String(format: specifier, self.value)
        } else {
            return String("")
        }
    }
}
extension CTStandardDataPointProtocol where Self: CTPieDataPoint {
    /// Data point's value as a string
    @available(*, deprecated, message: "")
    public func valueAsString(specifier: String) -> String {
            return String(format: specifier, self.value)
    }
}

extension CTRangeDataPointProtocol where Self == RangedBarDataPoint {
    /// Data point's value as a string
    @available(*, deprecated, message: "")
    public func valueAsString(specifier: String) -> String {
        if !self._valueOnly {
            return String(format: specifier, self.lowerValue) + "-" + String(format: specifier, self.upperValue)
        } else {
            return String(format: specifier, self._value)
        }
    }
}

extension CTRangedLineDataPoint where Self == RangedLineChartDataPoint {
    /// Data point's value as a string
    @available(*, deprecated, message: "")
    public func valueAsString(specifier: String) -> String {
        if !self._valueOnly {
            return String(format: specifier, self.lowerValue) + "-" + String(format: specifier, self.upperValue)
        } else {
            return String(format: specifier, self.value)
        }
    }
}
