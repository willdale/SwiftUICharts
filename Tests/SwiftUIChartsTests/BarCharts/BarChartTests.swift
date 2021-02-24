import XCTest
@testable import SwiftUICharts

final class BarChartTests: XCTestCase {
    
    let dataPoints = [
        BarChartDataPoint(value: 10),
        BarChartDataPoint(value: 40),
        BarChartDataPoint(value: 30),
        BarChartDataPoint(value: 60)
    ]
    
    // MARK: Data
    func testBarMaxValue() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.maxValue, 60)
    }
    func testBarMinValue() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.minValue, 10)
    }
    func testBarAverage() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.average, 35)
    }
    func testBarRange() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.range, 50.001)
    }
    
    // MARK: Greater
    func testBarIsGreaterThanTwoTrue() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    
    func testBarIsGreaterThanTwoFalse() {
        let dataPoints = [
            BarChartDataPoint(value: 10),
            BarChartDataPoint(value: 60)
        ]
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertFalse(chartData.isGreaterThanTwo())
    }

    // MARK: Labels
    func testBarGetYLabels() {
        let dataPoints = [
            BarChartDataPoint(value: 10),
            BarChartDataPoint(value: 50),
            BarChartDataPoint(value: 40),
            BarChartDataPoint(value: 80)
        ]
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints),
                                      chartStyle: BarChartStyle(yAxisNumberOfLabels: 3))

        XCTAssertEqual(chartData.getYLabels()[0], 0.00000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 26.6666, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 53.3333, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 80.0000, accuracy: 0.01)
    }
    
    

    static var allTests = [
        // Data
        ("testBarMaxValue", testBarMaxValue),
        ("testBarMinValue", testBarMinValue),
        ("testBarAverage", testBarAverage),
        ("testBarRange", testBarRange),
        // Greater
        ("testBarIsGreaterThanTwoTrue", testBarIsGreaterThanTwoTrue),
        ("testBarIsGreaterThanTwoFalse", testBarIsGreaterThanTwoFalse),
        // Labels
        ("testBarGetYLabels", testBarGetYLabels),
        
        
    ]
}
