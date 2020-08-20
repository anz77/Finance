//
//  KeyStatisticsView.swift
//  Finance
//
//  Created by Andrii Zuiok on 12.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI

struct KeyElement {
    let title: String
    let content: String?
}

struct KeyStatisticsRow: View {
    
    var title: String
    var content: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                Spacer()
                Text(content ?? "N/A")
                .fontWeight(.semibold)
            }
            .font(.subheadline)
            .padding([.bottom, .top], 5)
            
            Divider()
        }
    }
}

struct StatisticsView: View {
    var list: [KeyElement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                ForEach(0..<list.count) { index in
                    KeyStatisticsRow(title: self.list[index].title, content: self.list[index].content)
                }
            }
        }
    }
}


struct KeyStatisticsView: View {
    @ObservedObject var viewModel: DetailChartViewModel
    
    //@Binding var keyStatisticsIsVisibe: Bool
    
    var quote: FundamentalQuote? {
         viewModel.fundamental?.optionChain?.result?.first?.quote ?? nil
    }
    
    var modulesResult: ModulesResult? {
        viewModel.modules?.quoteSummary?.result?.first ?? nil
    }
    
    var equityList: [KeyElement] { [
        KeyElement(title: "Open", content: formattedTextForDouble(value: quote?.regularMarketOpen, signed: false)),
        KeyElement(title: "Day's range", content: quote?.regularMarketDayRange),
        KeyElement(title: "52-week range", content: quote?.fiftyTwoWeekRange),
        KeyElement(title: "Market cap", content: self.formattedTextForInt(value: quote?.marketCap)),
        KeyElement(title: "Volume", content: formattedTextForInt(value: quote?.regularMarketVolume)),
        KeyElement(title: "Avg. volume (3m)", content: formattedTextForInt(value: quote?.averageDailyVolume3Month)),
        KeyElement(title: "PE ratio (TTM)", content: formattedTextForDouble(value: quote?.trailingPE, signed: false)),
        KeyElement(title: "EPS (TTM)", content: formattedTextForDouble(value: quote?.epsTrailingTwelveMonths, signed: false)),
        KeyElement(title: "Beta", content: modulesResult?.defaultKeyStatistics?.beta?.fmt),
        KeyElement(title: "Dividend", content: (formattedTextForDouble(value: quote?.trailingAnnualDividendRate, signed: false) ?? "") + (quote?.trailingAnnualDividendYield != nil ? "(" + (formattedTextForDouble(value: ((quote?.trailingAnnualDividendYield ?? 0) * 100), signed: false) ?? "") + "%)" : "N/A")),
        KeyElement(title: "Earnings date", content: stringForDatesRange(start: quote?.earningsTimestampStart, end: quote?.earningsTimestampEnd, dateFormat: "dd.MM")),
        //KeyElement(title: "1Y target est.", content: "N/A"),
        ]}
    
    var indexList: [KeyElement] { [
        KeyElement(title: "Open", content: formattedTextForDouble(value: quote?.regularMarketOpen, signed: false)),
        KeyElement(title: "Day's range", content: quote?.regularMarketDayRange),
        KeyElement(title: "52-week range", content: quote?.fiftyTwoWeekRange),
        ]}
    
    var currencyList: [KeyElement] { [
        KeyElement(title: "Open", content: formattedTextForDouble(value: quote?.regularMarketOpen, signed: false)),
        KeyElement(title: "Day's range", content: quote?.regularMarketDayRange),
        KeyElement(title: "52-week range", content: quote?.fiftyTwoWeekRange),
        KeyElement(title: "Bid", content: formattedTextForDouble(value: quote?.bid, signed: false)),
        KeyElement(title: "Ask", content: formattedTextForDouble(value: quote?.ask, signed: false)),
        ]}
    
