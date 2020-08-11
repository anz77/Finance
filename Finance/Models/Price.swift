//
//  Price.swift
//  Finance
//
//  Created by Andrii Zuiok on 10.08.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation


// MARK: - Price
public struct Price {
    public var quoteSummary: QuoteSummary?

    public init(quoteSummary: QuoteSummary?) {
        self.quoteSummary = quoteSummary
    }
}

// MARK: - QuoteSummary
public struct QuoteSummary {
    public var result: [Result]?
    public var error: NSNull?

    public init(result: [Result]?, error: NSNull?) {
        self.result = result
        self.error = error
    }
}

// MARK: - Result
public struct Result {
    public var price: PriceClass?

    public init(price: PriceClass?) {
        self.price = price
    }
}

// MARK: - PriceClass
public struct PriceClass {
    public var maxAge: Int?
    public var preMarketChangePercent: PreMarketChange?
    public var preMarketChange: PreMarketChange?
    public var preMarketTime: Int?
    public var preMarketPrice: PreMarketChange?
    public var preMarketSource: String?
    public var postMarketChange: AverageDailyVolume10Day?
    public var postMarketPrice: AverageDailyVolume10Day?
    public var regularMarketChangePercent: PreMarketChange?
    public var regularMarketChange: PreMarketChange?
    public var regularMarketTime: Int?
    public var priceHint: MarketCap?
    public var regularMarketPrice: PreMarketChange?
    public var regularMarketDayHigh: PreMarketChange?
    public var regularMarketDayLow: PreMarketChange?
    public var regularMarketVolume: MarketCap?
    public var averageDailyVolume10Day: AverageDailyVolume10Day?
    public var averageDailyVolume3Month: AverageDailyVolume10Day?
    public var regularMarketPreviousClose: PreMarketChange?
    public var regularMarketSource: String?
    public var regularMarketOpen: PreMarketChange?
    public var strikePrice: AverageDailyVolume10Day?
    public var openInterest: AverageDailyVolume10Day?
    public var exchange: String?
    public var exchangeName: String?
    public var exchangeDataDelayedBy: Int?
    public var marketState: String?
    public var quoteType: String?
    public var symbol: String?
    public var underlyingSymbol: NSNull?
    public var shortName: String?
    public var longName: String?
    public var currency: String?
    public var quoteSourceName: String?
    public var currencySymbol: String?
    public var fromCurrency: NSNull?
    public var toCurrency: NSNull?
    public var lastMarket: NSNull?
    public var volume24Hr: AverageDailyVolume10Day?
    public var volumeAllCurrencies: AverageDailyVolume10Day?
    public var circulatingSupply: AverageDailyVolume10Day?
    public var marketCap: MarketCap?

    public init(maxAge: Int?, preMarketChangePercent: PreMarketChange?, preMarketChange: PreMarketChange?, preMarketTime: Int?, preMarketPrice: PreMarketChange?, preMarketSource: String?, postMarketChange: AverageDailyVolume10Day?, postMarketPrice: AverageDailyVolume10Day?, regularMarketChangePercent: PreMarketChange?, regularMarketChange: PreMarketChange?, regularMarketTime: Int?, priceHint: MarketCap?, regularMarketPrice: PreMarketChange?, regularMarketDayHigh: PreMarketChange?, regularMarketDayLow: PreMarketChange?, regularMarketVolume: MarketCap?, averageDailyVolume10Day: AverageDailyVolume10Day?, averageDailyVolume3Month: AverageDailyVolume10Day?, regularMarketPreviousClose: PreMarketChange?, regularMarketSource: String?, regularMarketOpen: PreMarketChange?, strikePrice: AverageDailyVolume10Day?, openInterest: AverageDailyVolume10Day?, exchange: String?, exchangeName: String?, exchangeDataDelayedBy: Int?, marketState: String?, quoteType: String?, symbol: String?, underlyingSymbol: NSNull?, shortName: String?, longName: String?, currency: String?, quoteSourceName: String?, currencySymbol: String?, fromCurrency: NSNull?, toCurrency: NSNull?, lastMarket: NSNull?, volume24Hr: AverageDailyVolume10Day?, volumeAllCurrencies: AverageDailyVolume10Day?, circulatingSupply: AverageDailyVolume10Day?, marketCap: MarketCap?) {
        self.maxAge = maxAge
        self.preMarketChangePercent = preMarketChangePercent
        self.preMarketChange = preMarketChange
        self.preMarketTime = preMarketTime
        self.preMarketPrice = preMarketPrice
        self.preMarketSource = preMarketSource
        self.postMarketChange = postMarketChange
        self.postMarketPrice = postMarketPrice
        self.regularMarketChangePercent = regularMarketChangePercent
        self.regularMarketChange = regularMarketChange
        self.regularMarketTime = regularMarketTime
        self.priceHint = priceHint
        self.regularMarketPrice = regularMarketPrice
        self.regularMarketDayHigh = regularMarketDayHigh
        self.regularMarketDayLow = regularMarketDayLow
        self.regularMarketVolume = regularMarketVolume
        self.averageDailyVolume10Day = averageDailyVolume10Day
        self.averageDailyVolume3Month = averageDailyVolume3Month
        self.regularMarketPreviousClose = regularMarketPreviousClose
        self.regularMarketSource = regularMarketSource
        self.regularMarketOpen = regularMarketOpen
        self.strikePrice = strikePrice
        self.openInterest = openInterest
        self.exchange = exchange
        self.exchangeName = exchangeName
        self.exchangeDataDelayedBy = exchangeDataDelayedBy
        self.marketState = marketState
        self.quoteType = quoteType
        self.symbol = symbol
        self.underlyingSymbol = underlyingSymbol
        self.shortName = shortName
        self.longName = longName
        self.currency = currency
        self.quoteSourceName = quoteSourceName
        self.currencySymbol = currencySymbol
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.lastMarket = lastMarket
        self.volume24Hr = volume24Hr
        self.volumeAllCurrencies = volumeAllCurrencies
        self.circulatingSupply = circulatingSupply
        self.marketCap = marketCap
    }
}

// MARK: - AverageDailyVolume10Day
public struct AverageDailyVolume10Day {

    public init() {
    }
}

// MARK: - MarketCap
public struct MarketCap {
    public var raw: Int?
    public var fmt: String?
    public var longFmt: String?

    public init(raw: Int?, fmt: String?, longFmt: String?) {
        self.raw = raw
        self.fmt = fmt
        self.longFmt = longFmt
    }
}

// MARK: - PreMarketChange
public struct PreMarketChange {
    public var raw: Double?
    public var fmt: String?

    public init(raw: Double?, fmt: String?) {
        self.raw = raw
        self.fmt = fmt
    }
}
