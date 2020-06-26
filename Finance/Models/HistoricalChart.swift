//
//  Historical.swift
//  Finance
//
//  Created by Andrii Zuiok on 04.04.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let historical = try? newJSONDecoder().decode(Historical.self, from: jsonData)

import Foundation

// MARK: - Historical
public struct HistoricalChart: Codable {
    public let chart: Chart?

    enum CodingKeys: String, CodingKey {
        case chart = "chart"
    }

    public init(chart: Chart?) {
        self.chart = chart
    }
    
    public func filterChart() {
        
    }
}

// MARK: - Chart
public struct Chart: Codable {
    public let result: [ChartResult?]?
    public let error: YFError?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }

    public init(result: [ChartResult?]?, error: YFError?) {
        self.result = result
        self.error = error
    }
}

// MARK: - Result
public struct ChartResult: Codable {
    public let meta: Meta?
    public let timestamp: [Int]?
    public let events: Events?
    public let indicators: Indicators?

    enum CodingKeys: String, CodingKey {
        case meta = "meta"
        case timestamp = "timestamp"
        case events = "events"
        case indicators = "indicators"
    }

    public init(meta: Meta?, timestamp: [Int]?, events: Events?, indicators: Indicators?) {
        self.meta = meta
        self.timestamp = timestamp
        self.events = events
        self.indicators = indicators
    }
}

// MARK: - Events
public struct Events: Codable {
    public let dividends: [String: Dividend]?
    public let splits: [String: Split]?

    enum CodingKeys: String, CodingKey {
        case dividends = "dividends"
        case splits = "splits"
    }

    public init(dividends: [String: Dividend]?, splits: [String: Split]?) {
        self.dividends = dividends
        self.splits = splits
    }
}

// MARK: - Dividend
public struct Dividend: Codable {
    public let amount: Double?
    public let date: Int?

    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case date = "date"
    }

    public init(amount: Double?, date: Int?) {
        self.amount = amount
        self.date = date
    }
}

// MARK: - Split
public struct Split: Codable {
    public let date: Int?
    public let numerator: Int?
    public let denominator: Int?
    public let splitRatio: String?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case numerator = "numerator"
        case denominator = "denominator"
        case splitRatio = "splitRatio"
    }

    public init(date: Int?, numerator: Int?, denominator: Int?, splitRatio: String?) {
        self.date = date
        self.numerator = numerator
        self.denominator = denominator
        self.splitRatio = splitRatio
    }
}

// MARK: - Indicators
public struct Indicators: Codable {
    public let quote: [HistoricalChartQuote]?
    public let adjclose: [AdjClose?]?

    enum CodingKeys: String, CodingKey {
        case quote = "quote"
        case adjclose = "adjclose"
    }

    public init(quote: [HistoricalChartQuote]?, adjclose: [AdjClose?]?) {
        self.quote = quote
        self.adjclose = adjclose
    }
}

// MARK: - Adjclose
public struct AdjClose: Codable {
    public let adjClose: [Double?]?

    enum CodingKeys: String, CodingKey {
        case adjClose = "adjclose"
    }

    public init(adjclose: [Double?]?) {
        self.adjClose = adjclose
    }
}

// MARK: - Quote
public struct HistoricalChartQuote: Codable {
    public let open: [Double?]?
    public let close: [Double?]?
    public let low: [Double?]?
    public let high: [Double?]?
    public let volume: [Int?]?

    enum CodingKeys: String, CodingKey {
        case open = "open"
        case close = "close"
        case low = "low"
        case high = "high"
        case volume = "volume"
    }

    public init(open: [Double?]?, close: [Double?]?, low: [Double?]?, high: [Double?]?, volume: [Int?]?) {
        self.open = open
        self.close = close
        self.low = low
        self.high = high
        self.volume = volume
    }
}

