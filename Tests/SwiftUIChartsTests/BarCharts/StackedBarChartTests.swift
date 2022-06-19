import XCTest
import SwiftUI
@testable import SwiftUICharts

final class StackedBarChartTests: XCTestCase {
    
    // MARK: - Set Up
    enum Group {
        case one
        case two
        case three
        case four
        
        var data: GroupingData {
            switch self {
            case .one:
                return GroupingData(title: "One"  , colour: ColourStyle(colour: .blue))
            case .two:
                return GroupingData(title: "Two"  , colour: ColourStyle(colour: .red))
            case .three:
                return GroupingData(title: "Three", colour: ColourStyle(colour: .yellow))
            case .four:
                return GroupingData(title: "Four" , colour: ColourStyle(colour: .green))
            }
        }
    }
    
    let groups: [GroupingData] = [Group.one.data, Group.two.data, Group.three.data, Group.four.data]
    
    let data = StackedBarDataSets(dataSets: [
        StackedBarDataSet(dataPoints: [
            StackedBarDataPoint(value: 10, description: "One One"    , group: Group.one.data),
            StackedBarDataPoint(value: 50, description: "One Two"    , group: Group.two.data),
            StackedBarDataPoint(value: 30, description: "One Three"  , group: Group.three.data),
            StackedBarDataPoint(value: 40, description: "One Four"   , group: Group.four.data)
        ]),
        
        StackedBarDataSet(dataPoints: [
            StackedBarDataPoint(value: 20, description: "Two One"    , group: Group.one.data),
            StackedBarDataPoint(value: 60, description: "Two Two"    , group: Group.two.data),
            StackedBarDataPoint(value: 40, description: "Two Three"  , group: Group.three.data),
            StackedBarDataPoint(value: 60, description: "Two Four"   , group: Group.four.data)
        ]),
        
        StackedBarDataSet(dataPoints: [
            StackedBarDataPoint(value: 30, description: "Three One"  , group: Group.one.data),
            StackedBarDataPoint(value: 70, description: "Three Two"  , group: Group.two.data),
            StackedBarDataPoint(value: 30, description: "Three Three", group: Group.three.data),
            StackedBarDataPoint(value: 90, description: "Three Four" , group: Group.four.data)
        ]),
        
        StackedBarDataSet(dataPoints: [
            StackedBarDataPoint(value: 40, description: "Four One"   , group: Group.one.data),
            StackedBarDataPoint(value: 80, description: "Four Two"   , group: Group.two.data),
            StackedBarDataPoint(value: 20, description: "Four Three" , group: Group.three.data),
            StackedBarDataPoint(value: 50, description: "Four Four"  , group: Group.four.data)
        ])
    ])
    
    // MARK: - Data
    func testStackedBarMaxValue() {
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        XCTAssertEqual(chartData.maxValue, 220)
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
        XCTAssertEqual(chartData.range, 210)
    }
    
    // MARK: Greater
    func testStackedBarIsGreaterThanTwoTrue() {
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    
    // MARK: Labels
    func testStackedBarGetYLabels() {
        let chartData = StackedBarChartData(dataSets: data,
                                            groups: groups,
                                            chartStyle: BarChartStyle(yAxisNumberOfLabels: 3))
        chartData.viewData.yAxisSpecifier = "%.2f"
        
        chartData.chartStyle.topLine  = .maximumValue
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.labelsArray[0], "0.00")
        XCTAssertEqual(chartData.labelsArray[1], "110.00")
        XCTAssertEqual(chartData.labelsArray[2], "220.00")
        
        chartData.chartStyle.baseline = .minimumValue
        XCTAssertEqual(chartData.labelsArray[0], "10.00")
        XCTAssertEqual(chartData.labelsArray[1], "115.00")
        XCTAssertEqual(chartData.labelsArray[2], "220.00")
        
        chartData.chartStyle.baseline = .minimumWithMaximum(of: 5)
        XCTAssertEqual(chartData.labelsArray[0], "5.00")
        XCTAssertEqual(chartData.labelsArray[1], "112.50")
        XCTAssertEqual(chartData.labelsArray[2], "220.00")
        
        chartData.chartStyle.topLine  = .maximum(of: 100)
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.labelsArray[0], "0.00")
        XCTAssertEqual(chartData.labelsArray[1], "110.00")
        XCTAssertEqual(chartData.labelsArray[2], "220.00")
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
        let touchLocationOneFour: CGPoint = CGPoint(x: 5, y: 50)
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
        let touchLocationTwoThree: CGPoint = CGPoint(x: 30, y: 56)
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
    
