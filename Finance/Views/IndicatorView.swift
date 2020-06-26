//
//  IndicatorView.swift
//  Finance
//
//  Created by Andrii Zuiok on 29.03.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI

struct IndicatorView : View {
    @Environment(\.colorScheme) var colorSchema: ColorScheme
    @State var color: Color = Color(.blue)
    
    @State var positionIndicator: CGFloat = 1.5
    @Binding var indicatorViewIsVisible: Bool
    @Binding var timeStampIndex: Int?
    
    @ObservedObject var viewModel: ChartViewModel
    
    var timeStamp: [Int] { self.viewModel.chart?.chart?.result?.first??.timestamp ?? [] }
    var meta: Meta? { self.viewModel.chart?.chart?.result?.first??.meta }
    var quote: HistoricalChartQuote? { viewModel.chart?.chart?.result?.first??.indicators?.quote?.first }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                if self.timeStamp.count > 0 {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x:0 , y: geometry.size.height))
                    }.stroke(Color(.systemGray), lineWidth: 2).frame(height: geometry.size.height)
                    
                    Path { path in
                        
                        let index = Int(self.positionIndicator * CGFloat(self.viewModel.timeMarkerCount ?? self.timeStamp.count))   //////// FAIL!!!!!!!!!!
                        if index >= 0 {
                            DispatchQueue.main.async { self.timeStampIndex = index }
                            if index < self.timeStamp.count {
                                let rangeY = (self.viewModel.chartExtremums?.lowMin ?? 0)..<(self.viewModel.chartExtremums?.highMax ?? 0)
                                let circlePositionY = self.coordinateY(price: self.priceForIndex(index), size: geometry.size, rangeY: rangeY)
                                path.addArc(center: CGPoint(x: 0, y: circlePositionY), radius: 5, startAngle: Angle(radians: 0.0), endAngle: Angle(radians: Double.pi * 2), clockwise: true)
                            }
                        }
                        
                    }.fill(self.color).frame(height: geometry.size.height)
                }
            }
            .frame(height: geometry.size.height)
            .offset(x: self.positionIndicator * geometry.size.width)
            .layoutPriority(1)
            .contentShape(Rectangle())
            .gesture(DragGesture()
            .onChanged({ value in
                
                let parterValue = value.location.x / geometry.size.width
                let divide = (CGFloat(self.timeStamp.count - 1) / CGFloat(self.viewModel.timeMarkerCount ?? self.timeStamp.count))
                
                /*let index = Int(self.positionIndicator * CGFloat(self.viewModel.timeMarkerCount ?? self.timeStamp.count))
                 debugPrint("parterValue = \(parterValue), devide = \(devide), index = \(index), tineMarkCount = \(String(describing: self.viewModel.timeMarkerCount))")*/
                
                if parterValue < divide {
                    self.positionIndicator = parterValue
                    self.indicatorViewIsVisible = true
                } else if parterValue > divide {
                    self.positionIndicator = divide
                }
            })
                .onEnded { value in
                    self.positionIndicator = 1.5
                    self.indicatorViewIsVisible = false
                }
            )
        }
        
    }
    
    private func foregroundColor(for value: Double?) -> UIColor {
        return value == nil ? UIColor.clear : (value! == 0.0 ? UIColor.lightGray : (value! > 0.0 ? UIColor.systemGreen : UIColor.systemRed))
    }
    
    private func priceForIndex(_ index: Int) -> Double {
        
        guard let quote = quote,
            let meta = meta, let chartPreviousClose = meta.chartPreviousClose else { return 0 }
        
        if let close = quote.close?[index] {
            return close
        } else {
            var nonNullIndex = index
            while quote.close?[nonNullIndex] == nil || quote.open?[nonNullIndex] == nil || quote.low?[nonNullIndex] == nil || quote.high?[nonNullIndex] == nil {
                nonNullIndex = nonNullIndex - 1
            }
            return quote.close?[nonNullIndex] ?? chartPreviousClose
        }
    }
    
    private func coordinateY(price: Double, size: CGSize, rangeY: Range<Double>) -> CGFloat {
        
        guard let meta = meta, let chartPreviousClose = meta.chartPreviousClose else { return 0 }
        
        let maxY = CGFloat(chartPreviousClose) > CGFloat(rangeY.upperBound) ? CGFloat(chartPreviousClose) : CGFloat(rangeY.upperBound)
        let minY = CGFloat(chartPreviousClose) < CGFloat(rangeY.lowerBound) ? CGFloat(chartPreviousClose) : CGFloat(rangeY.lowerBound)
        
        return size.height * (1 - (CGFloat(price) - minY) / (maxY - minY))
    }
    
}


struct IndicatorView_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            IndicatorView(indicatorViewIsVisible: .constant(false), timeStampIndex: .constant(0), viewModel: ChartViewModel(withJSON: "BTCUSD"))
        }
            .colorScheme(.dark)
    }
}
