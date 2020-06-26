//
//  KeyStatisticsView.swift
//  Finance
//
//  Created by Andrii Zuiok on 12.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI

struct KeyStatisticsView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    var quote: FundamentalQuote? {
         viewModel.fundamental?.optionChain?.result?.first?.quote ?? nil
    }
    
    var modulesResult: ModulesResult? {
        viewModel.modules?.quoteSummary?.result?.first ?? nil
    }
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 0) {
            Text("Key statistics")
                .font(.title)
                .fontWeight(.semibold)
                .padding([.bottom])
            
            //Divider()
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack {
                    Text("Previous close")
                    Spacer()
                    Text(formattedTextForDouble(value: quote?.regularMarketPreviousClose, signed: false) ?? "N/A")
                        .fontWeight(.semibold)
                }
                    .padding([.bottom, .top], 5)
                
                Divider()
            }
            
            
            
            if quote?.quoteType == "INDEX" {
                
                VStack(alignment: .leading, spacing: 0) {

                    HStack {
                        Text("Open")
                        Spacer()
                        Text(formattedTextForDouble(value: quote?.regularMarketOpen, signed: false) ?? "N/A")
                        .fontWeight(.semibold)
                    }
                    .padding([.bottom, .top], 5)
                    
                    Divider()
                    
                    HStack {
                        Text("Day's range")
                        Spacer()
                        Text(quote?.regularMarketDayRange ?? "N/A")
                        .fontWeight(.semibold)
                    }
                    .padding([.bottom, .top], 5)
                    
                    Divider()
                    
                    HStack {
                        Text("52-week range")
                        Spacer()
                        Text(quote?.fiftyTwoWeekRange ?? "N/A")
                        .fontWeight(.semibold)
                    }
                    .padding([.bottom, .top], 5)
                    
                    Divider()
                }
            }
            
            
            
            if quote?.quoteType == "EQUITY" {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {

                        HStack {
                            Text("Open")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.regularMarketOpen, signed: false) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Day's range")
                            Spacer()
                            Text(quote?.regularMarketDayRange ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("52-week range")
                            Spacer()
                            Text(quote?.fiftyTwoWeekRange ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Market cap")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.marketCap) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Volume")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.regularMarketVolume) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        /*
                         HStack {
                         Text("1Y target est.")
                         Text(formattedTextForDouble(value: quote?., signed: false))
                         }
                         */
                        
                        HStack {
                            Text("Avg. volume (3m)")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.averageDailyVolume3Month) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("PE ratio (TTM)")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.trailingPE, signed: false) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("EPS (TTM)")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.epsTrailingTwelveMonths, signed: false) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Beta")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.beta?.fmt ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()

                         HStack {
                         Text("Dividend")
                         Spacer()
                            Text(formattedTextForDouble(value: quote?.trailingAnnualDividendRate, signed: false) ?? "")
                            .fontWeight(.semibold)
                            Text(quote?.trailingAnnualDividendYield != nil ? "(" + (formattedTextForDouble(value: ((quote?.trailingAnnualDividendYield ?? 0) * 100), signed: false) ?? "") + "%)" : "N/A")
                            .fontWeight(.semibold)
                         }
                        .padding([.bottom, .top], 5)
                        
                        Divider()

                        HStack {
                            Text("Earnings date")
                            Spacer()
                            Text(stringForDatesRange(start: quote?.earningsTimestampStart, end: quote?.earningsTimestampEnd, dateFormat: "dd.MM") ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()

                    }
                }
            }
            
            if quote?.quoteType == "CURRENCY" {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Open")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.regularMarketOpen, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Day's range")
                            Spacer()
                            Text(quote?.regularMarketDayRange ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("52-week range")
                            Spacer()
                            Text(quote?.fiftyTwoWeekRange ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Bid")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.bid, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Ask")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.ask, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                    }
                }
            }
            
            
            if quote?.quoteType == "FUTURE" {
                VStack(alignment: .leading, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Open")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.regularMarketOpen, signed: false) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Day's range")
                            Spacer()
                            Text(quote?.regularMarketDayRange ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("52-week range")
                            Spacer()
                            Text(quote?.fiftyTwoWeekRange ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Bid")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.bid, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Ask")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.ask, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Market cap")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.marketCap) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Volume")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.regularMarketVolume) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        /*
                         HStack {
                         Text("1Y target est.")
                         Text(formattedTextForDouble(value: quote?., signed: false))
                         }
                         */
                        
                        HStack {
                            Text("Avg. volume (3m)")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.averageDailyVolume3Month) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("PE ratio (TTM)")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.trailingPE, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                         Text("Dividend")
                         Spacer()
                            Text(formattedTextForDouble(value: quote?.trailingAnnualDividendRate, signed: false) ?? "")
                            .fontWeight(.semibold)
                            Text(quote?.trailingAnnualDividendYield != nil ? "(" + (formattedTextForDouble(value: ((quote?.trailingAnnualDividendYield ?? 0) * 100), signed: false) ?? "") + "%)" : "N/A")
                            .fontWeight(.semibold)
                         }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                }
                
            }
            
            if quote?.quoteType == "ETF" {
                VStack(alignment: .leading, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Open")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.regularMarketOpen, signed: false) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Day's range")
                            Spacer()
                            Text(quote?.regularMarketDayRange ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("52-week range")
                            Spacer()
                            Text(quote?.fiftyTwoWeekRange ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Bid")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.bid, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Ask")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.ask, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Volume")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.regularMarketVolume) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        /*
                         HStack {
                         Text("1Y target est.")
                         Text(formattedTextForDouble(value: quote?., signed: false))
                         }
                         */
                        
                        HStack {
                            Text("Avg. volume (3m)")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.averageDailyVolume3Month) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        

                        HStack {
                            Text("Net assets")
                            Spacer()
                            Text( modulesResult?.defaultKeyStatistics?.totalAssets?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        /////////////////////////  ошибка в NAV
                        /*
                        HStack {
                            Text("NAV")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.trailingThreeMonthNavReturns, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        */
                        HStack {
                            Text("PE ratio (TTM)")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.trailingPE, signed: false) ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Yield")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.yield?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("YTD return")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.ytdReturn?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Beta")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.beta?.fmt ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Expense ratio (net)")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.annualReportExpenseRatio?.fmt ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)

                        Divider()

                        HStack {
                            Text("Inception date")
                            Spacer()
                            Text(stringForDate(modulesResult?.defaultKeyStatistics?.fundInceptionDate?.raw, dateFormat: "dd.MM.yyyy"))
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)

                        Divider()
                    }
                }
                
            }
            
            if quote?.quoteType == "FUND" {
                VStack(alignment: .leading, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("YTD return")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.ytdReturn?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Expense ratio (net)")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.annualReportExpenseRatio?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Category")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.category ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Morningstar rating")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.morningStarOverallRating?.longFmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Morningstar risk rating")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.morningStarRiskRating?.longFmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Last cap gain")
                            Spacer()
                            Text( modulesResult?.defaultKeyStatistics?.lastCapGain?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Net assets")
                            Spacer()
                            Text( modulesResult?.defaultKeyStatistics?.totalAssets?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Beta")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.beta?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Yield")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.yield?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Holdings turnover")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.annualHoldingsTurnover?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Last dividend")
                            Spacer()
                            Text(modulesResult?.defaultKeyStatistics?.lastDividendValue?.fmt ?? "N/A")
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Inception date")
                            Spacer()
                            Text(stringForDate(modulesResult?.defaultKeyStatistics?.fundInceptionDate?.raw, dateFormat: "dd.MM.yyyy"))
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                    }
                }
                
            }
            
            
            if quote?.quoteType == "CRYPTOCURRENCY" {
                VStack(alignment: .leading, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Open")
                            Spacer()
                            Text(formattedTextForDouble(value: quote?.regularMarketOpen, signed: false) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Day's range")
                            Spacer()
                            Text(quote?.regularMarketDayRange ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("52-week range")
                            Spacer()
                            Text(quote?.fiftyTwoWeekRange ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Market cap")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.marketCap) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Volume")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.regularMarketVolume) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()

                        HStack {
                            Text("Volume (24h)")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.volume24Hr) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Volume (24h) all currencies")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.volumeAllCurrencies) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("Circulating supply")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.circulatingSupply) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Max supply")
                            Spacer()
                            Text(formattedTextForInt(value: quote?.maxSupply) ?? "N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Algorithm")
                            Spacer()
                            Text("N/A")
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                        
                        HStack {
                            Text("Srart date")
                            Spacer()
                            Text(stringForDate(quote?.startDate, dateFormat: "dd.MM.yyyy"))
                            .fontWeight(.semibold)
                        }
                        .padding([.bottom, .top], 5)
                        
                        Divider()
                    }
                }
                
            }
            
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
        let startString = stringForDate(start, dateFormat: dateFormat)
        let endString = stringForDate(end, dateFormat: dateFormat)
        return startString + " - " + endString
    }
    
    func stringForDate(_ date: Int?, dateFormat: String) -> String {
        guard let date = date else {return "N/A"}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let time = Date(timeIntervalSince1970: Double(date))
        return dateFormatter.string(from: time)
    }
    
    func stringForDate(_ date: Double?, dateFormat: String) -> String {
        guard let date = date else {return "N/A"}
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
        KeyStatisticsView(viewModel: ChartViewModel(withJSON: "SPY"))
    }
}