// MARK: - Meta
public struct Meta: Codable {
    public let currency: String?
    public let symbol: String?
    public let exchangeName: String?
    public let instrumentType: String?
    public let firstTradeDate: Int?
    public let regularMarketTime: Int?
    public let gmtoffset: Int?
    public let timezone: String?
    public let exchangeTimezoneName: String?
    public let regularMarketPrice: Double?
    public let chartPreviousClose: Double?
    public let previousClose: Double?
    public let scale: Int?
    public let priceHint: Int?
    public let currentTradingPeriod: CurrentTradingPeriod?
    public let tradingPeriods: [[TradingPeriod?]]?
    public let dataGranularity: String?
    public let range: String?
    public let validRanges: [String]?

    enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case symbol = "symbol"
        case exchangeName = "exchangeName"
        case instrumentType = "instrumentType"
        case firstTradeDate = "firstTradeDate"
        case regularMarketTime = "regularMarketTime"
        case gmtoffset = "gmtoffset"
        case timezone = "timezone"
        case exchangeTimezoneName = "exchangeTimezoneName"
        case regularMarketPrice = "regularMarketPrice"
        case chartPreviousClose = "chartPreviousClose"
        case previousClose = "previousClose"
        case scale = "scale"
        case priceHint = "priceHint"
        case currentTradingPeriod = "currentTradingPeriod"
        case tradingPeriods = "tradingPeriods"
        case dataGranularity = "dataGranularity"
        case range = "range"
        case validRanges = "validRanges"
    }

    public init(currency: String?, symbol: String?, exchangeName: String?, instrumentType: String?, firstTradeDate: Int?, regularMarketTime: Int?, gmtoffset: Int?, timezone: String?, exchangeTimezoneName: String?, regularMarketPrice: Double?, chartPreviousClose: Double?, previousClose: Double?, scale: Int?, priceHint: Int?, currentTradingPeriod: CurrentTradingPeriod?, tradingPeriods: [[TradingPeriod?]]?, dataGranularity: String?, range: String?, validRanges: [String]?) {
        self.currency = currency
        self.symbol = symbol
        self.exchangeName = exchangeName
        self.instrumentType = instrumentType
        self.firstTradeDate = firstTradeDate
        self.regularMarketTime = regularMarketTime
        self.gmtoffset = gmtoffset
        self.timezone = timezone
        self.exchangeTimezoneName = exchangeTimezoneName
        self.regularMarketPrice = regularMarketPrice
        self.chartPreviousClose = chartPreviousClose
        self.previousClose = previousClose
        self.scale = scale
        self.priceHint = priceHint
        self.currentTradingPeriod = currentTradingPeriod
        self.tradingPeriods = tradingPeriods
        self.dataGranularity = dataGranularity
        self.range = range
        self.validRanges = validRanges
    }
}

// MARK: - CurrentTradingPeriod
public struct CurrentTradingPeriod: Codable {
    public let pre: TradingPeriod?
    public let regular: TradingPeriod?
    public let post: TradingPeriod?

    enum CodingKeys: String, CodingKey {
        case pre = "pre"
        case regular = "regular"
        case post = "post"
    }

    public init(pre: TradingPeriod?, regular: TradingPeriod?, post: TradingPeriod?) {
        self.pre = pre
        self.regular = regular
        self.post = post
    }
}

// MARK: - Post
public struct TradingPeriod: Codable {
    public let timezone: String?
    public let start: Int?
    public let end: Int?
    public let gmtoffset: Int?

    enum CodingKeys: String, CodingKey {
        case timezone = "timezone"
        case start = "start"
        case end = "end"
        case gmtoffset = "gmtoffset"
    }

    public init(timezone: String?, start: Int?, end: Int?, gmtoffset: Int?) {
        self.timezone = timezone
        self.start = start
        self.end = end
        self.gmtoffset = gmtoffset
    }
}

/*
// MARK: - TradingPeriods
public struct TradingPeriods: Codable {
    public let pre: [[TradingPeriod]]
    public let post: [[TradingPeriod]]
    public let regular: [[TradingPeriod]]

    enum CodingKeys: String, CodingKey {
        case pre = "pre"
        case post = "post"
        case regular = "regular"
    }

    public init(pre: [[TradingPeriod]], post: [[TradingPeriod]], regular: [[TradingPeriod]]) {
        self.pre = pre
        self.post = post
        self.regular = regular
    }
}
*/

