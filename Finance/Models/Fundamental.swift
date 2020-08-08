//
//  FundamentalNew.swift
//  Finance
//
//  Created by Andrii Zuiok on 09.05.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation

// MARK: - Fundamental
public struct Fundamental: Codable {
    public let optionChain: OptionChain?

    enum CodingKeys: String, CodingKey {
        case optionChain = "optionChain"
    }

    public init(optionChain: OptionChain?) {
        self.optionChain = optionChain
    }
}

// MARK: - OptionChain
public struct OptionChain: Codable {
    public let result: [FundamentalResult]?
    public let error: YFError?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }

    public init(result: [FundamentalResult]?, error: YFError?) {
        self.result = result
        self.error = error
    }
}

// MARK: - Result
public struct FundamentalResult: Codable {
    public let underlyingSymbol: String?
    public let expirationDates: [Int]?
    public let strikes: [Double]?
    public let hasMiniOptions: Bool?
    public let quote: FundamentalQuote?
    public let options: [Option]?

    enum CodingKeys: String, CodingKey {
        case underlyingSymbol = "underlyingSymbol"
        case expirationDates = "expirationDates"
        case strikes = "strikes"
        case hasMiniOptions = "hasMiniOptions"
        case quote = "quote"
        case options = "options"
    }

    public init(underlyingSymbol: String?, expirationDates: [Int]?, strikes: [Double]?, hasMiniOptions: Bool?, quote: FundamentalQuote?, options: [Option]?) {
        self.underlyingSymbol = underlyingSymbol
        self.expirationDates = expirationDates
        self.strikes = strikes
        self.hasMiniOptions = hasMiniOptions
        self.quote = quote
        self.options = options
    }
}

// MARK: - Option
public struct Option: Codable {
    public let expirationDate: Int?
    public let hasMiniOptions: Bool?
    public let calls: [Call]?
    public let puts: [Call]?

    enum CodingKeys: String, CodingKey {
        case expirationDate = "expirationDate"
        case hasMiniOptions = "hasMiniOptions"
        case calls = "calls"
        case puts = "puts"
    }

    public init(expirationDate: Int?, hasMiniOptions: Bool?, calls: [Call]?, puts: [Call]?) {
        self.expirationDate = expirationDate
        self.hasMiniOptions = hasMiniOptions
        self.calls = calls
        self.puts = puts
    }
}

// MARK: - Call
public struct Call: Codable {
    public let contractSymbol: String?
    public let strike: Double?
    public let currency: String?
    public let lastPrice: Double?
    public let change: Double?
    public let percentChange: Double?
    public let volume: Int?
    public let openInterest: Int?
    public let bid: Double?
    public let ask: Double?
    public let contractSize: String?
    public let expiration: Int?
    public let lastTradeDate: Int?
    public let impliedVolatility: Double?
    public let inTheMoney: Bool?

    enum CodingKeys: String, CodingKey {
        case contractSymbol = "contractSymbol"
        case strike = "strike"
        case currency = "currency"
        case lastPrice = "lastPrice"
        case change = "change"
        case percentChange = "percentChange"
        case volume = "volume"
        case openInterest = "openInterest"
        case bid = "bid"
        case ask = "ask"
        case contractSize = "contractSize"
        case expiration = "expiration"
        case lastTradeDate = "lastTradeDate"
        case impliedVolatility = "impliedVolatility"
        case inTheMoney = "inTheMoney"
    }

    public init(contractSymbol: String?, strike: Double?, currency: String?, lastPrice: Double?, change: Double?, percentChange: Double?, volume: Int?, openInterest: Int?, bid: Double?, ask: Double?, contractSize: String?, expiration: Int?, lastTradeDate: Int?, impliedVolatility: Double?, inTheMoney: Bool?) {
        self.contractSymbol = contractSymbol
        self.strike = strike
        self.currency = currency
        self.lastPrice = lastPrice
        self.change = change
        self.percentChange = percentChange
        self.volume = volume
        self.openInterest = openInterest
        self.bid = bid
        self.ask = ask
        self.contractSize = contractSize
        self.expiration = expiration
        self.lastTradeDate = lastTradeDate
        self.impliedVolatility = impliedVolatility
        self.inTheMoney = inTheMoney
    }
}

