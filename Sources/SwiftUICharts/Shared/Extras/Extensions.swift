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