    var futureList: [KeyElement] { [
        KeyElement(title: "Open", content: formattedTextForDouble(value: quote?.regularMarketOpen, signed: false)),
        KeyElement(title: "Day's range", content: quote?.regularMarketDayRange),
        KeyElement(title: "52-week range", content: quote?.fiftyTwoWeekRange),
        KeyElement(title: "Bid", content: formattedTextForDouble(value: quote?.bid, signed: false)),
        KeyElement(title: "Ask", content: formattedTextForDouble(value: quote?.ask, signed: false)),
        KeyElement(title: "Market cap", content: self.formattedTextForInt(value: quote?.marketCap)),
        KeyElement(title: "Volume", content: formattedTextForInt(value: quote?.regularMarketVolume)),
        KeyElement(title: "Avg. volume (3m)", content: formattedTextForInt(value: quote?.averageDailyVolume3Month)),
        KeyElement(title: "PE ratio (TTM)", content: formattedTextForDouble(value: quote?.trailingPE, signed: false)),
        KeyElement(title: "Dividend", content: (formattedTextForDouble(value: quote?.trailingAnnualDividendRate, signed: false) ?? "") + (quote?.trailingAnnualDividendYield != nil ? "(" + (formattedTextForDouble(value: ((quote?.trailingAnnualDividendYield ?? 0) * 100), signed: false) ?? "") + "%)" : "N/A")),
        //KeyElement(title: "1Y target est.", content: "N/A"),
        ]}
    
    var etfList: [KeyElement] { [
        KeyElement(title: "Open", content: formattedTextForDouble(value: quote?.regularMarketOpen, signed: false)),
        KeyElement(title: "Day's range", content: quote?.regularMarketDayRange),
        KeyElement(title: "52-week range", content: quote?.fiftyTwoWeekRange),
        KeyElement(title: "Bid", content: formattedTextForDouble(value: quote?.bid, signed: false)),
        KeyElement(title: "Ask", content: formattedTextForDouble(value: quote?.ask, signed: false)),
        KeyElement(title: "Volume", content: formattedTextForInt(value: quote?.regularMarketVolume)),
        KeyElement(title: "Avg. volume (3m)", content: formattedTextForInt(value: quote?.averageDailyVolume3Month)),
        KeyElement(title: "Net assets", content: modulesResult?.defaultKeyStatistics?.totalAssets?.fmt),
        //KeyElement(title: "1Y target est.", content: "N/A"),
        //KeyElement(title: "NAV", content: formattedTextForDouble(value: quote?.trailingThreeMonthNavReturns, signed: false)), // ошибка в NAV
        KeyElement(title: "PE ratio (TTM)", content: formattedTextForDouble(value: quote?.trailingPE, signed: false)),
        KeyElement(title: "Yield", content: modulesResult?.defaultKeyStatistics?.yield?.fmt),
        KeyElement(title: "YTD return", content: modulesResult?.defaultKeyStatistics?.ytdReturn?.fmt),
        KeyElement(title: "Beta", content: modulesResult?.defaultKeyStatistics?.beta?.fmt),
        KeyElement(title: "Expense ratio (net)", content: modulesResult?.defaultKeyStatistics?.annualReportExpenseRatio?.fmt),
        KeyElement(title: "Inception date", content: stringForDate(modulesResult?.defaultKeyStatistics?.fundInceptionDate?.raw, dateFormat: "dd.MM.yyyy")),
        ]}
    
    var fundList: [KeyElement] { [
        KeyElement(title: "YTD return", content: modulesResult?.defaultKeyStatistics?.ytdReturn?.fmt),
        KeyElement(title: "Expense ratio (net)", content: modulesResult?.defaultKeyStatistics?.annualReportExpenseRatio?.fmt),
        KeyElement(title: "Category", content: modulesResult?.defaultKeyStatistics?.category),
        KeyElement(title: "Morningstar rating", content: modulesResult?.defaultKeyStatistics?.morningStarOverallRating?.longFmt),
        KeyElement(title: "Morningstar risk rating", content: modulesResult?.defaultKeyStatistics?.morningStarRiskRating?.longFmt),
        KeyElement(title: "Last cap gain", content: modulesResult?.defaultKeyStatistics?.lastCapGain?.fmt),
        KeyElement(title: "Net assets", content: modulesResult?.defaultKeyStatistics?.totalAssets?.fmt),
        KeyElement(title: "Beta", content: modulesResult?.defaultKeyStatistics?.beta?.fmt),
        KeyElement(title: "Yield", content: modulesResult?.defaultKeyStatistics?.yield?.fmt),
        KeyElement(title: "Holdings turnover", content: modulesResult?.defaultKeyStatistics?.annualHoldingsTurnover?.fmt),
        KeyElement(title: "Last dividend", content: modulesResult?.defaultKeyStatistics?.lastDividendValue?.fmt),
        KeyElement(title: "Inception date", content: stringForDate(modulesResult?.defaultKeyStatistics?.fundInceptionDate?.raw, dateFormat: "dd.MM.yyyy")),
        ]}
    