// MARK: - Quote
public struct FundamentalQuote: Codable {
    public let language: String?
    public let region: String?
    public let quoteType: String?
    public let quoteSourceName: String?
    public let triggerable: Bool?
    public let currency: String?
    public let fiftyTwoWeekLowChange: Double?
    public let fiftyTwoWeekLowChangePercent: Double?
    public let fiftyTwoWeekRange: String?
    public let fiftyTwoWeekHighChange: Double?
    public let fiftyTwoWeekHighChangePercent: Double?
    public let fiftyTwoWeekLow: Double?
    public let fiftyTwoWeekHigh: Double?
    public let dividendDate: Int?
    public let earningsTimestamp: Int?
    public let earningsTimestampStart: Int?
    public let earningsTimestampEnd: Int?
    public let trailingAnnualDividendRate: Double?
    public let trailingPE: Double?
    public let trailingAnnualDividendYield: Double?
    public let marketState: MarketState?
    public let epsTrailingTwelveMonths: Double?
    public let epsForward: Double?
    public let sharesOutstanding: Int?
    public let bookValue: Double?
    public let fiftyDayAverage: Double?
    public let fiftyDayAverageChange: Double?
    public let fiftyDayAverageChangePercent: Double?
    public let twoHundredDayAverage: Double?
    public let twoHundredDayAverageChange: Double?
    public let marketCap: Int?
    public let forwardPE: Double?
    public let priceToBook: Double?
    public let sourceInterval: Int?
    public let exchangeDataDelayedBy: Int?
    public let exchangeTimezoneName: String?
    public let exchangeTimezoneShortName: String?
    public let gmtOffSetMilliseconds: Int?
    public let esgPopulated: Bool?
    public let tradeable: Bool?
    public let twoHundredDayAverageChangePercent: Double?
    public let firstTradeDateMilliseconds: Int?
    public let priceHint: Int?
    public let regularMarketChange: Double?
    public let regularMarketChangePercent: Double?
    public let regularMarketTime: Int?
    public let regularMarketPrice: Double?
    public let regularMarketDayHigh: Double?
    public let regularMarketDayRange: String?
    public let regularMarketDayLow: Double?
    public let regularMarketVolume: Int?
    public let regularMarketPreviousClose: Double?
    public let bid: Double?
    public let ask: Double?
    public let bidSize: Int?
    public let askSize: Int?
    public let exchange: String?
    public let market: String?
    public let messageBoardID: String?
    public let fullExchangeName: String?
    public let shortName: String?
    public let longName: String?
    public let financialCurrency: String?
    public let regularMarketOpen: Double?
    public let averageDailyVolume3Month: Int?
    public let averageDailyVolume10Day: Int?
    public let displayName: String?
    public let symbol: String?
    ////////////////
    public let circulatingSupply: Int? // cripto
    public let maxSupply: Int? // cripto

    public let lastMarket: String? // cripto
    public let volume24Hr: Int? // cripto
    public let volumeAllCurrencies: Int? // cripto
    public let fromCurrency: String? // cripto
    public let toCurrency: String? // cripto
    public let startDate: Int? // cripto
    public let coinImageURL: String? // cripto
    ///////////////////
    public let preMarketChange: Double?
    public let preMarketChangePercent: Double?
    public let preMarketTime: Int?
    public let preMarketPrice: Double?
    //////////
    public let postMarketChangePercent: Double?
    public let postMarketTime: Int?
    public let postMarketPrice: Double?
    public let postMarketChange: Double?
    /////////////
    
    public var ytdReturn: Double?  // ETF
    public var trailingThreeMonthReturns: Double? // ETF
    public var trailingThreeMonthNavReturns: Double? // ETF
    

    enum CodingKeys: String, CodingKey {
        /////// ++++++
        case language = "language"
        case region = "region"
        case quoteType = "quoteType"
        case quoteSourceName = "quoteSourceName"
        case triggerable = "triggerable"
        case currency = "currency"
        
