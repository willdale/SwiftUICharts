//
//  HeaderBox.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import SwiftUI

public struct HeaderBoxStyle {
    /// Font of the title
    public var font: Font
    /// Color of the title
    public var colour: Color
    
    public init(
        font: Font,
        colour: Color
    ) {
        self.font = font
        self.colour = colour
    }
}

extension HeaderBoxStyle {
    public static let title = HeaderBoxStyle(font: .title3,
                                             colour: .primary)
    public static let subtitle = HeaderBoxStyle(font: .body,
                                                colour: .primary)
}

extension View {
    public func titleBox(
        title: String,
        titleStyle: HeaderBoxStyle = .title,
        subtitle: String? = nil,
        subtitleStyle: HeaderBoxStyle = .subtitle
    ) -> some View {
        self.modifier(
            HeaderBox(
                title: title,
                titleStyle: titleStyle,
                subtitle: subtitle,
                subtitleStyle: subtitleStyle
            )
        )
    }
    
    public func titleBox<Title: View>(
        view: Title
    ) -> some View {
        self.modifier(_Custom_HeaderBox(view: view))
    }
    
    public func titleBox<Title: View>(
        view: () -> Title
    ) -> some View {
        self.modifier(_Custom_HeaderBox(view: view()))
    }
}

internal struct HeaderBox: ViewModifier {
    
    private var title: String?
    private var titleStyle: HeaderBoxStyle
    private var subtitle: String?
    private var subtitleStyle: HeaderBoxStyle
            
    internal init(
        title: String?,
        titleStyle: HeaderBoxStyle,
        subtitle: String?,
        subtitleStyle: HeaderBoxStyle
    ) {
        self.title = title
        self.titleStyle = titleStyle
        self.subtitle = subtitle
        self.subtitleStyle = subtitleStyle
    }
    
    internal func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            titleBox
            content
        }
    }
    
    var titleBox: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(title ?? ""))
                .font(titleStyle.font)
                .foregroundColor(titleStyle.colour)
            Text(LocalizedStringKey(subtitle ?? ""))
                .font(subtitleStyle.font)
                .foregroundColor(subtitleStyle.colour)
        }
    }
}

fileprivate struct _Custom_HeaderBox<Title: View>: ViewModifier {
    
    let view: Title
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            view
            content
        }
    }
    
}
