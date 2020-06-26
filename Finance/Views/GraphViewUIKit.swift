//
//  GraphViewUIKit.swift
//  Finance
//
//  Created by Andrii Zuiok on 29.04.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//
import UIKit
import SwiftUI


class GraphView: UIView {
    @ObservedObject var viewModel: ChartViewModel
    var lineWidth: CGFloat = 2
    
    init(chartViewModel: ObservedObject<ChartViewModel>) {
        _viewModel = chartViewModel
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
            
            if let timeStamp = viewModel.chart?.chart?.result?.first??.timestamp,
                let meta = viewModel.chart?.chart?.result?.first??.meta,
                let quote = viewModel.chart?.chart?.result?.first??.indicators?.quote?.first,
                let extremums = viewModel.chartExtremums,
                let timeMarkerCount = viewModel.timeMarkerCount,
                let chartPreviousClose = meta.chartPreviousClose
            {
                if timeStamp.count > 0 {
                    let size = rect.size
                    let rangeY = extremums.lowMin..<extremums.highMax
                    
                    
                    let stepX = size.width / CGFloat(timeMarkerCount)
                    
                    //let stepX = size.width / (timeMarkerCount - CGFloat(timeStamp.count) + CGFloat(flatArray.count))
                    
                    let clippingPath = UIBezierPath()
                    
                    let context = UIGraphicsGetCurrentContext()!
                    
                    context.beginPath()
                    
                    context.move(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: chartPreviousClose, size: size, rangeY: rangeY)))
                    
                    context.addLine(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: (quote.open?[0] ?? chartPreviousClose), size: size, rangeY: rangeY)))
                    
                    context.setStrokeColor(((quote.close?[0] ?? chartPreviousClose) - chartPreviousClose).sign == .plus ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor)

                    for index in 1..<timeStamp.count {
                        
                        //if let close = quote.close, let _ = close[index] {
                        if (priceForIndex(index) - chartPreviousClose).sign == (priceForIndex(index - 1) - chartPreviousClose).sign {
                                
                                context.setStrokeColor((priceForIndex(index) - chartPreviousClose).sign == .plus ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor)
                            
                                context.addLine(to: CGPoint(
                                    x: CGFloat(index) * stepX,
                                    y: coordinateY(price: priceForIndex(index), size: size, rangeY: rangeY)))
                            } else {
                                
                                context.addLine(to: CGPoint(
                                    x: betweenCoordinateX(index: index, deltaX: stepX),
                                    y: coordinateY(price: chartPreviousClose, size: size, rangeY: rangeY)))
                                
                                clippingPath.append(UIBezierPath(cgPath: context.path!))
                                
                                context.strokePath()
                                
                                context.beginPath()
                                context.move(to: CGPoint(
                                    x: betweenCoordinateX(index: index, deltaX: stepX),
                                    y: coordinateY(price: chartPreviousClose, size: size, rangeY: rangeY)))
                            }
                    }
                    
                    clippingPath.append(UIBezierPath(cgPath: context.path!))
                    
                    clippingPath.addLine(to: CGPoint(
                        x: clippingPath.bounds.origin.x + clippingPath.bounds.size.width,
                        y: coordinateY(price: chartPreviousClose, size: size, rangeY: rangeY)))
                    
                    context.strokePath()
                    
                    clippingPath.addClip()
                    gradientFill(context: context, size: size, rangeY: rangeY)
                    
                    context.move(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: chartPreviousClose, size: size, rangeY: rangeY)))
                    
                    context.addLine(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: quote.close?[0] ?? chartPreviousClose, size: size, rangeY: rangeY)))
                    
                    context.setStrokeColor(UIColor.systemBackground.withAlphaComponent(0.5).cgColor)
                    context.strokePath()
                    
                    context.resetClip()
                    
                    context.move(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: chartPreviousClose, size: size, rangeY: rangeY)))
                    context.addLine(to: CGPoint(
                        x: size.width,
                        y: coordinateY(price: chartPreviousClose, size: size, rangeY: rangeY)))
                    context.setLineDash(phase: 0.0, lengths: [2.0, 2.0])
                    context.setStrokeColor(UIColor.systemGray.cgColor)
                    
                    //context.setStrokeColor((meta.regularMarketPrice ?? 0) > chartPreviousClose ? UIColor.systemGreen.cgColor : UIColor.systemRed.withAlphaComponent(0.7).cgColor)
                    context.setLineWidth(1)

                    context.strokePath()
                }
            }
        }
        
        private func betweenCoordinateX(index: Int, deltaX: CGFloat) -> CGFloat {
            //print(index)
            
            guard let quote = viewModel.chart?.chart?.result?.first??.indicators?.quote?.first,
                let meta = viewModel.chart?.chart?.result?.first??.meta, let chartPreviousClose = meta.chartPreviousClose else { return 0 }
            //debugPrint("chartPreviousClose = \(chartPreviousClose)")
            //debugPrint("priceForIndex(\(index) = \(priceForIndex(index))")
            
            
            let previousPrice = (index == 1 ? (quote.close?[0] ?? chartPreviousClose) : (priceForIndex(index - 1)))
            //debugPrint("previousPrice = \(previousPrice)")
            
            let deltaY = CGFloat(priceForIndex(index) - previousPrice)
            
            //debugPrint("deltaY = \(deltaY)")
            
            let differential = deltaX / deltaY
            
            
            let coordinateX = deltaX * CGFloat(index - 1) + CGFloat(priceForIndex(index) - chartPreviousClose) * differential
            //debugPrint("coordinateX = \(coordinateX)")
            
            return coordinateX
        }
        
        private func priceForIndex(_ index: Int) -> Double {
            
            guard let quote = viewModel.chart?.chart?.result?.first??.indicators?.quote?.first,
            let meta = viewModel.chart?.chart?.result?.first??.meta, let chartPreviousClose = meta.chartPreviousClose else { return 0 }
            
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
    
            guard let meta = viewModel.chart?.chart?.result?.first??.meta, let chartPreviousClose = meta.chartPreviousClose else { return 0 }
            
            let maxY = CGFloat(chartPreviousClose) > CGFloat(rangeY.upperBound) ? CGFloat(chartPreviousClose) : CGFloat(rangeY.upperBound)
            let minY = CGFloat(chartPreviousClose) < CGFloat(rangeY.lowerBound) ? CGFloat(chartPreviousClose) : CGFloat(rangeY.lowerBound)
            
            return size.height * (1 - (CGFloat(price) - minY) / (maxY - minY))
        }
        
        private func gradientFill(context: CGContext, size: CGSize, rangeY: Range<Double>) {
            
            guard let meta = viewModel.chart?.chart?.result?.first??.meta, let chartPreviousClose = meta.chartPreviousClose else {return}
                
            let colors = [UIColor.systemGreen.withAlphaComponent(0.1).cgColor, UIColor.systemBackground.withAlphaComponent(1.0).cgColor, UIColor.systemRed.withAlphaComponent(0.1).cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var positionForWhiteColor = CGFloat((rangeY.upperBound - chartPreviousClose) / rangeY.distance)
            if positionForWhiteColor > 1.0 {
                positionForWhiteColor = 1.0
            } else if positionForWhiteColor < 0.0 {
                positionForWhiteColor = 0.0
            }
            let colorLocations: [CGFloat] = [0.0, positionForWhiteColor, 1.0]
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
            
            context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: [])
        }
}

struct GraphViewUIKit: UIViewRepresentable {
    @ObservedObject var viewModel: ChartViewModel
 
    func makeUIView(context: UIViewRepresentableContext<GraphViewUIKit>) -> UIView {
        let graphView = GraphView(chartViewModel: _viewModel)
        graphView.backgroundColor = .clear
        return graphView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<GraphViewUIKit>) {
        uiView.setNeedsDisplay()
    }
}

struct GraphViewUIKit_Previews: PreviewProvider {
    static var previews: some View {
        GraphViewUIKit(viewModel: ChartViewModel(withJSON: "AAPL"))
    }
}
