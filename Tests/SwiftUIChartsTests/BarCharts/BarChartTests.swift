import XCTest
@testable import SwiftUICharts

final class BarChartTests: XCTestCase {
    
    let dataPoints = [
        BarChartDataPoint(value: 10),
        BarChartDataPoint(value: 40),
        BarChartDataPoint(value: 30),
        BarChartDataPoint(value: 60)
    ]
    
    // MARK: - Data
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

    // MARK: - Labels
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
    
    // MARK: - Touch
    func testBarGetDataPoint() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        
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
    

    static var allTests = [
        // Data
        ("testBarMaxValue", testBarMaxValue),
        ("testBarMinValue", testBarMinValue),
        ("testBarAverage",  testBarAverage),
        ("testBarRange",    testBarRange),
        // Greater
        ("testBarIsGreaterThanTwoTrue",  testBarIsGreaterThanTwoTrue),
        ("testBarIsGreaterThanTwoFalse", testBarIsGreaterThanTwoFalse),
        // Labels
        ("testBarGetYLabels", testBarGetYLabels),
        // Touch
        ("testBarGetDataPoint", testBarGetDataPoint),
        
    ]
}
