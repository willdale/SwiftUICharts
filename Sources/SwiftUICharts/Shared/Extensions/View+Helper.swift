//
//  View+Helper.swift
//  SwiftUI Charts
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

extension View {
    /**
     View modifier to conditionally add a view modifier.
     
     [SO](https://stackoverflow.com/a/62962375)
     */
    @ViewBuilder func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition { transform(self) }
        else { self }
    }
}

extension View {
    /**
     View modifier to conditionally add a view modifier else add a different one.
     
     [Five Stars](https://fivestars.blog/swiftui/conditional-modifiers.html)
     */
    @ViewBuilder func `ifElse`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
}

extension View {
    /**
     Start animation when the view appears.
     
     [HWS](https://www.hackingwithswift.com/quick-start/swiftui/how-to-start-an-animation-immediately-after-a-view-appears)
     */
    func animateOnAppear(
        using animation: Animation = Animation.easeInOut(duration: 1),
        _ action: @escaping () -> Void
    ) -> some View {
        return onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}

extension Double {
    /**
     Simple, neat divide.
     */
    func divide<T:BinaryInteger>(by divideBy: T) -> Double {
        self / Double(divideBy)
    }
    /**
     Simple, neat divide.
     */
    func divide<T:BinaryFloatingPoint>(by divideBy: T) -> Double {
        self / Double(divideBy)
    }
}
extension CGFloat {
    /**
     Simple, neat divide.
     */
    func divide<T:BinaryInteger>(by divideBy: T) -> CGFloat {
        self / CGFloat(divideBy)
    }
    /**
     Simple, neat divide.
     */
    func divide<T:BinaryFloatingPoint>(by divideBy: T) -> CGFloat {
        self / CGFloat(divideBy)
    }
}

extension Color {
    /// Returns the relevant system background colour for the device.
    public static var systemsBackground: Color {
        #if os(iOS)
        return Color(.systemBackground)
        #elseif os(watchOS)
        return Color(.black)
        #elseif os(tvOS)
        return Color(.darkGray)
        #elseif os(macOS)
        return Color(.windowBackgroundColor)
        #endif
    }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}
