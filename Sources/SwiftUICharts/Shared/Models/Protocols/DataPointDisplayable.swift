//
//  DataPointDisplayable.swift
//  
//
//  Created by Will Dale on 31/12/2021.
//

import Foundation
import SwiftUI

public protocol DataPointDisplayable {
    /**
     Displays the relevent Legend for the data point.
     
     - Parameter formatter: Number formatter
     - Returns: The value as a String
     */
    func formattedValue(from formatter: NumberFormatter) -> String
}

extension DataPointDisplayable where Self: CTStandardDataPointProtocol & CTnotRanged {
    public func formattedValue(from formatter: NumberFormatter) -> String {
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}

extension DataPointDisplayable where Self: CTRangeDataPointProtocol & CTisRanged {
    public func formattedValue(from formatter: NumberFormatter) -> String {
        let upper = formatter.string(from: NSNumber(value: upperValue)) ?? ""
        let lower = formatter.string(from: NSNumber(value: lowerValue)) ?? ""
        return upper + " - " + lower
    }
}

extension DataPointDisplayable where Self: CTStandardDataPointProtocol & Ignorable & CTnotRanged {
    public func formattedValue(from formatter: NumberFormatter) -> String {
        if !ignore {
            return formatter.string(from: NSNumber(value: value)) ?? ""
        } else {
            return ""
        }
    }
}

extension DataPointDisplayable where Self: CTRangeDataPointProtocol & Ignorable & CTisRanged {
    public func formattedValue(from formatter: NumberFormatter) -> String {
        if !ignore {
            let upper = formatter.string(from: NSNumber(value: upperValue)) ?? ""
            let lower = formatter.string(from: NSNumber(value: lowerValue)) ?? ""
            return upper + " - " + lower
        } else {
            return ""
        }
    }
}
