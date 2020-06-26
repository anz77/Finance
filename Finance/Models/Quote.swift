//
//  Quote.swift
//  Finance
//
//  Created by Andrii Zuiok on 10.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//
/*
import Foundation

// MARK: - Quote
public struct Quote: Codable {
    public var quoteResponse: QuoteResponse?

    enum CodingKeys: String, CodingKey {
        case quoteResponse = "quoteResponse"
    }

    public init(quoteResponse: QuoteResponse?) {
        self.quoteResponse = quoteResponse
    }
}

// MARK: - QuoteResponse
public struct QuoteResponse: Codable {
    public var result: [QuoteResult]?
    public var error: YFError?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }

    public init(result: [QuoteResult]?, error: YFError?) {
        self.result = result
        self.error = error
    }
}

// MARK: - Result
public struct QuoteResult: Codable {
    public var language: String?
    public var region: String?
    public var quoteType: String?
    public var quoteSourceName: String?
    public var triggerable: Bool?
    public var currency: String?
    public var postMarketChangePercent: Double?
    public var postMarketTime: Int?
    public var postMarketPrice: Double?
    public var postMarketChange: Double?
    public var regularMarketChange: Double?
    public var regularMarketChangePercent: Double?
    public var regularMarketTime: Int?
    public var regularMarketPrice: Double?
    public var regularMarketDayHigh: Double?
    public var regularMarketDayRange: String?
    public var regularMarketDayLow: Double?
    public var regularMarketVolume: Int?
    public var regularMarketPreviousClose: Double?
    public var bid: Int?
    public var ask: Int?
    public var bidSize: Int?
    public var askSize: Int?
    public var fullExchangeName: String?
    public var financialCurrency: String?
    public var regularMarketOpen: Double?
    public var averageDailyVolume3Month: Int?
    public var averageDailyVolume10Day: Int?
    public var fiftyTwoWeekLowChange: Double?
    public var fiftyTwoWeekLowChangePercent: Double?
    public var fiftyTwoWeekRange: String?
    public var fiftyTwoWeekHighChange: Double?
    public var fiftyTwoWeekHighChangePercent: Double?
    public var fiftyTwoWeekLow: Double?
    public var fiftyTwoWeekHigh: Double?
    public var dividendDate: Int?
    public var earningsTimestamp: Int?
    public var earningsTimestampStart: Int?
    public var earningsTimestampEnd: Int?
    public var trailingAnnualDividendRate: Double?
    public var trailingPE: Double?
    public var trailingAnnualDividendYield: Double?
    public var epsTrailingTwelveMonths: Double?
    public var epsForward: Double?
    public var sharesOutstanding: Int?
    public var bookValue: Double?
    public var fiftyDayAverage: Double?
    public var fiftyDayAverageChange: Double?
    public var fiftyDayAverageChangePercent: Double?
    public var twoHundredDayAverage: Double?
    public var twoHundredDayAverageChange: Double?
    public var twoHundredDayAverageChangePercent: Double?
    public var marketCap: Int?
    public var forwardPE: Double?
    public var priceToBook: Double?
    public var sourceInterval: Int?
    public var exchangeDataDelayedBy: Int?
    public var tradeable: Bool?
    public var marketState: String?
    public var exchange: String?
    public var shortName: String?
    public var longName: String?
    public var messageBoardID: String?
    public var exchangeTimezoneName: String?
    public var exchangeTimezoneShortName: String?
    public var gmtOffSetMilliseconds: Int?
    public var market: String?
    public var esgPopulated: Bool?
    public var firstTradeDateMilliseconds: Int?
    public var priceHint: Int?
    public var displayName: String?
    public var symbol: String?

    enum CodingKeys: String, CodingKey {
        
        /////// ++++++
        case language = "language"
        case region = "region"
        case quoteType = "quoteType"
        case quoteSourceName = "quoteSourceName"
        case triggerable = "triggerable"
        case currency = "currency"
        /////// ++++++

        
        case regularMarketChange = "regularMarketChange"
        case regularMarketChangePercent = "regularMarketChangePercent"
        case regularMarketTime = "regularMarketTime"
        case regularMarketPrice = "regularMarketPrice"
        case regularMarketDayHigh = "regularMarketDayHigh"
        case regularMarketDayRange = "regularMarketDayRange"
        case regularMarketDayLow = "regularMarketDayLow"
        case regularMarketVolume = "regularMarketVolume"
        case regularMarketPreviousClose = "regularMarketPreviousClose"
        
        case bid = "bid"
        case ask = "ask"
        case bidSize = "bidSize"
        case askSize = "askSize"
        case fullExchangeName = "fullExchangeName"
        case financialCurrency = "financialCurrency"
        case regularMarketOpen = "regularMarketOpen"
        case averageDailyVolume3Month = "averageDailyVolume3Month"
        case averageDailyVolume10Day = "averageDailyVolume10Day"
        
        
        /////// ++++++
        case fiftyTwoWeekLowChange = "fiftyTwoWeekLowChange"
        case fiftyTwoWeekLowChangePercent = "fiftyTwoWeekLowChangePercent"
        case fiftyTwoWeekRange = "fiftyTwoWeekRange"
        case fiftyTwoWeekHighChange = "fiftyTwoWeekHighChange"
        case fiftyTwoWeekHighChangePercent = "fiftyTwoWeekHighChangePercent"
        case fiftyTwoWeekLow = "fiftyTwoWeekLow"
        case fiftyTwoWeekHigh = "fiftyTwoWeekHigh"
        /////// ++++++

        
        case dividendDate = "dividendDate"
        case earningsTimestamp = "earningsTimestamp"
        case earningsTimestampStart = "earningsTimestampStart"
        case earningsTimestampEnd = "earningsTimestampEnd"
        case trailingAnnualDividendRate = "trailingAnnualDividendRate"
        case trailingPE = "trailingPE"
        case trailingAnnualDividendYield = "trailingAnnualDividendYield"
        
        
        case marketState = "marketState"
        case epsTrailingTwelveMonths = "epsTrailingTwelveMonths"
        case epsForward = "epsForward"
        case sharesOutstanding = "sharesOutstanding"
        case bookValue = "bookValue"
        case fiftyDayAverage = "fiftyDayAverage"
        case fiftyDayAverageChange = "fiftyDayAverageChange"
        case fiftyDayAverageChangePercent = "fiftyDayAverageChangePercent"
        case twoHundredDayAverage = "twoHundredDayAverage"
        case twoHundredDayAverageChange = "twoHundredDayAverageChange"
        case twoHundredDayAverageChangePercent = "twoHundredDayAverageChangePercent"
        
        
        
        case marketCap = "marketCap"
        case forwardPE = "forwardPE"
        case priceToBook = "priceToBook"
        case sourceInterval = "sourceInterval"
        case exchangeDataDelayedBy = "exchangeDataDelayedBy"
        case exchangeTimezoneName = "exchangeTimezoneName"
        case exchangeTimezoneShortName = "exchangeTimezoneShortName"
        case gmtOffSetMilliseconds = "gmtOffSetMilliseconds"
        case esgPopulated = "esgPopulated"
        case tradeable = "tradeable"
        case firstTradeDateMilliseconds = "firstTradeDateMilliseconds"
        case priceHint = "priceHint"

        
        case exchange = "exchange"
        case shortName = "shortName"
        case longName = "longName"
        case messageBoardID = "messageBoardId"
        
        case market = "market"
        case displayName = "displayName"
        case symbol = "symbol"
        
        
        
        ///////////
        case postMarketChangePercent = "postMarketChangePercent"
        case postMarketTime = "postMarketTime"
        case postMarketPrice = "postMarketPrice"
        case postMarketChange = "postMarketChange"
        //////////////
    }

    public init(language: String?, region: String?, quoteType: String?, quoteSourceName: String?, triggerable: Bool?, currency: String?, postMarketChangePercent: Double?, postMarketTime: Int?, postMarketPrice: Double?, postMarketChange: Double?, regularMarketChange: Double?, regularMarketChangePercent: Double?, regularMarketTime: Int?, regularMarketPrice: Double?, regularMarketDayHigh: Double?, regularMarketDayRange: String?, regularMarketDayLow: Double?, regularMarketVolume: Int?, regularMarketPreviousClose: Double?, bid: Int?, ask: Int?, bidSize: Int?, askSize: Int?, fullExchangeName: String?, financialCurrency: String?, regularMarketOpen: Double?, averageDailyVolume3Month: Int?, averageDailyVolume10Day: Int?, fiftyTwoWeekLowChange: Double?, fiftyTwoWeekLowChangePercent: Double?, fiftyTwoWeekRange: String?, fiftyTwoWeekHighChange: Double?, fiftyTwoWeekHighChangePercent: Double?, fiftyTwoWeekLow: Double?, fiftyTwoWeekHigh: Double?, dividendDate: Int?, earningsTimestamp: Int?, earningsTimestampStart: Int?, earningsTimestampEnd: Int?, trailingAnnualDividendRate: Double?, trailingPE: Double?, trailingAnnualDividendYield: Double?, epsTrailingTwelveMonths: Double?, epsForward: Double?, sharesOutstanding: Int?, bookValue: Double?, fiftyDayAverage: Double?, fiftyDayAverageChange: Double?, fiftyDayAverageChangePercent: Double?, twoHundredDayAverage: Double?, twoHundredDayAverageChange: Double?, twoHundredDayAverageChangePercent: Double?, marketCap: Int?, forwardPE: Double?, priceToBook: Double?, sourceInterval: Int?, exchangeDataDelayedBy: Int?, tradeable: Bool?, marketState: String?, exchange: String?, shortName: String?, longName: String?, messageBoardID: String?, exchangeTimezoneName: String?, exchangeTimezoneShortName: String?, gmtOffSetMilliseconds: Int?, market: String?, esgPopulated: Bool?, firstTradeDateMilliseconds: Int?, priceHint: Int?, displayName: String?, symbol: String?) {
        self.language = language
        self.region = region
        self.quoteType = quoteType
        self.quoteSourceName = quoteSourceName
        self.triggerable = triggerable
        self.currency = currency
        self.postMarketChangePercent = postMarketChangePercent
        self.postMarketTime = postMarketTime
        self.postMarketPrice = postMarketPrice
        self.postMarketChange = postMarketChange
        self.regularMarketChange = regularMarketChange
        self.regularMarketChangePercent = regularMarketChangePercent
        self.regularMarketTime = regularMarketTime
        self.regularMarketPrice = regularMarketPrice
        self.regularMarketDayHigh = regularMarketDayHigh
        self.regularMarketDayRange = regularMarketDayRange
        self.regularMarketDayLow = regularMarketDayLow
        self.regularMarketVolume = regularMarketVolume
        self.regularMarketPreviousClose = regularMarketPreviousClose
        self.bid = bid
        self.ask = ask
        self.bidSize = bidSize
        self.askSize = askSize
        self.fullExchangeName = fullExchangeName
        self.financialCurrency = financialCurrency
        self.regularMarketOpen = regularMarketOpen
        self.averageDailyVolume3Month = averageDailyVolume3Month
        self.averageDailyVolume10Day = averageDailyVolume10Day
        self.fiftyTwoWeekLowChange = fiftyTwoWeekLowChange
        self.fiftyTwoWeekLowChangePercent = fiftyTwoWeekLowChangePercent
        self.fiftyTwoWeekRange = fiftyTwoWeekRange
        self.fiftyTwoWeekHighChange = fiftyTwoWeekHighChange
        self.fiftyTwoWeekHighChangePercent = fiftyTwoWeekHighChangePercent
        self.fiftyTwoWeekLow = fiftyTwoWeekLow
        self.fiftyTwoWeekHigh = fiftyTwoWeekHigh
        self.dividendDate = dividendDate
        self.earningsTimestamp = earningsTimestamp
        self.earningsTimestampStart = earningsTimestampStart
        self.earningsTimestampEnd = earningsTimestampEnd
        self.trailingAnnualDividendRate = trailingAnnualDividendRate
        self.trailingPE = trailingPE
        self.trailingAnnualDividendYield = trailingAnnualDividendYield
        self.epsTrailingTwelveMonths = epsTrailingTwelveMonths
        self.epsForward = epsForward
        self.sharesOutstanding = sharesOutstanding
        self.bookValue = bookValue
        self.fiftyDayAverage = fiftyDayAverage
        self.fiftyDayAverageChange = fiftyDayAverageChange
        self.fiftyDayAverageChangePercent = fiftyDayAverageChangePercent
        self.twoHundredDayAverage = twoHundredDayAverage
        self.twoHundredDayAverageChange = twoHundredDayAverageChange
        self.twoHundredDayAverageChangePercent = twoHundredDayAverageChangePercent
        self.marketCap = marketCap
        self.forwardPE = forwardPE
        self.priceToBook = priceToBook
        self.sourceInterval = sourceInterval
        self.exchangeDataDelayedBy = exchangeDataDelayedBy
        self.tradeable = tradeable
        self.marketState = marketState
        self.exchange = exchange
        self.shortName = shortName
        self.longName = longName
        self.messageBoardID = messageBoardID
        self.exchangeTimezoneName = exchangeTimezoneName
        self.exchangeTimezoneShortName = exchangeTimezoneShortName
        self.gmtOffSetMilliseconds = gmtOffSetMilliseconds
        self.market = market
        self.esgPopulated = esgPopulated
        self.firstTradeDateMilliseconds = firstTradeDateMilliseconds
        self.priceHint = priceHint
        self.displayName = displayName
        self.symbol = symbol
    }
}
*/
