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
        let chartData = ChartData(dataPoints: dataPoints)
        
        XCTAssertEqual(chartData.maxValue(), 60)
    }
    func testMinValue() {
        let dataPoints = [
            ChartDataPoint(value: 10),
            ChartDataPoint(value: 40),
            ChartDataPoint(value: 30),
            ChartDataPoint(value: 60)
        ]
        let chartData = ChartData(dataPoints: dataPoints)
        
        XCTAssertEqual(chartData.minValue(), 10)
    }
    func testAverage() {
        let dataPoints = [
            ChartDataPoint(value: 10),
            ChartDataPoint(value: 40),
            ChartDataPoint(value: 30),
            ChartDataPoint(value: 60)
        ]
        let chartData = ChartData(dataPoints: dataPoints)
        
        XCTAssertEqual(chartData.average(), 35)
    }
    func testRange() {
        let dataPoints = [
            ChartDataPoint(value: 10),
            ChartDataPoint(value: 40),
            ChartDataPoint(value: 30),
            ChartDataPoint(value: 60)
        ]
        let chartData = ChartData(dataPoints: dataPoints)
        
        XCTAssertEqual(chartData.range(), 50.001)
    }

    // MARK: - Calculations
    func testMonthlyAverage() {
        let calendar = Calendar.current
        
        let formatterForXAxisLabel      = DateFormatter()
        formatterForXAxisLabel.locale   = .current
        formatterForXAxisLabel.setLocalizedDateFormatFromTemplate("MMM")
        let formatterForPointLabel      = DateFormatter()
        formatterForPointLabel.locale   = .current
        formatterForPointLabel.setLocalizedDateFormatFromTemplate("MMMM YYYY")
        
        let components = DateComponents(year: 2021, month: 01, day: 01, hour: 10, minute: 0, second: 0)
        
        guard let date = calendar.date(from: components) else {
            XCTFail("date failed")
            return
        }
        guard let monthOne = calendar.date(byAdding: .month, value: 0, to: date) else {
            XCTFail("monthOne failed")
            return
        }
        guard let monthTwo    = calendar.date(byAdding: .month, value: 1, to: date) else {
            XCTFail("monthTwo failed")
            return
        }
        guard let monthThree  = calendar.date(byAdding: .month, value: 2, to: date) else {
            XCTFail("monthThree failed")
            return
        }
        guard let monthFour   = calendar.date(byAdding: .month, value: 3, to: date) else {
            XCTFail("monthFour failed")
            return
        }
        
        let dataPoints = [
            ChartDataPoint(value: 10, date: calendar.date(byAdding: .day, value: 0,  to: monthOne)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 5,  to: monthOne)),
            ChartDataPoint(value: 30, date: calendar.date(byAdding: .day, value: 15, to: monthOne)),
            ChartDataPoint(value: 60, date: calendar.date(byAdding: .day, value: 25, to: monthOne)),
            
            ChartDataPoint(value: 60, date: calendar.date(byAdding: .day, value: 0,  to: monthTwo)),
            ChartDataPoint(value: 50, date: calendar.date(byAdding: .day, value: 6,  to: monthTwo)),
            ChartDataPoint(value: 70, date: calendar.date(byAdding: .day, value: 19, to: monthTwo)),
            ChartDataPoint(value: 30, date: calendar.date(byAdding: .day, value: 27, to: monthTwo)),

            ChartDataPoint(value: 20, date: calendar.date(byAdding: .day, value: 0,  to: monthThree)),
            ChartDataPoint(value: 50, date: calendar.date(byAdding: .day, value: 3,  to: monthThree)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 10, to: monthThree)),
            ChartDataPoint(value: 80, date: calendar.date(byAdding: .day, value: 20, to: monthThree)),

            ChartDataPoint(value: 70, date: calendar.date(byAdding: .day, value: 0,  to: monthFour)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 2,  to: monthFour)),
            ChartDataPoint(value: 20, date: calendar.date(byAdding: .day, value: 25, to: monthFour)),
            ChartDataPoint(value: 10, date: calendar.date(byAdding: .day, value: 26, to: monthFour))
        ]
        
        guard let monthlyAverage = Calculations.monthlyAverage(dataPoints: dataPoints) else {
            XCTFail("Failed")
            return
        }

        
        XCTAssertEqual(monthlyAverage[0].value, 35.0)
        XCTAssertEqual(monthlyAverage[1].value, 52.5)
        XCTAssertEqual(monthlyAverage[2].value, 47.5)
        XCTAssertEqual(monthlyAverage[3].value, 35.0)
        
        XCTAssertEqual(monthlyAverage[0].xAxisLabel, formatterForXAxisLabel.string(from: monthOne))
        XCTAssertEqual(monthlyAverage[1].xAxisLabel, formatterForXAxisLabel.string(from: monthTwo))
        XCTAssertEqual(monthlyAverage[2].xAxisLabel, formatterForXAxisLabel.string(from: monthThree))
        XCTAssertEqual(monthlyAverage[3].xAxisLabel, formatterForXAxisLabel.string(from: monthFour))
        
        XCTAssertEqual(monthlyAverage[0].pointDescription, formatterForPointLabel.string(from: monthOne))
        XCTAssertEqual(monthlyAverage[1].pointDescription, formatterForPointLabel.string(from: monthTwo))
        XCTAssertEqual(monthlyAverage[2].pointDescription, formatterForPointLabel.string(from: monthThree))
        XCTAssertEqual(monthlyAverage[3].pointDescription, formatterForPointLabel.string(from: monthFour))
    }
    
    func testWeeklyAverage() {
        let calendar = Calendar.current
        
        let formatterForXAxisLabel      = DateFormatter()
        formatterForXAxisLabel.locale   = .current
        formatterForXAxisLabel.setLocalizedDateFormatFromTemplate("d")
        let formatterForPointLabel      = DateFormatter()
        formatterForPointLabel.locale   = .current
        formatterForPointLabel.setLocalizedDateFormatFromTemplate("MMMM YYYY")
        
        let components = DateComponents(year: 2021, month: 01, day: 03, hour: 10, minute: 0, second: 0)
        
        guard let date = calendar.date(from: components) else {
            XCTFail("date failed")
            return
        }
        guard let weekOne      = calendar.date(byAdding: .day, value: 1, to: date) else {
            XCTFail("monthOne failed")
            return
        }
        guard let weekTwo      = calendar.date(byAdding: .day, value: 8, to: date) else {
            XCTFail("monthTwo failed")
            return
        }
        guard let weekThree    = calendar.date(byAdding: .day, value: 15, to: date) else {
            XCTFail("monthThree failed")
            return
        }
        guard let weekFour     = calendar.date(byAdding: .day, value: 22, to: date) else {
            XCTFail("monthFour failed")
            return
        }
        
        let dataPoints = [
            ChartDataPoint(value: 30, date: calendar.date(byAdding: .day, value: 0, to: weekOne)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 1, to: weekOne)),
            ChartDataPoint(value: 60, date: calendar.date(byAdding: .day, value: 3, to: weekOne)),
            ChartDataPoint(value: 80, date: calendar.date(byAdding: .day, value: 5, to: weekOne)),
            
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 0, to: weekTwo)),
            ChartDataPoint(value: 20, date: calendar.date(byAdding: .day, value: 2, to: weekTwo)),
            ChartDataPoint(value: 70, date: calendar.date(byAdding: .day, value: 3, to: weekTwo)),
            ChartDataPoint(value: 90, date: calendar.date(byAdding: .day, value: 5, to: weekTwo)),

            ChartDataPoint(value: 10, date: calendar.date(byAdding: .day, value: 1, to: weekThree)),
            ChartDataPoint(value: 50, date: calendar.date(byAdding: .day, value: 2, to: weekThree)),
            ChartDataPoint(value: 30, date: calendar.date(byAdding: .day, value: 4, to: weekThree)),
            ChartDataPoint(value: 80, date: calendar.date(byAdding: .day, value: 5, to: weekThree)),

            ChartDataPoint(value: 60, date: calendar.date(byAdding: .day, value: 0, to: weekFour)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 2, to: weekFour)),
            ChartDataPoint(value: 80, date: calendar.date(byAdding: .day, value: 3, to: weekFour)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .day, value: 5, to: weekFour))
        ]
        
        guard let weeklyAverage = Calculations.weeklyAverage(dataPoints: dataPoints) else {
            XCTFail("Failed")
            return
        }
        
        XCTAssertEqual(weeklyAverage[0].value, 52.5)
        XCTAssertEqual(weeklyAverage[1].value, 55.0)
        XCTAssertEqual(weeklyAverage[2].value, 42.5)
        XCTAssertEqual(weeklyAverage[3].value, 55.0)
        
        XCTAssertEqual(weeklyAverage[0].xAxisLabel, formatterForXAxisLabel.string(from: weekOne))
        XCTAssertEqual(weeklyAverage[1].xAxisLabel, formatterForXAxisLabel.string(from: weekTwo))
        XCTAssertEqual(weeklyAverage[2].xAxisLabel, formatterForXAxisLabel.string(from: weekThree))
        XCTAssertEqual(weeklyAverage[3].xAxisLabel, formatterForXAxisLabel.string(from: weekFour))
        
        XCTAssertEqual(weeklyAverage[0].pointDescription, formatterForPointLabel.string(from: weekOne))
        XCTAssertEqual(weeklyAverage[1].pointDescription, formatterForPointLabel.string(from: weekTwo))
        XCTAssertEqual(weeklyAverage[2].pointDescription, formatterForPointLabel.string(from: weekThree))
        XCTAssertEqual(weeklyAverage[3].pointDescription, formatterForPointLabel.string(from: weekFour))
    }
    
    func testDailyAverage() {
        let calendar = Calendar.current
        
        let formatterForXAxisLabel      = DateFormatter()
        formatterForXAxisLabel.locale   = .current
        formatterForXAxisLabel.setLocalizedDateFormatFromTemplate("d")
        let formatterForPointLabel      = DateFormatter()
        formatterForPointLabel.locale   = .current
        formatterForPointLabel.setLocalizedDateFormatFromTemplate("dd MMMM YYYY")
        
        let components = DateComponents(year: 2021, month: 01, day: 03, hour: 10, minute: 0, second: 0)
        
        guard let date = calendar.date(from: components) else {
            XCTFail("date failed")
            return
        }
        guard let dayOne    = calendar.date(byAdding: .day, value: 1, to: date) else {
            XCTFail("monthOne failed")
            return
        }
        guard let dayTwo    = calendar.date(byAdding: .day, value: 2, to: date) else {
            XCTFail("monthTwo failed")
            return
        }
        guard let dayThree  = calendar.date(byAdding: .day, value: 3, to: date) else {
            XCTFail("monthThree failed")
            return
        }
        guard let dayFour   = calendar.date(byAdding: .day, value: 4, to: date) else {
            XCTFail("monthFour failed")
            return
        }
        
        let dataPoints = [
            ChartDataPoint(value: 30, date: calendar.date(byAdding: .hour, value: 0, to: dayOne)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .hour, value: 1, to: dayOne)),
            ChartDataPoint(value: 60, date: calendar.date(byAdding: .hour, value: 3, to: dayOne)),
            ChartDataPoint(value: 80, date: calendar.date(byAdding: .hour, value: 5, to: dayOne)),
            
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .hour, value: 0, to: dayTwo)),
            ChartDataPoint(value: 20, date: calendar.date(byAdding: .hour, value: 2, to: dayTwo)),
            ChartDataPoint(value: 70, date: calendar.date(byAdding: .hour, value: 3, to: dayTwo)),
            ChartDataPoint(value: 90, date: calendar.date(byAdding: .hour, value: 5, to: dayTwo)),

            ChartDataPoint(value: 10, date: calendar.date(byAdding: .hour, value: 1, to: dayThree)),
            ChartDataPoint(value: 50, date: calendar.date(byAdding: .hour, value: 2, to: dayThree)),
            ChartDataPoint(value: 30, date: calendar.date(byAdding: .hour, value: 4, to: dayThree)),
            ChartDataPoint(value: 80, date: calendar.date(byAdding: .hour, value: 5, to: dayThree)),

            ChartDataPoint(value: 60, date: calendar.date(byAdding: .hour, value: 0, to: dayFour)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .hour, value: 2, to: dayFour)),
            ChartDataPoint(value: 80, date: calendar.date(byAdding: .hour, value: 3, to: dayFour)),
            ChartDataPoint(value: 40, date: calendar.date(byAdding: .hour, value: 5, to: dayFour))
        ]
        
        guard let dailyAverage = Calculations.dailyAverage(dataPoints: dataPoints) else {
            XCTFail("Failed")
            return
        }
        
        XCTAssertEqual(dailyAverage[0].value, 52.5)
        XCTAssertEqual(dailyAverage[1].value, 55.0)
        XCTAssertEqual(dailyAverage[2].value, 42.5)
        XCTAssertEqual(dailyAverage[3].value, 55.0)
        
        XCTAssertEqual(dailyAverage[0].xAxisLabel, formatterForXAxisLabel.string(from: dayOne))
        XCTAssertEqual(dailyAverage[1].xAxisLabel, formatterForXAxisLabel.string(from: dayTwo))
        XCTAssertEqual(dailyAverage[2].xAxisLabel, formatterForXAxisLabel.string(from: dayThree))
        XCTAssertEqual(dailyAverage[3].xAxisLabel, formatterForXAxisLabel.string(from: dayFour))
        
        XCTAssertEqual(dailyAverage[0].pointDescription, formatterForPointLabel.string(from: dayOne))
        XCTAssertEqual(dailyAverage[1].pointDescription, formatterForPointLabel.string(from: dayTwo))
        XCTAssertEqual(dailyAverage[2].pointDescription, formatterForPointLabel.string(from: dayThree))
        XCTAssertEqual(dailyAverage[3].pointDescription, formatterForPointLabel.string(from: dayFour))
    }
    
    static var allTests = [
        // Chart Data
        ("testMaxValue", testMaxValue),
        ("testMinValue", testMinValue),
        ("testAverage", testAverage),
        ("testRange", testRange),
        
        // Calculations
        ("testMonthlyAverage", testMonthlyAverage),
        ("testWeeklyAverage", testWeeklyAverage),
        ("testDailyAverage", testDailyAverage)
    ]
}