        /////++++++++
        case fiftyTwoWeekLowChange = "fiftyTwoWeekLowChange"
        case fiftyTwoWeekLowChangePercent = "fiftyTwoWeekLowChangePercent"
        case fiftyTwoWeekRange = "fiftyTwoWeekRange"
        case fiftyTwoWeekHighChange = "fiftyTwoWeekHighChange"
        case fiftyTwoWeekHighChangePercent = "fiftyTwoWeekHighChangePercent"
        case fiftyTwoWeekLow = "fiftyTwoWeekLow"
        case fiftyTwoWeekHigh = "fiftyTwoWeekHigh"
        ////++++++++++
        
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
        
        
        
        ////////////
        case postMarketChangePercent = "postMarketChangePercent"
        case postMarketTime = "postMarketTime"
        case postMarketPrice = "postMarketPrice"
        case postMarketChange = "postMarketChange"
        ///////////////////
        case preMarketChange = "preMarketChange"
        case preMarketChangePercent = "preMarketChangePercent"
        case preMarketTime = "preMarketTime"
        case preMarketPrice = "preMarketPrice"
        
        ///////////////
        case regularMarketChange = "regularMarketChange"
        case regularMarketChangePercent = "regularMarketChangePercent"
        case regularMarketTime = "regularMarketTime"
        case regularMarketPrice = "regularMarketPrice"
        case regularMarketDayHigh = "regularMarketDayHigh"
        case regularMarketDayRange = "regularMarketDayRange"
        case regularMarketDayLow = "regularMarketDayLow"
        case regularMarketVolume = "regularMarketVolume"
        case regularMarketPreviousClose = "regularMarketPreviousClose"
        
        ////////////////
        case bid = "bid"
        case ask = "ask"
        case bidSize = "bidSize"
        case askSize = "askSize"
        case exchange = "exchange"
        case market = "market"
        case messageBoardID = "messageBoardId"
        case fullExchangeName = "fullExchangeName"
        case shortName = "shortName"
        case longName = "longName"
        case financialCurrency = "financialCurrency"
        case regularMarketOpen = "regularMarketOpen"
        case averageDailyVolume3Month = "averageDailyVolume3Month"
        case averageDailyVolume10Day = "averageDailyVolume10Day"
        case displayName = "displayName"
        case symbol = "symbol"
        
        ///////////////////
        case circulatingSupply = "circulatingSupply" // cripto
        case maxSupply = "maxSupply" // cripto

        case lastMarket = "lastMarket" // cripto
        case volume24Hr = "volume24Hr" // cripto
        case volumeAllCurrencies = "volumeAllCurrencies" // cripto
        case fromCurrency = "fromCurrency" // cripto
        case toCurrency = "toCurrency" // cripto
        case startDate = "startDate" // cripto
        case coinImageURL = "coinImageUrl" // cripto
        
        case ytdReturn = "ytdReturn" // ETF
        case trailingThreeMonthReturns = "trailingThreeMonthReturns" // ETF
        case trailingThreeMonthNavReturns = "trailingThreeMonthNavReturns" // ETF
        
    }

