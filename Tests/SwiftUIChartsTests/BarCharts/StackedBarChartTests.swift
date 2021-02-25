import XCTest
@testable import SwiftUICharts

final class StackedBarChartTests: XCTestCase {
    
    enum Group {
        case one
        case two
        case three
        case four
        
        var data : GroupingData {
            switch self {
            case .one:
                return GroupingData(title: "One"  , colour: .blue)
            case .two:
                return GroupingData(title: "Two"  , colour: .red)
            case .three:
                return GroupingData(title: "Three", colour: .yellow)
            case .four:
                return GroupingData(title: "Four" , colour: .green)
            }
        }
    }
    
    let groups : [GroupingData] = [Group.one.data, Group.two.data, Group.three.data, Group.four.data]
    
    let data = MultiBarDataSets(dataSets: [
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 10, xAxisLabel: "1.1", pointLabel: "One One"    , group: Group.one.data),
            MultiBarChartDataPoint(value: 50, xAxisLabel: "1.2", pointLabel: "One Two"    , group: Group.two.data),
            MultiBarChartDataPoint(value: 30, xAxisLabel: "1.3", pointLabel: "One Three"  , group: Group.three.data),
            MultiBarChartDataPoint(value: 40, xAxisLabel: "1.4", pointLabel: "One Four"   , group: Group.four.data)
        ]),
        
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 20, xAxisLabel: "2.1", pointLabel: "Two One"    , group: Group.one.data),
            MultiBarChartDataPoint(value: 60, xAxisLabel: "2.2", pointLabel: "Two Two"    , group: Group.two.data),
            MultiBarChartDataPoint(value: 40, xAxisLabel: "2.3", pointLabel: "Two Three"  , group: Group.three.data),
            MultiBarChartDataPoint(value: 60, xAxisLabel: "2.3", pointLabel: "Two Four"   , group: Group.four.data)
        ]),
        
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 30, xAxisLabel: "3.1", pointLabel: "Three One"  , group: Group.one.data),
            MultiBarChartDataPoint(value: 70, xAxisLabel: "3.2", pointLabel: "Three Two"  , group: Group.two.data),
            MultiBarChartDataPoint(value: 30, xAxisLabel: "3.3", pointLabel: "Three Three", group: Group.three.data),
            MultiBarChartDataPoint(value: 90, xAxisLabel: "3.4", pointLabel: "Three Four" , group: Group.four.data)
        ]),
        
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 40, xAxisLabel: "4.1", pointLabel: "Four One"   , group: Group.one.data),
            MultiBarChartDataPoint(value: 80, xAxisLabel: "4.2", pointLabel: "Four Two"   , group: Group.two.data),
            MultiBarChartDataPoint(value: 20, xAxisLabel: "4.3", pointLabel: "Four Three" , group: Group.three.data),
            MultiBarChartDataPoint(value: 50, xAxisLabel: "4.4", pointLabel: "Four Four"  , group: Group.four.data)
        ])
    ])
        
    // MARK: - Data
    func testStackedBarMaxValue() {
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        XCTAssertEqual(chartData.maxValue, 90)
    }
    func testStackedBarMinValue() {
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        XCTAssertEqual(chartData.minValue, 10)
    }
    func testStackedBarAverage() {
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        XCTAssertEqual(chartData.average, 45)
    }
    func testStackedBarRange() {
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        XCTAssertEqual(chartData.range, 80.001)
    }
    
    // MARK: Greater
    func testStackedBarIsGreaterThanTwoTrue() {
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    
    func testStackedBarIsGreaterThanTwoFalse() {
       let data = MultiBarDataSets(dataSets: [
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 10, xAxisLabel: "1.1", pointLabel: "One One"  , group: Group.one.data)
            ]),
            
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 20, xAxisLabel: "2.1", pointLabel: "Two One"  , group: Group.one.data)
            ]),
            
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 30, xAxisLabel: "3.1", pointLabel: "Three One", group: Group.one.data)

            ]),
            
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 40, xAxisLabel: "4.1", pointLabel: "Four One" , group: Group.one.data)
            ])
        ])
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        XCTAssertFalse(chartData.isGreaterThanTwo())
    }

    // MARK: Labels
    func testStackedBarGetYLabels() {
        let chartData = StackedBarChartData(dataSets: data, groups: groups,
                                                            chartStyle: BarChartStyle(yAxisNumberOfLabels: 3))

        XCTAssertEqual(chartData.getYLabels()[0], 0.00000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 30.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 60.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 90.0000, accuracy: 0.01)
        
    }
    // MARK: - Touch
    func testStackedBarGetDataPoint() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        
        // Stack 1 - Point 2
        let touchLocationOneTwo: CGPoint = CGPoint(x: 5, y: 95)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationOneTwo, chartSize: rect)
        let testOutputOneTwo  = chartData.infoView.touchOverlayInfo
        let testAgainstOneTwo = chartData.dataSets.dataSets[0].dataPoints
        XCTAssertEqual(testOutputOneTwo[0], testAgainstOneTwo[1])
        
        // Stack 1 - Point 4
        let touchLocationOneFour: CGPoint = CGPoint(x: 5, y: 60)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationOneFour, chartSize: rect)
        let testOutputOneFour  = chartData.infoView.touchOverlayInfo
        let testAgainstOneFour = chartData.dataSets.dataSets[0].dataPoints
        XCTAssertEqual(testOutputOneFour[0], testAgainstOneFour[3])
        
        // Stack 2 - Point 1
        let touchLocationTwoOne: CGPoint = CGPoint(x: 30, y: 95)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationTwoOne, chartSize: rect)
        let testOutputTwoOne  = chartData.infoView.touchOverlayInfo
        let testAgainstTwoOne = chartData.dataSets.dataSets[1].dataPoints
        XCTAssertEqual(testOutputTwoOne[0], testAgainstTwoOne[0])
        
        // Stack 2 - Point 3
        let touchLocationTwoThree: CGPoint = CGPoint(x: 30, y: 66)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationTwoThree, chartSize: rect)
        let testOutputTwoThree  = chartData.infoView.touchOverlayInfo
        let testAgainstTwoThree = chartData.dataSets.dataSets[1].dataPoints
        XCTAssertEqual(testOutputTwoThree[0], testAgainstTwoThree[2])
        
        // Stack 3 - Point 1
        let touchLocationThreeOne: CGPoint = CGPoint(x: 55, y: 95)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationThreeOne, chartSize: rect)
        let testOutputThreeOne  = chartData.infoView.touchOverlayInfo
        let testAgainstThreeOne = chartData.dataSets.dataSets[2].dataPoints
        XCTAssertEqual(testOutputThreeOne[0], testAgainstThreeOne[0])
        
        // Stack 3 - Point 4
        let touchLocationThreeFour: CGPoint = CGPoint(x: 55, y: 10)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationThreeFour, chartSize: rect)
        let testOutputThreeFour  = chartData.infoView.touchOverlayInfo
        let testAgainstThreeFour = chartData.dataSets.dataSets[2].dataPoints
        XCTAssertEqual(testOutputThreeFour[0], testAgainstThreeFour[3])
        
        // Stack 4 - Point 2
        let touchLocationFourTwo: CGPoint = CGPoint(x: 83, y: 50)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationFourTwo, chartSize: rect)
        let testOutputFourTwo  = chartData.infoView.touchOverlayInfo
        let testAgainstFourTwo = chartData.dataSets.dataSets[3].dataPoints
        XCTAssertEqual(testOutputFourTwo[0], testAgainstFourTwo[1])
        
        // Stack 4 - Point 3
        let touchLocationFourThree: CGPoint = CGPoint(x: 83, y: 40)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationFourThree, chartSize: rect)
        let testOutputFourThree  = chartData.infoView.touchOverlayInfo
        let testAgainstFourThree = chartData.dataSets.dataSets[3].dataPoints
        XCTAssertEqual(testOutputFourThree[0], testAgainstFourThree[2])
    }
    

    static var allTests = [
        // Data
        ("testStackedBarMaxValue", testStackedBarMaxValue),
        ("testStackedBarMinValue", testStackedBarMinValue),
        ("testStackedBarAverage",  testStackedBarAverage),
        ("testStackedBarRange",    testStackedBarRange),
        // Greater
        ("testStackedBarIsGreaterThanTwoTrue",  testStackedBarIsGreaterThanTwoTrue),
        ("testStackedBarIsGreaterThanTwoFalse", testStackedBarIsGreaterThanTwoFalse),
        // Labels
        ("testStackedBarGetYLabels", testStackedBarGetYLabels),
        // Touch
        ("testStackedBarGetDataPoint", testStackedBarGetDataPoint),
    ]
}
