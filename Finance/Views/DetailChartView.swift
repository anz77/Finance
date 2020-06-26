//
//  DetailChartView.swift
//  Finance
//
//  Created by Andrii Zuiok on 10.05.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI
import Combine

struct DetailChartView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject var viewModel: ChartViewModel
    @State var indicatorViewIsVisible: Bool = false
    @State var timeStampIndex: Int?
    @State var rssIsActive: Bool = false
    
    @State var storeSymbol: Bool = false
                    
    var quote: FundamentalQuote? { viewModel.fundamental?.optionChain?.result?.first?.quote ?? nil }
    var chartQuote: HistoricalChartQuote? { viewModel.chart?.chart?.result?.first??.indicators?.quote?.first ?? nil }
    var modulesResult: ModulesResult? { viewModel.modules?.quoteSummary?.result?.first ?? nil }
    var timeStampCount: Int? { viewModel.chart?.chart?.result?.first??.timestamp?.count ?? nil }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            if !self.viewModel.internetChecker {
                HStack {
                    Spacer()
                    Text("Internet not available")
                        .font(.headline)
                        .foregroundColor(Color(.systemYellow))
                    Spacer()
                    
                }
                .background(Color(.systemRed))
            }
            
            
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(viewModel.fundamental?.optionChain?.result?.first?.underlyingSymbol ?? "")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(self.quote?.longName ?? self.quote?.shortName ?? "")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(Color(.systemGray))
                            .padding(.horizontal)
                        Spacer()
                        
                        
                        if !self.symbolsListsContainVewModelSymbol() {
                            Button(action: {
                                self.storeSymbol = true
                            }) {
                                Text("Add to Watchlist")
                                    .padding(.horizontal, 5)
                                    .background(Color(.systemYellow))
                                    .cornerRadius(5)
                            }
                            .sheet(isPresented: $storeSymbol, onDismiss: {
                                debugPrint("Store disappeared")
                            }) {
                                VStack(alignment: .leading, spacing: 50) {
                                    Text("Save item into List:")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemGray))
                                    
                                    ForEach(0..<self.mainViewModel.symbolsLists.count) { index in
                                        Button(action: {
                                            guard let symbol = self.viewModel.symbol else {return}
                                            self.mainViewModel.symbolsLists[index].symbolsArray.append(symbol)
                                            self.mainViewModel.chartViewModels.append(self.viewModel)
                                            self.storeSymbol.toggle()
                                        }) {
                                            Text(self.mainViewModel.symbolsLists[index].name)
                                                .font(.body)
                                                .fontWeight(.bold)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    HStack(alignment: .center, spacing: 0) {
                        if indicatorViewIsVisible == false {
                            Text(formattedTextForDouble(value: self.quote?.regularMarketPrice, signed: false) ?? "N/A")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        } else {
                            if (timeStampIndex ?? 0) < (timeStampCount ?? 0) {
                                Text(formattedTextForDouble(value: priceForIndex(timeStampIndex ?? 0), signed: false) ?? "N/A")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            } else {
                                Text(formattedTextForDouble(value: self.chartQuote?.close?[(timeStampCount ?? 1) - 1], signed: false) ?? "N/A")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        if indicatorViewIsVisible == false {
                            HStack {
                                CustomInformationView(price: nil, priceChange: self.quote?.regularMarketChange, priceChangePercent: self.quote?.regularMarketChangePercent, time: self.quote?.regularMarketTime, timeZone: self.quote?.exchangeTimezoneShortName, marketStateText: viewModel.fundamental?.optionChain?.result?.first?.quote?.marketState == .regular ? "Change since" : "At close:")
                                
                                if self.quote?.preMarketPrice != nil {
                                    CustomInformationView(price: self.quote?.preMarketPrice, priceChange: self.quote?.preMarketChange, priceChangePercent: self.quote?.preMarketChangePercent, time: self.quote?.preMarketTime, timeZone: self.quote?.exchangeTimezoneShortName, marketStateText: "Before hours:")
                                    
                                    
                                } else if self.quote?.postMarketPrice != nil {
                                    CustomInformationView(price: self.quote?.postMarketPrice, priceChange: self.quote?.postMarketChange, priceChangePercent: self.quote?.postMarketChangePercent, time: self.quote?.postMarketTime, timeZone: self.quote?.exchangeTimezoneShortName, marketStateText: "After hours:")
                                } else {
                                    EmptyView()
                                }
                                
                            }
                        } else {
                            HStack {
                                CustomInformationView(price: nil, priceChange: self.currentMarketChange(timeStampIndex: timeStampIndex), priceChangePercent: self.currentMarketChangePercent(timeStampIndex: timeStampIndex), time: self.currentTimeStamp(timeStampIndex: self.timeStampIndex), timeZone: self.quote?.exchangeTimezoneShortName, marketStateText: viewModel.fundamental?.optionChain?.result?.first?.quote?.marketState == .regular ? "Change since" : "At close:")
                            }
                        }
                    }
                }
                .padding()
                
                
                
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 10)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Text((self.quote?.fullExchangeName ?? "") + " - ")
                        Text((self.quote?.quoteSourceName ?? "") + " ")
                        Text("(" + (self.quote?.currency ?? "") + "). ")
                        Text(self.quote?.marketState?.rawValue ?? "")
                    }
                    .font(.footnote)
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 10)
                }
                
                
                
                VStack(alignment: .center, spacing: 0) {
                    ZStack(alignment: .center) {
                        GraphViewUIKit(viewModel: self.viewModel)
                        
                        if indicatorViewIsVisible == false {
                            PriceMarkersView(viewModel: viewModel)
                        }
                        
                        IndicatorView(indicatorViewIsVisible: $indicatorViewIsVisible, timeStampIndex: $timeStampIndex, viewModel: self.viewModel)
                        
                        if indicatorViewIsVisible == false {
                            Text("")
                        }
                    }
                    .frame(height: 120, alignment: .center)
                    .padding([.top, .bottom], 10)
                    
                    TimeMarkersView(viewModel: self.viewModel)
                        .frame(height: 20)
                    ///////////////////////////////////////////////////////
                    Picker(selection: $viewModel.period, label: Text("")) {
                        ForEach(0..<self.viewModel.periods.count) { index in
                            Text(self.viewModel.periods[index].rawValue.uppercased())
                                .tag(self.viewModel.periods[index])
                        }
                        .disabled(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
            }
            .background(Color(.systemBackground))
            
            
            
            
            KeyStatisticsView(viewModel: self.viewModel)
                .padding()
                .background(Color(.systemBackground))
            
            
            
            Spacer()
                .frame(height: 10)
            
            
            
            
            
            ZStack {
                
                NavigationLink("RSS", destination: {
                    VStack{
                        if self.rssIsActive == true {
                            if viewModel.currentRssUrl != nil {
                                WebView(url: viewModel.currentRssUrl!)
                                    .onAppear {}
                                    .onDisappear {
                                        self.rssIsActive = false
                                        self.viewModel.currentRssUrl = nil
                                }
                            } else {
                                EmptyView()
                            }
                        } else {
                            EmptyView()
                        }
                    }
                }(), isActive: self.$rssIsActive) // NavigationLink
                    .opacity(0)
                
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(spacing: 0) {
                        Text("News").font(.title).fontWeight(.bold).foregroundColor(Color(.systemGray2))
                        Spacer()
                    }
                    .padding()
                    
                    ForEach(viewModel.rss, id: \.id) {  item in
                        Button(action: {
                            self.rssIsActive = true
                            self.viewModel.currentRssUrl = URL(string: item.link)
                        }) {
                            VStack {
                                RSSView(item: item)
                                    .padding([.trailing, .leading, .bottom], 5)
                            }
                        } // Button
                    }
                }
                .background(Color(.systemBackground))
            }
            
        }
        .background(Color(UIColor.systemGray5.withAlphaComponent(0.5)))
    
        .navigationBarTitle(Text(verbatim: self.viewModel.fundamental?.optionChain?.result?.first?.underlyingSymbol ?? ""), displayMode: NavigationBarItem.TitleDisplayMode.inline)
    }
    
    
    
    
    private func currentMarketChange(timeStampIndex: Int?) -> Double? {
        guard let timeStampIndex = timeStampIndex else {return nil}
        
        if let chartPreviousClose = self.viewModel.chart?.chart?.result?.first??.meta?.chartPreviousClose {
            if (timeStampIndex ) < (timeStampCount ?? 0) {
                let price = self.priceForIndex(timeStampIndex)
                return price - chartPreviousClose
            } else {
                let price = self.priceForIndex((timeStampCount ?? 1) - 1)
                return price - chartPreviousClose
            }
        }
        return nil
    }
    
    private func currentMarketChangePercent(timeStampIndex: Int?) -> Double? {
        guard let timeStampIndex = timeStampIndex else {return nil}
        
        if let chartPreviousClose = self.viewModel.chart?.chart?.result?.first??.meta?.chartPreviousClose {
            if (timeStampIndex ) < (timeStampCount ?? 0) {
                let price = self.priceForIndex(timeStampIndex)
                return (price - chartPreviousClose) / chartPreviousClose * 100
            } else {
                let price = self.priceForIndex((timeStampCount ?? 1) - 1)
                return (price - chartPreviousClose) / chartPreviousClose * 100
            }
        }
        return nil
    }
    
    private func currentTimeStamp(timeStampIndex: Int?) -> Int? {
        guard let timeStampIndex = timeStampIndex else {return nil}
        
        if let timeStamp = self.viewModel.chart?.chart?.result?.first??.timestamp {
            if (timeStampIndex ) < (timeStampCount ?? 0) {
                return timeStamp[timeStampIndex]
            } else {
                return timeStamp[(timeStampCount ?? 1) - 1]
            }
        }
        return nil
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
        //dateFormatter.timeZone = TimeZone(abbreviation: quote?.exchangeTimezoneShortName ?? "UTC")
        dateFormatter.dateFormat = dateFormat
        let time = Date(timeIntervalSince1970: Double(date))
        return dateFormatter.string(from: time)
    }

    private func foregroundColor(for value: Double?) -> UIColor {
        return value == nil ? UIColor.clear : (value! == 0.0 ? UIColor.lightGray : (value! > 0.0 ? UIColor.systemGreen : UIColor.systemRed))
    }

    
    private func priceForIndex(_ index: Int) -> Double {
        
        guard let quote = viewModel.chart?.chart?.result?.first??.indicators?.quote?.first,
            let meta = viewModel.chart?.chart?.result?.first??.meta else { return 0 }
        
        if let close = quote.close?[index] {
            return close
        } else {
            var nonNullIndex = index
            
            while quote.close?[nonNullIndex] == nil || quote.open?[nonNullIndex] == nil || quote.low?[nonNullIndex] == nil || quote.high?[nonNullIndex] == nil {
                
                nonNullIndex = nonNullIndex - 1
            }
            
            return quote.close?[nonNullIndex] ?? (meta.chartPreviousClose ?? 0)
        }
    }
    
    private func symbolsListsContainVewModelSymbol() -> Bool {
        
        guard let symbol = self.viewModel.symbol else {
            return true
        }
        
        var symbolIsContained = false
        for list in mainViewModel.symbolsLists {
            for containedSymbol in list.symbolsArray {
                if symbol == containedSymbol {
                    symbolIsContained = true
                    break
                }
            }
        }
        
        return symbolIsContained
    }
    
    
    
}

struct DetailChartView_Previews: PreviewProvider {
    static var previews: some View {
        DetailChartView(viewModel: ChartViewModel(withJSON: "AAPL", symbolNotSaved: true)/*, active: .constant(true)*/)//.environment(\.colorScheme, .dark)
    }
}
