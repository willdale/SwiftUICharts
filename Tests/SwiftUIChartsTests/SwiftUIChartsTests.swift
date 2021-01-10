import XCTest
@testable import SwiftUICharts

final class SwiftUIChartsTests: XCTestCase {
    
    // MARK: - ChartData
    func testMaxValue() {
        let dataPoints = [
            ChartDataPoint(value: 10),
            ChartDataPoint(value: 40),
            ChartDataPoint(value: 30),
            ChartDataPoint(value: 60)
        ]
        let chartData = ChartData(dataPoints: dataPoints, chartStyle: ChartStyle())
        
        XCTAssertEqual(chartData.maxValue(), 60)
    }
    func testMinValue() {
        let dataPoints = [
            ChartDataPoint(value: 10),
            ChartDataPoint(value: 40),
            ChartDataPoint(value: 30),
            ChartDataPoint(value: 60)
        ]
        let chartData = ChartData(dataPoints: dataPoints, chartStyle: ChartStyle())
        
        XCTAssertEqual(chartData.minValue(), 10)
    }
    func testAverage() {
        let dataPoints = [
            ChartDataPoint(value: 10),
            ChartDataPoint(value: 40),
            ChartDataPoint(value: 30),
            ChartDataPoint(value: 60)
        ]
        let chartData = ChartData(dataPoints: dataPoints, chartStyle: ChartStyle())
        
        XCTAssertEqual(chartData.average(), 35)
    }
    func testRange() {
        let dataPoints = [
            ChartDataPoint(value: 10),
            ChartDataPoint(value: 40),
            ChartDataPoint(value: 30),
            ChartDataPoint(value: 60)
        ]
        let chartData = ChartData(dataPoints: dataPoints, chartStyle: ChartStyle())
        
        XCTAssertEqual(chartData.range(), 50.001)
    }
    // MARK: - Helper
    func testMonthlyAverage() {
        let calendar = Calendar.current
        
        let formatterForXAxisLabel      = DateFormatter()
        formatterForXAxisLabel.locale   = .current
        formatterForXAxisLabel.setLocalizedDateFormatFromTemplate("MMM")
        
        let formatterForPointLabel      = DateFormatter()
        formatterForXAxisLabel.locale   = .current
        formatterForPointLabel.setLocalizedDateFormatFromTemplate("MMMM YYYY")
        
        let components = DateComponents(year: 2021, month: 01, day: 01, hour: 10, minute: 0, second: 0)
        let date = calendar.date(from: components)!
        
        let monthOne    = calendar.date(byAdding: .month, value: 0, to: date)!
        let monthTwo    = calendar.date(byAdding: .month, value: 1, to: date)!
        let monthThree  = calendar.date(byAdding: .month, value: 2, to: date)!
        let monthFour   = calendar.date(byAdding: .month, value: 3, to: date)!
        
        let dataPoints = [
            ChartDataPoint(value: 10, date: calendar.date(byAdding: .day, value: 0,  to: monthOne)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 5,  to: monthOne)),
            ChartDataPoint(value: 30, date: calendar.date(byAdding: .day, value: 15, to: monthOne)),
            ChartDataPoint(value: 60, date: calendar.date(byAdding: .day, value: 25, to: monthOne)),
            
            ChartDataPoint(value: 60, date: calendar.date(byAdding: .day, value: 0,  to: monthTwo)),
            ChartDataPoint(value: 50, date: calendar.date(byAdding: .day, value: 5,  to: monthTwo)),
            ChartDataPoint(value: 70, date: calendar.date(byAdding: .day, value: 15, to: monthTwo)),
            ChartDataPoint(value: 30, date: calendar.date(byAdding: .day, value: 25, to: monthTwo)),
            
            ChartDataPoint(value: 20, date: calendar.date(byAdding: .day, value: 0,  to: monthThree)),
            ChartDataPoint(value: 50, date: calendar.date(byAdding: .day, value: 5,  to: monthThree)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 15, to: monthThree)),
            ChartDataPoint(value: 80, date: calendar.date(byAdding: .day, value: 25, to: monthThree)),
            
            ChartDataPoint(value: 70, date: calendar.date(byAdding: .day, value: 0,  to: monthFour)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 5,  to: monthFour)),
            ChartDataPoint(value: 20, date: calendar.date(byAdding: .day, value: 15, to: monthFour)),
            ChartDataPoint(value: 10, date: calendar.date(byAdding: .day, value: 25, to: monthFour))
        ]
        
        XCTAssertEqual(Helper.monthlyAverage(dataPoints: dataPoints), [
            ChartDataPoint(value: 35,
                           xAxisLabel: formatterForXAxisLabel.string(from: monthOne),
                           pointLabel: formatterForPointLabel.string(from: monthOne)),
            ChartDataPoint(value: 52.50,
                           xAxisLabel: formatterForXAxisLabel.string(from: monthTwo),
                           pointLabel: formatterForPointLabel.string(from: monthTwo)),
            ChartDataPoint(value: 47.5,
                           xAxisLabel: formatterForXAxisLabel.string(from: monthThree),
                           pointLabel: formatterForPointLabel.string(from: monthThree)),
            ChartDataPoint(value: 35,
                           xAxisLabel: formatterForXAxisLabel.string(from: monthFour),
                           pointLabel: formatterForPointLabel.string(from: monthFour)),
        ])
    }
    
    
    
    static var allTests = [
        // Chart Data
        ("testMaxValue", testMaxValue),
        ("testMinValue", testMinValue),
        ("testAverage", testAverage),
        ("testRange", testRange),
        ("testMonthlyAverage", testMonthlyAverage)
        // Helper
    ]
}
