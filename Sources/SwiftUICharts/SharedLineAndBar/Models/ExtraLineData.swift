//
//  ExtraLineData.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import SwiftUI

/**
 Data for drawing and styling the Extra Line view modifier.
 
 This model contains the data and styling information for a single line, line chart.
 */
public struct ExtraLineData: Identifiable {
    
    public let id: UUID = UUID()
    
    public var dataPoints: [ExtraLineDataPoint]
    public var style: ExtraLineStyle
    public var legendTitle: String
    
    public init(
        legendTitle: String,
        dataPoints: () -> ([ExtraLineDataPoint]),
        style: () -> (ExtraLineStyle)
    ) {
        self.dataPoints = dataPoints()
        self.style = style()
        self.legendTitle = legendTitle
        
    }
    
    internal func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) -> ExtraLineDataPoint? {
        let xSection: CGFloat = chartSize.width / CGFloat(dataPoints.count)
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataPoints.count {
            return dataPoints[index]
        }
        return nil
    }
    
    internal func getPointLocation(touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        
        let minValue: Double = self.minValue
        let range: Double = self.range
        
        let xSection: CGFloat = style.lineSpacing == .line ?
            chartSize.width / CGFloat(dataPoints.count - 1) :
            chartSize.width / CGFloat(dataPoints.count)
        let ySection: CGFloat = chartSize.height / CGFloat(range)
        
        let index = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataPoints.count {
            let x = style.lineSpacing == .line ?
                CGFloat(index) * xSection :
                (CGFloat(index) * xSection) + (xSection / 2)
            return CGPoint(x: x,
                           y: (CGFloat(dataPoints[index].value - minValue) * -ySection) + chartSize.height)
        }
        return nil
    }

    internal var range: Double {
        get {
            var _lowestValue: Double
            var _highestValue: Double
            
            switch self.style.baseline {
            case .minimumValue:
                _lowestValue = self.getMinValue()
            case .minimumWithMaximum(of: let value):
                _lowestValue = min(self.getMinValue(), value)
            case .zero:
                _lowestValue = 0
            }
            
            switch self.style.topLine {
            case .maximumValue:
                _highestValue = self.getMaxValue()
            case .maximum(of: let value):
                _highestValue = max(self.getMaxValue(), value)
            }
            
            return (_highestValue - _lowestValue) + 0.001
        }
    }
    internal var minValue: Double {
        get {
            switch self.style.baseline {
            case .minimumValue:
                return self.getMinValue()
            case .minimumWithMaximum(of: let value):
                return min(self.getMinValue(), value)
            case .zero:
                return 0
            }
        }
    }
    internal var maxValue: Double {
        get {
            switch self.style.topLine {
            case .maximumValue:
                return self.getMaxValue()
            case .maximum(of: let value):
                return max(self.getMaxValue(), value)
            }
        }
    }
    internal var average: Double {
        return self.getAverage()
    }
    
    
    internal func getMaxValue() -> Double {
        self.dataPoints
            .map(\.value)
            .max() ?? 0
    }
    internal func getMinValue() -> Double {
        self.dataPoints
            .map(\.value)
            .min() ?? 0
    }
    internal func getAverage() -> Double {
        self.dataPoints
            .map(\.value)
            .reduce(0, +)
            .divide(by: Double(self.dataPoints.count))
    }
}
