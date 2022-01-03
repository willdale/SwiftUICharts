//
//  LineAndBarProtocolsExtentions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

// MARK: - Data Set
extension DataHelper where Self: CTChartData,
                           SetType: DataFunctionsProtocol {
    public var range: Double {
        get {
            var _lowestValue: Double
            var _highestValue: Double
            
            switch baseline {
            case .minimumValue:
                _lowestValue = dataSets.minValue()
            case .minimumWithMaximum(of: let value):
                _lowestValue = min(dataSets.minValue(), value)
            case .zero:
                _lowestValue = 0
            }
            
            switch topLine {
            case .maximumValue:
                _highestValue = dataSets.maxValue()
            case .maximum(of: let value):
                _highestValue = max(dataSets.maxValue(), value)
            }
            
            return (_highestValue - _lowestValue) + 0.001
        }
    }
    
    public var minValue: Double {
        get {
            switch baseline {
            case .minimumValue:
                return dataSets.minValue()
            case .minimumWithMaximum(of: let value):
                return min(dataSets.minValue(), value)
            case .zero:
                return 0
            }
        }
    }
    
    public var maxValue: Double {
        get {
            switch topLine {
            case .maximumValue:
                return dataSets.maxValue()
            case .maximum(of: let value):
                return max(dataSets.maxValue(), value)
            }
        }
    }
    
    public var average: Double {
        return dataSets.average()
    }
}

extension AxisX where Self: CTChartData & ViewDataProtocol {

    @ViewBuilder
    internal func getAxisColourAsCircle(customColour: ChartColour, width: CGFloat) -> some View {
        Group {
            switch customColour {
            case let .colour(colour):
                HStack {
                    Circle()
                        .fill(colour)
                        .frame(width: width, height: width)
                }
            case let .gradient(colours, _, _):
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: colours),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: width, height: width)
                }
            case let .gradientStops(stops, _, _):
                let stops = stops
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: width, height: width)
                }
            }
        }
    }
}
