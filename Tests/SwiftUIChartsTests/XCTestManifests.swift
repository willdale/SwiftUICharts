import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LineChartTests.allTests),
        testCase(MultiLineChartTests.allTests),
        testCase(BarChartTests.allTests),
        testCase(GroupedChartTests.allTests),
        testCase(StackedChartTests.allTests),
        
        testCase(LineChartPathTests.allTests),
    ]
}
#endif
