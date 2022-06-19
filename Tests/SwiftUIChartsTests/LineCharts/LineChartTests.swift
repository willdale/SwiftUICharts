import XCTest
import SwiftUI
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
        XCTAssertEqual(chartData.range, 70)
    }
    func testLineIsGreaterThanTwoTrue() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    func testLineIsGreaterThanTwoFalse() {
        let dataPoints = [
            LineChartDataPoint(value: 10)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertFalse(chartData.isGreaterThanTwo())
    }
    
    // MARK: - Labels
    func testLineGetYLabels() {
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints),
                                      chartStyle: LineChartStyle(yAxisNumberOfLabels: 3))
        chartData.viewData.yAxisSpecifier = "%.2f"
        
        chartData.chartStyle.topLine  = .maximumValue
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.labelsArray[0], "0.00")
        XCTAssertEqual(chartData.labelsArray[1], "40.00")
        XCTAssertEqual(chartData.labelsArray[2], "80.00")
        
        chartData.chartStyle.baseline = .minimumValue
        XCTAssertEqual(chartData.labelsArray[0], "10.00")
        XCTAssertEqual(chartData.labelsArray[1], "45.00")
        XCTAssertEqual(chartData.labelsArray[2], "80.00")
        
        chartData.chartStyle.baseline = .minimumWithMaximum(of: 5)
        XCTAssertEqual(chartData.labelsArray[0], "5.00")
        XCTAssertEqual(chartData.labelsArray[1], "42.50")
        XCTAssertEqual(chartData.labelsArray[2], "80.00")
        
        chartData.chartStyle.topLine  = .maximum(of: 100)
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.labelsArray[0], "0.00")
        XCTAssertEqual(chartData.labelsArray[1], "50.00")
        XCTAssertEqual(chartData.labelsArray[2], "100.00")
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
}
