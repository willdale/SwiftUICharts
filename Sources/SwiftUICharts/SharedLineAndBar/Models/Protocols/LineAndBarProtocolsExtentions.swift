//
//  LineAndBarProtocolsExtentions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

// MARK: - Data Set
extension GetDataProtocol where Self: CTChartData,
                                SetType: DataFunctionsProtocol,
                                CTStyle: CTLineBarChartStyle {
    public var range: Double {
        get {
            var _lowestValue: Double
            var _highestValue: Double
            
            switch self.chartStyle.baseline {
            case .minimumValue:
                _lowestValue = self.dataSets.minValue()
            case .minimumWithMaximum(of: let value):
                _lowestValue = min(self.dataSets.minValue(), value)
            case .zero:
                _lowestValue = 0
            }
            
            switch self.chartStyle.topLine {
            case .maximumValue:
                _highestValue = self.dataSets.maxValue()
            case .maximum(of: let value):
                _highestValue = max(self.dataSets.maxValue(), value)
            }
            
            return (_highestValue - _lowestValue) + 0.001
        }
    }
    
    public var minValue: Double {
        get {
            switch self.chartStyle.baseline {
            case .minimumValue:
                return self.dataSets.minValue()
            case .minimumWithMaximum(of: let value):
                return min(self.dataSets.minValue(), value)
            case .zero:
                return 0
            }
        }
    }
    
    public var maxValue: Double {
        get {
            switch self.chartStyle.topLine {
            case .maximumValue:
                return self.dataSets.maxValue()
            case .maximum(of: let value):
                return max(self.dataSets.maxValue(), value)
            }
        }
    }
    
    public var average: Double {
        return self.dataSets.average()
    }
}

// MARK: - Axes Titles
extension AxisY where Self: CTChartData & ViewDataProtocol,
                      CTStyle: CTLineBarChartStyle {
    /**
     Returns the title for y axis.
     
     This also informs `ViewData` of it width so
     that the positioning of the views in the x axis
     can be calculated.
     */
    public func getYAxisTitle(colour: AxisColour) -> some View {
        EmptyView()
//        Group {
//            if let title = self.chartStyle.yAxisTitle {
//                VStack {
//                    if self.chartStyle.xAxisLabelPosition == .top {
//                        Spacer()
//                            .frame(height: yAxisPaddingHeight)
//                    }
//                    VStack(spacing: 0) {
//                        Text(LocalizedStringKey(title))
//                            .font(self.chartStyle.yAxisTitleFont)
//                            .foregroundColor(self.chartStyle.yAxisTitleColour)
//                            .background(
//                                GeometryReader { geo in
//                                    Rectangle()
//                                        .foregroundColor(Color.clear)
//                                        .onAppear {
//                                            self.viewData.yAxisTitleWidth = geo.size.height + 10 // 10 to add padding
//                                            self.viewData.yAxisTitleHeight = geo.size.width
//                                        }
//                                }
//                            )
//                            .rotationEffect(Angle.init(degrees: -90), anchor: .center)
//                            .fixedSize()
//                            .frame(width: self.viewData.yAxisTitleWidth)
//                        Group {
//                            switch colour {
//                            case .none:
//                                EmptyView()
//                            case .style(let size):
//                                self.getAxisColourAsCircle(customColour: self.getColour(), width: size)
//                            case .custom(let colour, let size):
//                                self.getAxisColourAsCircle(customColour: colour, width: size)
//                            }
//                        }
//                        .offset(x: 0, y: self.viewData.yAxisTitleHeight / 2)
//                    }
//                    if self.chartStyle.xAxisLabelPosition == .bottom {
//                        Spacer()
//                            .frame(height: yAxisPaddingHeight)
//                    }
//                }
//            }
//        }
    }
}

extension AxisX where Self: CTChartData & ViewDataProtocol,
                      CTStyle: CTLineBarChartStyle {
    /**
     Returns the title for x axis.
     
     This also informs `ViewData` of it height so
     that the positioning of the views in the y axis
     can be calculated.
     */
    internal func getXAxisTitle() -> some View {
        Group {
            if let title = self.chartStyle.xAxisTitle {
                Text(LocalizedStringKey(title))
                    .font(self.chartStyle.xAxisTitleFont)
                    .foregroundColor(self.chartStyle.xAxisTitleColour)
                    .ifElse(self.chartStyle.xAxisLabelPosition == .bottom, if: {
                        $0.padding(.top, 2)
                    }, else: {
                        $0.padding(.bottom, 2)
                    })
                    .background(
                        GeometryReader { geo in
                            Rectangle()
                                .foregroundColor(Color.clear)
                                .onAppear {
                                    self.xAxisViewData.xAxisTitleHeight = geo.size.height + 10
                                }
                        }
                    )
            }
        }
    }
    @ViewBuilder
    internal func getAxisColourAsCircle(customColour: ChartColour, width: CGFloat) -> some View {
        Group {
            switch customColour {
            case let .colour(colour):
                HStack {
                    Circle()
                        .fill(colour)
                        .frame(width: width, height: width)
                }
            case let .gradient(colours, _, _):
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: colours),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: width, height: width)
                }
            case let .gradientStops(stops, _, _):
                let stops = stops
                HStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: width, height: width)
                }
            }
        }
    }
}
