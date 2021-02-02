//
//  Calculations.swift
//  
//
//  Created by Will Dale on 14/01/2021.
//

import SwiftUI
/**
 - Tag: Calculations
 */
//internal struct Calculations {
//    /// Get an array of data points converted into and array of data points averaged by their calendar month.
//    /// - Parameter dataPoints: Array of ChartDataPoint.
//    /// - Returns: Array of ChartDataPoint averaged by their calendar month.
//    static internal func monthlyAverage(dataPoints: [ChartDataPoint]) -> [ChartDataPoint]? {
//        let calendar = Calendar.current
//        
//        let formatterForXAxisLabel      = DateFormatter()
//        formatterForXAxisLabel.locale   = .current
//        formatterForXAxisLabel.setLocalizedDateFormatFromTemplate("MMM")
//        let formatterForPointLabel      = DateFormatter()
//        formatterForPointLabel.locale   = .current
//        formatterForPointLabel.setLocalizedDateFormatFromTemplate("MMMM YYYY")
//        
//        guard let firstDataPoint = dataPoints.first?.date else { return nil }
//        guard let lastDataPoint  = dataPoints.last?.date else { return nil }
//        
//        guard let numberOfMonths = calendar.dateComponents([.month],
//                                                           from: firstDataPoint,
//                                                           to: lastDataPoint).month else { return nil }
//        var outputData : [ChartDataPoint] = []
//        for index in 0...numberOfMonths {
//            if let date = calendar.date(byAdding: .month, value: index, to: firstDataPoint) {
//                
//                let requestedMonth = calendar.dateComponents([.year, .month], from: date)
//
//                let monthOfData = dataPoints.filter { (dataPoint) -> Bool in
//                    let month = calendar.dateComponents([.year, .month], from:  dataPoint.date ?? Date())
//                    return month == requestedMonth
//                }
//                let sum = monthOfData.reduce(0) { $0 + $1.value }
//                let average = sum / Double(monthOfData.count)
//
//                outputData.append(ChartDataPoint(value: average,
//                                                 xAxisLabel: formatterForXAxisLabel.string(from: date),
//                                                 pointLabel: formatterForPointLabel.string(from: date)))
//            }
//        }
//
//        return outputData
//    }
//    
//    
//    /// Get an array of data points converted into and array of data points averaged by their week.
//    /// - Parameter dataPoints: Array of ChartDataPoint.
//    /// - Returns: Array of ChartDataPoint averaged by their week.
//    static internal func weeklyAverage(dataPoints: [ChartDataPoint]) -> [ChartDataPoint]? {
//        let calendar = Calendar.current
//        
//        let formatterForXAxisLabel      = DateFormatter()
//        formatterForXAxisLabel.locale   = .current
//        formatterForXAxisLabel.setLocalizedDateFormatFromTemplate("d")
//        let formatterForPointLabel      = DateFormatter()
//        formatterForPointLabel.locale   = .current
//        formatterForPointLabel.setLocalizedDateFormatFromTemplate("MMMM YYYY")
//        
//        guard let firstDataPoint = dataPoints.first?.date else { return nil }
//        guard let lastDataPoint  = dataPoints.last?.date else { return nil }
//        
//        guard let numberOfWeeks = calendar.dateComponents([.weekOfYear],
//                                                           from: firstDataPoint,
//                                                           to: lastDataPoint).weekOfYear else { return nil }
//        
//        var outputData : [ChartDataPoint] = []
//        for index in 0...numberOfWeeks {
//            if let date = calendar.date(byAdding: .weekOfYear, value: (index), to: firstDataPoint) {
//                
//                let requestedWeek = calendar.dateComponents([.year, .weekOfYear], from: date)
//
//                let weekOfData = dataPoints.filter { (dataPoint) -> Bool in
//                    let week = calendar.dateComponents([.year, .weekOfYear], from:  dataPoint.date ?? Date())
//                    return week == requestedWeek
//                }
//                let sum = weekOfData.reduce(0) { $0 + $1.value }
//                let average = sum / Double(weekOfData.count)
//                
//                outputData.append(ChartDataPoint(value: average,
//                                                 xAxisLabel: formatterForXAxisLabel.string(from: date),
//                                                 pointLabel: formatterForPointLabel.string(from: date)))
//            }
//        }
//        
//        return outputData
//    }
//    
//    /// Get an array of data points converted into and array of data points averaged by their day.
//    /// - Parameter dataPoints: Array of ChartDataPoint.
//    /// - Returns: Array of ChartDataPoint averaged by their day.
//    static internal func dailyAverage(dataPoints: [ChartDataPoint]) -> [ChartDataPoint]? {
//        let calendar = Calendar.current
//        
//        let formatterForXAxisLabel      = DateFormatter()
//        formatterForXAxisLabel.locale   = .current
//        formatterForXAxisLabel.setLocalizedDateFormatFromTemplate("d")
//        let formatterForPointLabel      = DateFormatter()
//        formatterForPointLabel.locale   = .current
//        formatterForPointLabel.setLocalizedDateFormatFromTemplate("dd MMMM YYYY")
//        
//        guard let firstDataPoint = dataPoints.first?.date else { return nil }
//        guard let lastDataPoint  = dataPoints.last?.date else { return nil }
//        
//        guard let numberOfDays = calendar.dateComponents([.day],
//                                                         from: firstDataPoint,
//                                                         to: lastDataPoint).day else { return nil }
//        
//        var outputData : [ChartDataPoint] = []
//        for index in 0...numberOfDays {
//            if let date = calendar.date(byAdding: .day, value: index, to: firstDataPoint) {
//                
//                let requestedDay = calendar.dateComponents([.year, .day], from: date)
//
//                let dayOfData = dataPoints.filter { (dataPoint) -> Bool in
//                    let day = calendar.dateComponents([.year, .day], from:  dataPoint.date ?? Date())
//                    
//                    return day == requestedDay
//                }
//                let sum = dayOfData.reduce(0) { $0 + $1.value }
//                let average = sum / Double(dayOfData.count)
//                if !average.isNaN {
//                outputData.append(ChartDataPoint(value: average,
//                                                 xAxisLabel: formatterForXAxisLabel.string(from: date),
//                                                 pointLabel: formatterForPointLabel.string(from: date)))
//                }
//            }
//        }
//        return outputData
//    }
//}