    public init(language: String?, region: String?, quoteType: String?, quoteSourceName: String?, triggerable: Bool?, currency: String?, fiftyTwoWeekLowChange: Double?, fiftyTwoWeekLowChangePercent: Double?, fiftyTwoWeekRange: String?, fiftyTwoWeekHighChange: Double?, fiftyTwoWeekHighChangePercent: Double?, fiftyTwoWeekLow: Double?, fiftyTwoWeekHigh: Double?, dividendDate: Int?, earningsTimestamp: Int?, earningsTimestampStart: Int?, earningsTimestampEnd: Int?, trailingAnnualDividendRate: Double?, trailingPE: Double?, trailingAnnualDividendYield: Double?, marketState: MarketState?, epsTrailingTwelveMonths: Double?, epsForward: Double?, sharesOutstanding: Int?, bookValue: Double?, fiftyDayAverage: Double?, fiftyDayAverageChange: Double?, fiftyDayAverageChangePercent: Double?, twoHundredDayAverage: Double?, twoHundredDayAverageChange: Double?, marketCap: Int?, forwardPE: Double?, priceToBook: Double?, sourceInterval: Int?, exchangeDataDelayedBy: Int?, exchangeTimezoneName: String?, exchangeTimezoneShortName: String?, gmtOffSetMilliseconds: Int?, esgPopulated: Bool?, tradeable: Bool?, twoHundredDayAverageChangePercent: Double?, firstTradeDateMilliseconds: Int?, priceHint: Int?, postMarketChangePercent: Double?, postMarketTime: Int?, postMarketPrice: Double?, postMarketChange: Double?, regularMarketChange: Double?, regularMarketChangePercent: Double?, regularMarketTime: Int?, regularMarketPrice: Double?, regularMarketDayHigh: Double?, regularMarketDayRange: String?, regularMarketDayLow: Double?, regularMarketVolume: Int?, regularMarketPreviousClose: Double?, bid: Double?, ask: Double?, bidSize: Int?, askSize: Int?, exchange: String?, market: String?, messageBoardID: String?, fullExchangeName: String?, shortName: String?, longName: String?, financialCurrency: String?, regularMarketOpen: Double?, averageDailyVolume3Month: Int?, averageDailyVolume10Day: Int?, displayName: String?, symbol: String?, circulatingSupply: Int?, maxSupply: Int?, lastMarket: String?, volume24Hr: Int?, volumeAllCurrencies: Int?, fromCurrency: String?, toCurrency: String?, startDate: Int?, coinImageURL: String?, preMarketChange: Double?, preMarketChangePercent: Double?, preMarketTime: Int?, preMarketPrice: Double?, ytdReturn: Double?, trailingThreeMonthReturns: Double?, trailingThreeMonthNavReturns: Double?) {
        self.language = language
        self.region = region
        self.quoteType = quoteType
        self.quoteSourceName = quoteSourceName
        self.triggerable = triggerable
        self.currency = currency
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
        self.marketState = marketState
        self.epsTrailingTwelveMonths = epsTrailingTwelveMonths
        self.epsForward = epsForward
        self.sharesOutstanding = sharesOutstanding
        self.bookValue = bookValue
        self.fiftyDayAverage = fiftyDayAverage
        self.fiftyDayAverageChange = fiftyDayAverageChange
        self.fiftyDayAverageChangePercent = fiftyDayAverageChangePercent
        self.twoHundredDayAverage = twoHundredDayAverage
        self.twoHundredDayAverageChange = twoHundredDayAverageChange
        self.marketCap = marketCap
        self.forwardPE = forwardPE
        self.priceToBook = priceToBook
        self.sourceInterval = sourceInterval
        self.exchangeDataDelayedBy = exchangeDataDelayedBy
        self.exchangeTimezoneName = exchangeTimezoneName
        self.exchangeTimezoneShortName = exchangeTimezoneShortName
        self.gmtOffSetMilliseconds = gmtOffSetMilliseconds
        self.esgPopulated = esgPopulated
        self.tradeable = tradeable
        self.twoHundredDayAverageChangePercent = twoHundredDayAverageChangePercent
        self.firstTradeDateMilliseconds = firstTradeDateMilliseconds
        self.priceHint = priceHint
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
        self.exchange = exchange
        self.market = market
        self.messageBoardID = messageBoardID
        self.fullExchangeName = fullExchangeName
        self.shortName = shortName
        self.longName = longName
        self.financialCurrency = financialCurrency
        self.regularMarketOpen = regularMarketOpen
        self.averageDailyVolume3Month = averageDailyVolume3Month
        self.averageDailyVolume10Day = averageDailyVolume10Day
        self.displayName = displayName
        self.symbol = symbol
        
        ///////
        self.circulatingSupply = circulatingSupply
        self.maxSupply = maxSupply

        self.lastMarket = lastMarket
        self.volume24Hr = volume24Hr
        self.volumeAllCurrencies = volumeAllCurrencies
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.startDate = startDate
        self.coinImageURL = coinImageURL
        ///////
        self.preMarketChange = preMarketChange
        self.preMarketChangePercent = preMarketChangePercent
        self.preMarketTime = preMarketTime
        self.preMarketPrice = preMarketPrice
        
        
        self.ytdReturn = ytdReturn
        self.trailingThreeMonthReturns = trailingThreeMonthReturns
        self.trailingThreeMonthNavReturns = trailingThreeMonthNavReturns

    }
}

public enum MarketState: String, Codable {
    case regular = "REGULAR"
    case closed = "CLOSED"
    case pre = "PRE"
    case prepre = "PREPRE"
    case post = "POST"
    case undefined
}
