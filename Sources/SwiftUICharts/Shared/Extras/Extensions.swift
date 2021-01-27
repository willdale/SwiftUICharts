//
//  Extensions.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

// https://stackoverflow.com/a/62962375
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}
extension View {
    @ViewBuilder
    func `ifElse`<TrueContent: View, FalseContent: View>(_ condition: Bool,
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


// https://www.hackingwithswift.com/quick-start/swiftui/how-to-start-an-animation-immediately-after-a-view-appears
extension View {
    func animateOnAppear(using animation: Animation = Animation.easeInOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        return onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}
