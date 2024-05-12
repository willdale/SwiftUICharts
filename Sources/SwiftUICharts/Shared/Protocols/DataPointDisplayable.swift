//
//  DataPointDisplayable.swift
//  
//
//  Created by Will Dale on 31/12/2021.
//

import Foundation
import SwiftUI

public protocol DataPointDisplayable {
    
    var id: UUID { get }
    
    var wrappedDescription: String { get }
    
    /**
     Displays the relevent Legend for the data point.
     
     - Parameter formatter: Number formatter
     - Returns: The value as a String
     */
    func formattedValue(from formatter: NumberFormatter) -> String
}

extension DataPointDisplayable where Self: CTStandardDataPointProtocol {
    public func formattedValue(from formatter: NumberFormatter) -> String {
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}

extension DataPointDisplayable where Self: CTStandardDataPointProtocol & Ignorable {
    public func formattedValue(from formatter: NumberFormatter) -> String {
        if !ignore {
            return formatter.string(from: NSNumber(value: value)) ?? ""
        } else {
            return ""
        }
    }
}

extension DataPointDisplayable where Self: CTRangeDataPointProtocol & Ignorable {
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
