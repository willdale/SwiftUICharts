//
//  Shared.swift
//  
//
//  Created by Will Dale on 06/01/2022.
//

import Foundation

/// Protects against divide by zero.
///
/// Return zero in the case of divide by zero.
///
/// ```
/// divideByZeroProtection(CGFloat.self, value, maxValue)
/// ```
///
/// - Parameters:
///   - outputType: The numeric type required as an output.
///   - lhs: Dividend
///   - rhs: Divisor
/// - Returns: If rhs is not zero it returns the quotient otherwise it returns zero.
@inlinable
public func divideByZeroProtection<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(_ outputType: U.Type, _ lhs: T, _ rhs: T) -> U {
    U(rhs != 0 ? (lhs / rhs) : 0)
}

@inlinable
public func divide<T: BinaryFloatingPoint, U: BinaryInteger>(_ lhs: T, _ rhs: U) -> T {
    rhs != 0 ? (lhs / T(rhs)) : 0
}

@inlinable
public func divide<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: T) -> T {
    rhs != 0 ? (lhs / T(rhs)) : 0
}
