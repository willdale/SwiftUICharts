//
//  deprecated+CTChartData.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import SwiftUI

extension CTChartData {
    
    /**
     Displays the data points value with the unit.
     
     - Parameter info: A data point
     - Returns: Text View with the value with relevent info.
     */
    @available(*, deprecated, message: "")
    public func infoValueUnit(info: DataPoint) -> some View {
        switch self.infoView.touchUnit {
        case .none:
            return Text(LocalizedStringKey(info.valueAsString(specifier: self.infoView.touchSpecifier)))
        case .prefix(of: let unit):
            return Text(LocalizedStringKey(unit + " " + info.valueAsString(specifier: self.infoView.touchSpecifier)))
        case .suffix(of: let unit):
            return Text(LocalizedStringKey(info.valueAsString(specifier: self.infoView.touchSpecifier) + " " + unit))
        }
    }
    
    /**
     Displays the data points value without the unit.
     
     - Parameter info: A data point
     - Returns: Text View with the value with relevent info.
     */
    @available(*, deprecated, message: "")
    public func infoValue(info: DataPoint) -> some View {
        Text(LocalizedStringKey(info.valueAsString(specifier: self.infoView.touchSpecifier)))
    }
    
    /**
     Displays the unit.
     
     - Parameter info: A data point
     - Returns: Text View of the unit.
     */
    @available(*, deprecated, message: "")
    public func infoUnit() -> some View {
        switch self.infoView.touchUnit {
        case .none:
            return Text("")
        case .prefix(of: let unit):
            return Text(LocalizedStringKey("\(unit)"))
        case .suffix(of: let unit):
            return Text(LocalizedStringKey("\(unit)"))
        }
    }
    
    /**
     Displays the data points description.
     
     - Parameter info: A data point
     - Returns: Text View with the points description.
     */
    @available(*, deprecated, message: "Please use `infoDescription` property in data point.")
    public func infoDescription(info: DataPoint) -> some View {
        Text(LocalizedStringKey(info.wrappedDescription))
    }
    
    /**
     Displays the relevent Legend for the data point.
     
     - Parameter info: A data point
     - Returns: A View of a Legend.
     */
    @available(*, deprecated, message: "")
    @ViewBuilder
    public func infoLegend(info: DataPoint) -> some View {
        EmptyView()
    }
}

extension CTChartData where Self == RangedLineChartData {
    @available(*, deprecated, message: "")
    public func infoMainValue(info: DataPoint) -> some View {
        var info = info
        info._valueOnly = true
        switch self.infoView.touchUnit {
        case .none:
            return Text(LocalizedStringKey(info.valueAsString(specifier: self.infoView.touchSpecifier)))
        case .prefix(of: let unit):
            return Text(LocalizedStringKey(unit + " " + info.valueAsString(specifier: self.infoView.touchSpecifier)))
        case .suffix(of: let unit):
            return Text(LocalizedStringKey(info.valueAsString(specifier: self.infoView.touchSpecifier) + " " + unit))
        }
    }
}