    func testStackedBarGetPointLocation() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = StackedBarChartData(dataSets: data, groups: groups)
        
        // Stack 1 - Point 2
        let touchLocationOneTwo: CGPoint = CGPoint(x: 5, y: 95)
        let testOneTwo: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                             touchLocation: touchLocationOneTwo,
                                                             chartSize: rect)!
        let testAgainstOneTwo = CGPoint(x: 12.50, y: 72.72)
        XCTAssertEqual(testOneTwo.x, testAgainstOneTwo.x, accuracy: 0.01)
        XCTAssertEqual(testOneTwo.y, testAgainstOneTwo.y, accuracy: 0.01)
        
        // Stack 1 - Point 4
        let touchLocationOneFour: CGPoint = CGPoint(x: 5, y: 60)
        let testOneFour: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                              touchLocation: touchLocationOneFour,
                                                              chartSize: rect)!
        let testAgainstOneFour = CGPoint(x: 12.50, y: 59.09)
        XCTAssertEqual(testOneFour.x, testAgainstOneFour.x, accuracy: 0.01)
        XCTAssertEqual(testOneFour.y, testAgainstOneFour.y, accuracy: 0.01)
        
        // Stack 2 - Point 1
        let touchLocationTwoOne: CGPoint = CGPoint(x: 30, y: 95)
        let testTwoOne: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                             touchLocation: touchLocationTwoOne,
                                                             chartSize: rect)!
        let testAgainstTwoOne = CGPoint(x: 37.50, y: 90.90)
        XCTAssertEqual(testTwoOne.x, testAgainstTwoOne.x, accuracy: 0.01)
        XCTAssertEqual(testTwoOne.y, testAgainstTwoOne.y, accuracy: 0.01)
        
        // Stack 2 - Point 3
        let touchLocationTwoThree: CGPoint = CGPoint(x: 30, y: 66)
        let testTwoThree: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                               touchLocation: touchLocationTwoThree,
                                                               chartSize: rect)!
        let testAgainstTwoThree = CGPoint(x: 37.50, y: 63.63)
        XCTAssertEqual(testTwoThree.x, testAgainstTwoThree.x, accuracy: 0.01)
        XCTAssertEqual(testTwoThree.y, testAgainstTwoThree.y, accuracy: 0.01)
        
        // Stack 3 - Point 1
        let touchLocationThreeOne: CGPoint = CGPoint(x: 55, y: 95)
        let testThreeOne: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                               touchLocation: touchLocationThreeOne,
                                                               chartSize: rect)!
        let testAgainstThreeOne = CGPoint(x: 62.50, y: 86.36)
        XCTAssertEqual(testThreeOne.x, testAgainstThreeOne.x, accuracy: 0.01)
        XCTAssertEqual(testThreeOne.y, testAgainstThreeOne.y, accuracy: 0.01)
        
        // Stack 3 - Point 4
        let touchLocationThreeFour: CGPoint = CGPoint(x: 55, y: 10)
        let testThreeFour: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                                touchLocation: touchLocationThreeFour,
                                                                chartSize: rect)!
        let testAgainstThreeFour = CGPoint(x: 62.50, y: 0.00)
        XCTAssertEqual(testThreeFour.x, testAgainstThreeFour.x, accuracy: 0.01)
        XCTAssertEqual(testThreeFour.y, testAgainstThreeFour.y, accuracy: 0.01)
        
        // Stack 4 - Point 2
        let touchLocationFourTwo: CGPoint = CGPoint(x: 83, y: 50)
        let testFourTwo: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                              touchLocation: touchLocationFourTwo,
                                                              chartSize: rect)!
        let testAgainstFourTwo = CGPoint(x: 87.50, y: 45.45)
        XCTAssertEqual(testFourTwo.x, testAgainstFourTwo.x, accuracy: 0.01)
        XCTAssertEqual(testFourTwo.y, testAgainstFourTwo.y, accuracy: 0.01)
        
        // Stack 4 - Point 3
        let touchLocationFourThree: CGPoint = CGPoint(x: 83, y: 40)
        let testFourThree: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                                touchLocation: touchLocationFourThree,
                                                                chartSize: rect)!
        let testAgainstFourThree = CGPoint(x: 87.50, y: 36.36)
        XCTAssertEqual(testFourThree.x, testAgainstFourThree.x, accuracy: 0.01)
        XCTAssertEqual(testFourThree.y, testAgainstFourThree.y, accuracy: 0.01)
    }
}
