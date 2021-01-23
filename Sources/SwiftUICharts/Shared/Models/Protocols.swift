//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public protocol ChartData: ObservableObject, Identifiable {
    associatedtype Set : DataSet
        
    var id          : UUID { get }
    var dataSets    : [Set] { get set }
    var metadata    : ChartMetadata? { get set }
    var xAxisLabels : [String]? { get set }
    var chartStyle  : ChartStyle { get set }
    var legends     : [LegendData] { get set }
    var viewData    : ChartViewData { get set }
    var noDataText  : Text { get set }

    func legendOrder() -> [LegendData]
}

public protocol DataSet: Hashable, Identifiable {
    associatedtype Styling : Style
    var id          : ID { get }
    var dataPoints  : [ChartDataPoint] { get set }
    var legendTitle : String { get set }
    var pointStyle  : PointStyle { get set }
    var style       : Styling { get set }
}

public protocol Style {
    var colourType  : ColourType { get set }
    var colour      : Color? { get set }
    var colours     : [Color]? { get set }
    var stops       : [GradientStop]? { get set }
    var startPoint  : UnitPoint? { get set }
    var endPoint    : UnitPoint? { get set }
//    var ignoreZero  : Bool { get set }
}
