import XCTest
@testable import SwiftUICharts

final class LineChartTests: XCTestCase {
    
    // MARK: - Set Up
    let dataPoints = [
        LineChartDataPoint(value: 10),
        LineChartDataPoint(value: 50),
        LineChartDataPoint(value: 40),
        LineChartDataPoint(value: 80)
    ]
    
    // MARK: - Data
    func testLineMaxValue() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.maxValue, 80)
    }
    func testLineMinValue() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.minValue, 10)
    }
    func testLineAverage() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.average, 45)
    }
    func testLineRange() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.range, 70.001)
    }
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
    func testLineGetYLabelsMinimumValue() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints),
                                      chartStyle: LineChartStyle(yAxisNumberOfLabels: 3,
                                                                 baseline: .minimumValue))
        XCTAssertEqual(chartData.getYLabels()[0], 10.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 33.3333, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 56.6666, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 80.0000, accuracy: 0.01)
        
    }
    
    func testLineGetYLabelsMinimumWithMax() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints),
                                      chartStyle: LineChartStyle(yAxisNumberOfLabels: 3,
                                                                 baseline: .minimumWithMaximum(of: 5)))
        XCTAssertEqual(chartData.getYLabels()[0], 5.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 30.000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 55.000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 80.0000, accuracy: 0.01)
        
    }
    
    func testLineGetYLabelsZero() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints),
                                      chartStyle: LineChartStyle(yAxisNumberOfLabels: 3,
                                                                 baseline: .zero))
        XCTAssertEqual(chartData.getYLabels()[0], 0.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 26.666, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 53.333, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 80.0000, accuracy: 0.01)
        
    }
    
    // MARK: - Touch
    func testLineGetDataPoint() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        
        let touchLocationOne: CGPoint = CGPoint(x: 5, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationOne, chartSize: rect)
        let testOutputOne  = chartData.infoView.touchOverlayInfo
        let testAgainstOne = chartData.dataSets.dataPoints
        XCTAssertEqual(testOutputOne[0], testAgainstOne[0])
        
        let touchLocationTwo: CGPoint = CGPoint(x: 25, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationTwo, chartSize: rect)
        let testOutputTwo  = chartData.infoView.touchOverlayInfo
        let testAgainstTwo = chartData.dataSets.dataPoints
        XCTAssertEqual(testOutputTwo[0], testAgainstTwo[1])
        
        let touchLocationThree: CGPoint = CGPoint(x: 50, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationThree, chartSize: rect)
        let testOutputThree  = chartData.infoView.touchOverlayInfo
        let testAgainstThree = chartData.dataSets.dataPoints
        XCTAssertEqual(testOutputThree[0], testAgainstThree[2])
        
        let touchLocationFour: CGPoint = CGPoint(x: 85, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationFour, chartSize: rect)
        let testOutputFour  = chartData.infoView.touchOverlayInfo
        let testAgainstFour = chartData.dataSets.dataPoints
        XCTAssertEqual(testOutputFour[0], testAgainstFour[3])
    }
    
    func testLineGetPointLocation() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        
        // Data point 1
        let touchLocationOne: CGPoint = CGPoint(x: 5, y: 25)
        let testOne: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                          touchLocation: touchLocationOne,
                                                          chartSize: rect)!
        let testAgainstOne = CGPoint(x: 0, y: 100)
        XCTAssertEqual(testOne.x, testAgainstOne.x)
        XCTAssertEqual(testOne.y, testAgainstOne.y)
        
        // Data point 3
        let touchLocationTwo: CGPoint = CGPoint(x: 66, y: 25)
        let testTwo: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                          touchLocation: touchLocationTwo,
                                                          chartSize: rect)!
        let testAgainstTwo = CGPoint(x: 66.66, y: 57.14)
        XCTAssertEqual(testTwo.x, testAgainstTwo.x, accuracy: 0.01)
        XCTAssertEqual(testTwo.y, testAgainstTwo.y, accuracy: 0.01)
    }
    
    // MARK: - All Tests
    static var allTests = [
        // Data
        ("testLineMaxValue", testLineMaxValue),
        ("testLineMinValue", testLineMinValue),
        ("testLineAverage",  testLineAverage),
        ("testLineRange",    testLineRange),
        ("testLineIsGreaterThanTwoTrue",  testLineIsGreaterThanTwoTrue),
        ("testLineIsGreaterThanTwoFalse", testLineIsGreaterThanTwoFalse),
        // Labels
        ("testLineGetYLabelsMinimumValue",   testLineGetYLabelsMinimumValue),
        ("testLineGetYLabelsMinimumWithMax", testLineGetYLabelsMinimumWithMax),
        ("testLineGetYLabelsZero",           testLineGetYLabelsZero),
        // Touch
        ("testLineGetDataPoint",     testLineGetDataPoint),
        ("testLineGetPointLocation", testLineGetPointLocation),
    ]
}
