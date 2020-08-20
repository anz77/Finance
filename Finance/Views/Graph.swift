//
//  Graph.swift
//  Finance
//
//  Created by Andrii Zuiok on 10.08.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation
import SwiftUI


class Graph: UIView  {
    
    @ObservedObject var viewModel: DetailChartViewModel
    
    var lineWidth: CGFloat = 2
    
    init(chartViewModel: ObservedObject<DetailChartViewModel>) {
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
                let timeMarkerCount = viewModel.timeMarkerCount,
                let chartPreviousClose = meta.chartPreviousClose
            {
                if timeStamp.count > 0 {
                    let size = rect.size
                    
                    let stepX = size.width / CGFloat(timeMarkerCount)
                    
                    let clippingPath = UIBezierPath()
                    
                    let context = UIGraphicsGetCurrentContext()!
                    
                    context.beginPath()
                    
                    context.move(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: chartPreviousClose, size: size)))
                    
                    context.addLine(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: (quote?.open?[0] ?? chartPreviousClose), size: size)))
                    
                    context.setStrokeColor(((quote?.close?[0] ?? chartPreviousClose) - chartPreviousClose).sign == .plus ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor)

                    for index in 1..<timeStamp.count {
                        
                        //if let close = quote.close, let _ = close[index] {
                        if (self.viewModel.priceForIndex(index) - chartPreviousClose).sign == (self.viewModel.priceForIndex(index - 1) - chartPreviousClose).sign {
                                
                                context.setStrokeColor((self.viewModel.priceForIndex(index) - chartPreviousClose).sign == .plus ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor)
                            
                                context.addLine(to: CGPoint(
                                    x: CGFloat(index) * stepX,
                                    y: coordinateY(price: self.viewModel.priceForIndex(index), size: size)))
                            } else {
                                
                                context.addLine(to: CGPoint(
                                    x: betweenCoordinateX(index: index, deltaX: stepX),
                                    y: coordinateY(price: chartPreviousClose, size: size)))
                                
                                clippingPath.append(UIBezierPath(cgPath: context.path!))
                                
                                context.strokePath()
                                
                                context.beginPath()
                                context.move(to: CGPoint(
                                    x: betweenCoordinateX(index: index, deltaX: stepX),
                                    y: coordinateY(price: chartPreviousClose, size: size)))
                            }
                    }
                    
                    clippingPath.append(UIBezierPath(cgPath: context.path!))
                    
                    clippingPath.addLine(to: CGPoint(
                        x: clippingPath.bounds.origin.x + clippingPath.bounds.size.width,
                        y: coordinateY(price: chartPreviousClose, size: size)))
                    
                    context.strokePath()
                    
                    clippingPath.addClip()
                    gradientFill(context: context, size: size)
                    
                    context.move(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: chartPreviousClose, size: size)))
                    
                    context.addLine(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: quote?.close?[0] ?? chartPreviousClose, size: size)))
                    
                    context.setStrokeColor(UIColor.systemBackground.withAlphaComponent(0.5).cgColor)
                    context.strokePath()
                    
                    context.resetClip()
                    
                    context.move(to: CGPoint(
                        x: 0,
                        y: coordinateY(price: chartPreviousClose, size: size)))
                    context.addLine(to: CGPoint(
                        x: size.width,
                        y: coordinateY(price: chartPreviousClose, size: size)))
                    context.setLineDash(phase: 0.0, lengths: [2.0, 2.0])
                    context.setStrokeColor(UIColor.systemGray.cgColor)
                    
                    //context.setStrokeColor((meta.regularMarketPrice ?? 0) > chartPreviousClose ? UIColor.systemGreen.cgColor : UIColor.systemRed.withAlphaComponent(0.7).cgColor)
                    context.setLineWidth(1)

                    context.strokePath()
                }
            }
        }
        
        private func betweenCoordinateX(index: Int, deltaX: CGFloat) -> CGFloat {
            
            guard let quote = viewModel.chart?.chart?.result?.first??.indicators?.quote?.first,
                let meta = viewModel.chart?.chart?.result?.first??.meta, let chartPreviousClose = meta.chartPreviousClose else { return 0 }
            let previousPrice = (index == 1 ? (quote?.close?[0] ?? chartPreviousClose) : (self.viewModel.priceForIndex(index - 1)))
            let deltaY = CGFloat(self.viewModel.priceForIndex(index) - previousPrice)
            let differential = deltaX / deltaY
            let coordinateX = deltaX * CGFloat(index - 1) + CGFloat(self.viewModel.priceForIndex(index) - chartPreviousClose) * differential
            return coordinateX
        }
        
        private func coordinateY(price: Double, size: CGSize) -> CGFloat {
    
            guard let meta = viewModel.chart?.chart?.result?.first??.meta, let chartPreviousClose = meta.chartPreviousClose,  let extremums = viewModel.chartExtremums else { return 0 }
            
            let rangeY = extremums.lowMin..<extremums.highMax
            
            let maxY = CGFloat(chartPreviousClose) > CGFloat(rangeY.upperBound) ? CGFloat(chartPreviousClose) : CGFloat(rangeY.upperBound)
            let minY = CGFloat(chartPreviousClose) < CGFloat(rangeY.lowerBound) ? CGFloat(chartPreviousClose) : CGFloat(rangeY.lowerBound)
            
            
            if maxY - minY != 0 {
                return size.height * (1 - (CGFloat(price) - minY) / (maxY - minY))
            } else {
                return size.height * 0.5
            }
            
        }
        
        private func gradientFill(context: CGContext, size: CGSize) {
            
            guard let meta = viewModel.chart?.chart?.result?.first??.meta, let chartPreviousClose = meta.chartPreviousClose, let extremums = viewModel.chartExtremums else {return}
            let rangeY = extremums.lowMin..<extremums.highMax
                
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

struct GraphViewUI: UIViewRepresentable  {
    @ObservedObject var viewModel: DetailChartViewModel
 
    func makeUIView(context: UIViewRepresentableContext<GraphViewUI>) -> UIView {
        let graphView = GraphView(chartViewModel: _viewModel)
        graphView.backgroundColor = .clear
        return graphView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<GraphViewUI>) {
        uiView.setNeedsDisplay()
    }
}



struct GraphViewUI_Previews: PreviewProvider {
    static var previews: some View {
        GraphViewUI(viewModel: DetailChartViewModel(withJSON: "AAPL"))
    }
}