    var cryptocurrencyList: [KeyElement] { [
        KeyElement(title: "Open", content: formattedTextForDouble(value: quote?.regularMarketOpen, signed: false)),
        KeyElement(title: "Day's range", content: quote?.regularMarketDayRange),
        KeyElement(title: "52-week range", content: quote?.fiftyTwoWeekRange),
        KeyElement(title: "Market cap", content: self.formattedTextForInt(value: quote?.marketCap)),
        KeyElement(title: "Volume", content: formattedTextForInt(value: quote?.regularMarketVolume)),
        KeyElement(title: "Volume (24h)", content: formattedTextForInt(value: quote?.volume24Hr)),
        KeyElement(title: "Volume (24h) all currencies", content: formattedTextForInt(value: quote?.volumeAllCurrencies)),
        KeyElement(title: "Circulating supply", content: formattedTextForInt(value: quote?.circulatingSupply)),
        KeyElement(title: "Max supply", content: formattedTextForInt(value: quote?.maxSupply)),
        KeyElement(title: "Algorithm", content: "N/A"),
        KeyElement(title: "Srart date", content: stringForDate(quote?.startDate, dateFormat: "dd.MM.yyyy")),
        ]}
 
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        KeyStatisticsRow(title: "Previous close", content: formattedTextForDouble(value: quote?.regularMarketPreviousClose, signed: false))
                    }
                    
                    if quote?.quoteType == "INDEX" {
                        StatisticsView(list: indexList)
                    }
                    
                    if quote?.quoteType == "EQUITY" {
                        StatisticsView(list: equityList)
                    }
                    
                    if quote?.quoteType == "CURRENCY" {
                        StatisticsView(list: currencyList)
                    }
                    
                    if quote?.quoteType == "FUTURE" {
                        StatisticsView(list: futureList)
                    }
                    
                    if quote?.quoteType == "ETF" {
                        StatisticsView(list: etfList)
                    }
                    
                    if quote?.quoteType == "FUND" {
                        StatisticsView(list: fundList)
                    }
                    
                    if quote?.quoteType == "CRYPTOCURRENCY" {
                        StatisticsView(list: cryptocurrencyList)
                    }
                }
                .padding(.horizontal)
                
        }
    }
    
    private func formattedTextForDouble(value : Double?, signed: Bool) -> String? {
        guard let value = value else {return nil}
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = .some(" ")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        guard let string = formatter.string(for: value.magnitude) else {return nil}
        
        if signed {
            if value == 0.0 {
                return "0.00"
            } else if value > 0.0 {
                return "+" + string
            } else if value < 0.0 {
                return "-" + string
            }
        }
        return string
    }
    
    private func formattedTextForInt(value : Int?) -> String? {
        guard let value = value else {return nil}
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = .some(" ")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        switch value {
        case 0..<1000000:
            return "\(value)"
        case 1000000..<1000000000:
            let rowValue = Double(value) / 1000000
            guard let string = formatter.string(for: rowValue.magnitude) else {return nil}
            return string + "M"
        case 1000000000..<1000000000000:
            let rowValue = Double(value) / 1000000000
            guard let string = formatter.string(for: rowValue.magnitude) else {return nil}
            return string + "B"
        case 1000000000000..<1000000000000000:
            let rowValue = Double(value) / 1000000000000
            guard let string = formatter.string(for: rowValue.magnitude) else {return nil}
            return string + "T"
        default:
            return ""
        }
    }
    
    func stringForDatesRange(start: Int?, end: Int?, dateFormat: String) -> String? {
        guard let start = start, let end = end else {return nil}
        if let startString = stringForDate(start, dateFormat: dateFormat), let endString = stringForDate(end, dateFormat: dateFormat) {
            return startString + " - " + endString
        } else {
            return nil
        }
        
    }
    
    func stringForDate(_ date: Int?, dateFormat: String) -> String? {
        guard let date = date else {return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let time = Date(timeIntervalSince1970: Double(date))
        return dateFormatter.string(from: time)
    }
    
    func stringForDate(_ date: Double?, dateFormat: String) -> String? {
        guard let date = date else {return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let time = Date(timeIntervalSince1970: date)
        return dateFormatter.string(from: time)
    }

    private func foregroundColor(for value: Double?) -> UIColor {
        return value == nil ? UIColor.clear : (value! == 0.0 ? UIColor.lightGray : (value! > 0.0 ? UIColor.systemGreen : UIColor.systemRed))
    }
    
}

struct KeyStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyStatisticsView(viewModel: DetailChartViewModel(withJSON: "AAPL"))
    }
}
