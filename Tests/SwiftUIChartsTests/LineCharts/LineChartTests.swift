import XCTest
@testable import SwiftUICharts

final class LineChartTests: XCTestCase {
    
    let dataPoints = [
        LineChartDataPoint(value: 10),
        LineChartDataPoint(value: 40),
        LineChartDataPoint(value: 30),
        LineChartDataPoint(value: 60)
    ]
    
    // MARK: - Data
    func testLineMaxValue() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.maxValue, 60)
    }
    func testLineMinValue() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.minValue, 10)
    }
    func testLineAverage() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.average, 35)
    }
    func testLineRange() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.range, 50.001)
    }
    
    // MARK: Greater
    func testLineIsGreaterThanTwoTrue() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    
    func testLineIsGreaterThanTwoFalse() {
        let dataPoints = [
            LineChartDataPoint(value: 10),
            LineChartDataPoint(value: 60)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertFalse(chartData.isGreaterThanTwo())
    }
    
    
    // MARK: - Labels
    func testLineGetYLabels() {
        let dataPoints = [
            LineChartDataPoint(value: 10),
            LineChartDataPoint(value: 50),
            LineChartDataPoint(value: 40),
            LineChartDataPoint(value: 80)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints),
                                      chartStyle: LineChartStyle(yAxisNumberOfLabels: 3,
                                                                 baseline: .minimumValue))

        XCTAssertEqual(chartData.getYLabels()[0], 10.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 33.3333, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 56.6666, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 80.0000, accuracy: 0.01)
        
    }
    

    static var allTests = [
        // Data
        ("testLineMaxValue", testLineMaxValue),
        ("testLineMinValue", testLineMinValue),
        ("testLineAverage",  testLineAverage),
        ("testLineRange",    testLineRange),
        // Greater
        ("testLineIsGreaterThanTwoTrue", testLineIsGreaterThanTwoTrue),
        ("testLineIsGreaterThanTwoFalse", testLineIsGreaterThanTwoFalse),
        // Labels
        ("testLineGetYLabels", testLineGetYLabels),
    ]
}
