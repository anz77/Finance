//
//  ChartViewProtocol.swift
//  Finance
//
//  Created by Andrii Zuiok on 08.08.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation
import Combine


//MARK: - TIMEINTERVAL
enum TimeInterval: String {
     //1m,2m,5m,15m,30m,60m,90m,1h,1d,5d,1wk,1mo,3mo
     case oneMinit = "1m" // for 7 days...
     case twoMinit = "2m" // for 60 days...
     case fiveMinit = "5m" // for 60 days...
     case fivetenMinit = "15m" // for 60 days...
     case thirtyMinit = "30m" // for 60 days...
     //case sixtyMinit = "60m" // for 730 days (2 years)...
     //case nineteeMinit = "90m" // for 60 days...
     case oneHour = "1h" // for 730 days (2 years)...
     case oneDay = "1d" // for infinity...
     case fiveDay = "5d" // for infinity...
     case oneWeak = "1wk" // for infinity...
     case oneMonth = "1mo" // for infinity...
     case threeMonth = "3mo" // for infinity...
    
    //[1m, 2m, 5m, 15m, 30m, 60m, 90m, 1h, 1d, 5d, 1wk, 1mo, 3mo]
 }

//MARK: - PRIOD
 enum Period: String {
     // 1d,5d,1mo,3mo,6mo,1y,2y,5y,10y,ytd,max
     case oneDay = "1d" // accessed intervals: 1m,2m,5m,15m,30m,60m,90m,1h
     case fiveDays = "5d" // accessed intervals: 1m,2m,5m,15m,30m,60m,90m,1h
     case oneMonth = "1mo" // accessed intervals: 2m,5m,15m,30m,60m,90m,1h,1d
     //case threeMonth = "3mo" // accessed intervals: 2m,5m,15m,30m,60m,90m,1h,1d,5d,1wk,1mo
     case sixMonth = "6mo" // accessed intervals: 1h,1d,5d,1wk,1mo,3mo
     case oneYear = "1y" // accessed intervals: 1h,1d,5d,1wk,1mo,3mo
     //case twoYear = "2y" // accessed intervals: 1h,1d,5d,1wk,1mo,3mo
     case fiveYear = "5y" // accessed intervals: 1d,5d,1wk,1mo,3mo
     //case tenYear = "10y" // accessed intervals: 1d,5d,1wk,1mo,3mo
     case ytd = "ytd" // accessed intervals: 1d,5d,1wk,1mo,3mo
     case max = "max" // accessed intervals: 1d,5d,1wk,1mo,3mo
 }


//MARK: - CHARTVIEWMODEL
struct ChartExtremums {
    let lowMin: Double
    let lowMax: Double
    let highMin: Double
    let highMax: Double
    let openMin: Double
    let openMax: Double
    let closeMin: Double
    let closeMax: Double
}


protocol ChartViewProtocol: ObservableObject, Identifiable {
    
    var session: URLSession? { get set }
    
    func setAndConfigureSession()
    
    var chart: HistoricalChart? { get set }
    var fundamental: Fundamental? { get set }
    
    var timeInterval: TimeInterval? { get set }
    var chartExtremums: ChartExtremums? { get set }
    var timeMarkerCount: Int? { get set }
    
    func setSubscriptions()
    func cancelSubscriptions()
    func start()
    func getChartExtremumsFrom(_ historicalChart: HistoricalChart?)
    func getTimeMarkerCount(from historicalChart: HistoricalChart?)
    func priceForIndex(_ index: Int) -> Double
    
}


extension ChartViewProtocol {
    
    
    func setAndConfigureSession() {
        let configuration = URLSessionConfiguration.default
        //configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }
    
    func getChartExtremumsFrom(_ historicalChart: HistoricalChart?) {
        if let quote = historicalChart?.chart?.result?.first??.indicators?.quote?.first {
             
            if let lowMin = quote?.low?.compactMap({$0}).min(), let lowMax = quote?.low?.compactMap({$0}).max(), let highMin = quote?.high?.compactMap({$0}).min(), let highMax = quote?.high?.compactMap({$0}).max(), let openMin = quote?.open?.compactMap({$0}).min(), let openMax = quote?.open?.compactMap({$0}).max(), let closeMin = quote?.close?.compactMap({$0}).min(), let closeMax = quote?.close?.compactMap({$0}).max() {
                self.chartExtremums = ChartExtremums(lowMin: lowMin, lowMax: lowMax, highMin: highMin, highMax: highMax, openMin: openMin, openMax: openMax, closeMin: closeMin, closeMax: closeMax)
            }
        }
    }
    
    func getTimeMarkerCount(from historicalChart: HistoricalChart?) {
        guard let meta = historicalChart?.chart?.result?.first??.meta, let timeStamp = historicalChart?.chart?.result?.first??.timestamp, let timeStampCount = historicalChart?.chart?.result?.first??.timestamp?.count else { return }
        
        var dataGranularity: Int
        if timeStampCount > 1 {
            dataGranularity = timeStamp[1] - timeStamp[0]
        } else {
            switch meta.dataGranularity {
            case "1m":
                dataGranularity = 60
            case "2m":
                dataGranularity = 120
            case "3m":
                dataGranularity = 180
            case "5m":
                dataGranularity = 300
            case "15m":
                dataGranularity = 900
            case "30m":
                dataGranularity = 1800
            case "1h":
                dataGranularity = 3600
            case "1d":
                dataGranularity = 86400
            case "1wk":
                dataGranularity = 604800
            case "1mo":
                dataGranularity = 2529200
            case "3mo":
                dataGranularity = 7776000
            default:
                dataGranularity = 60
            }
        }
        
        if let tradingPeriods = meta.tradingPeriods {
            var count = 0
            for tradingPeriod in tradingPeriods {
                let tp = tradingPeriod.first
                let dayTimeMarkerCount = ((tp??.end ?? 0) - (tp??.start ?? 0)) / dataGranularity
                count += dayTimeMarkerCount
            }
            self.timeMarkerCount = count
        } else {
            self.timeMarkerCount = timeStampCount
        }
    }

    func priceForIndex(_ index: Int) -> Double {
        
        guard let quote = self.chart?.chart?.result?.first??.indicators?.quote?.first,
            let meta = self.chart?.chart?.result?.first??.meta, let chartPreviousClose = meta.chartPreviousClose else { return 0 }
        
        if let close = quote?.close?[index] {
            return close
        } else {
            var nonNullIndex = index
            while quote?.close?[nonNullIndex] == nil || quote?.open?[nonNullIndex] == nil || quote?.low?[nonNullIndex] == nil || quote?.high?[nonNullIndex] == nil {
                nonNullIndex = nonNullIndex - 1
            }
            return quote?.close?[nonNullIndex] ?? chartPreviousClose
        }
    }
    
}
