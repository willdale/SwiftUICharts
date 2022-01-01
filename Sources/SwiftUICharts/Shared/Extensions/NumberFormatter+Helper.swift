//
//  NumberFormatter+Helper.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import Foundation

extension NumberFormatter {
    public static var `default`: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
