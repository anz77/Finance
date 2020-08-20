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
    @ObservedObject var viewModel: DetailChartViewModel
    @State var indicatorViewIsVisible: Bool = false
    @State var timeStampIndex: Int?
    @State var rssIsActive: Bool = false
    
    @State private var shouldAnimate = false
    
    @State var storeSymbolToListMode: Bool = false
    
                    
    var quote: FundamentalQuote? { viewModel.fundamental?.optionChain?.result?.first?.quote ?? nil }
    var chartQuote: HistoricalChartQuote? { viewModel.chart?.chart?.result?.first??.indicators?.quote?.first ?? nil }
    var chartMeta: Meta? { viewModel.chart?.chart?.result?.first??.meta ?? nil }
    var modulesResult: ModulesResult? { viewModel.modules?.quoteSummary?.result?.first ?? nil }
    var timeStampCount: Int? { viewModel.chart?.chart?.result?.first??.timestamp?.count ?? nil }
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
//MARK: - internet checker view
            if !self.viewModel.internetChecker {
                HStack {
                    Spacer()
                    Text("Internet is not available")
                        .font(.headline)
                        .foregroundColor(Color(.systemYellow))
                    
                    Spacer()
                    
                }
                .background(Color(.systemRed))
                .padding([.horizontal], 40)
            } // internet checker view end
            

//MARK: - symbol
            if viewModel.fundamental != nil {
                
                ScrollView(.vertical, showsIndicators: true) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text(viewModel.fundamental?.optionChain?.result?.first?.underlyingSymbol ?? "")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                Text(self.quote?.longName ?? self.quote?.shortName ?? "")
                                    .font(.callout)
                                    //.fontWeight(.medium)
                                    .lineLimit(2)
                                    .foregroundColor(Color(.systemGray))
                                    .padding(.leading)
                                
                                Spacer()
                                
//MARK: - Add symbol to symbols lists BUTTON
                                if !self.symbolsListsContainVewModelSymbol() {
                                    Button(action: {
                                        self.storeSymbolToListMode = true
                                    }) {
                                        Text("Add to List")
                                            .font(.callout)
                                            .foregroundColor(Color(.tertiarySystemBackground))
                                            .padding(.horizontal, 5)
                                            .background(Color(UIColor.systemBlue))
                                            .cornerRadius(5)
                                        
                                    }
                                    .sheet(isPresented: $storeSymbolToListMode, onDismiss: {}) {
                                        SaveItemView(viewModel: self.viewModel, storeSymbolToListMode: self.$storeSymbolToListMode).environmentObject(self.mainViewModel)
                                    }
                                } //Add symbol to symbols lists BUTTON scope end
                                
                                
                            }
                            .frame(height: 45)
                            .padding([.bottom], 5)
                            
                            
                            //MARK: - quoteType
                            HStack(alignment: .top, spacing: 0) {
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(alignment: .center, spacing: 0) {
                                        Text(quote?.quoteType ?? "")
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .foregroundColor(Color(.systemGray))
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 0) {
                                    HStack(alignment: .center, spacing: 0) {
                                        Text("Exchange:")
                                            .foregroundColor(Color(.systemGray))
                                            .padding(.trailing)
                                        
                                        Text(self.quote?.fullExchangeName ?? self.quote?.exchange ?? "")
                                            .fontWeight(.bold)
                                        
                                    }.lineLimit(1)
                                    
                                    /*
                                     HStack(alignment: .center, spacing: 0) {
                                     Text(self.quote?.quoteSourceName ?? "")
                                     }
                                     */
                                }
                                .font(.caption)
                            }
                            
                            
                            //MARK: - custom infoermation view
                            
                            VStack(alignment: .center, spacing: 0) {
                                
                                if indicatorViewIsVisible == false {
                                    VStack {
                                        CustomInformationView(price: self.quote?.regularMarketPrice, priceChange: self.quote?.regularMarketChange, priceChangePercent: self.quote?.regularMarketChangePercent, time: self.quote?.regularMarketTime, timeZone: self.quote?.exchangeTimezoneShortName, marketStateText: "", subMarketStateText: "",bigPrice: true)
                                        Spacer().frame(height: 10)
                                        Divider()
                                        
                                        if self.quote?.preMarketPrice != nil {
                                            CustomInformationView(price: self.quote?.preMarketPrice, priceChange: self.quote?.preMarketChange, priceChangePercent: self.quote?.preMarketChangePercent, time: self.quote?.preMarketTime, timeZone: self.quote?.exchangeTimezoneShortName, marketStateText: "Market CLOSED", subMarketStateText: "PRE-MARKET", bigPrice: false)
                                            
                                        } else if self.quote?.postMarketPrice != nil {
                                            CustomInformationView(price: self.quote?.postMarketPrice, priceChange: self.quote?.postMarketChange, priceChangePercent: self.quote?.postMarketChangePercent, time: self.quote?.postMarketTime, timeZone: self.quote?.exchangeTimezoneShortName, marketStateText: "Market CLOSED", subMarketStateText: "POST-MARKET", bigPrice: false)
                                        } else {
                                            CustomInformationView(price: nil, priceChange: nil, priceChangePercent: nil, time: nil, timeZone: nil, marketStateText: self.quote?.marketState == "REGULAR" ? "Market OPENED" : "Market CLOSED", subMarketStateText: self.quote?.marketState == "REGULAR" ? "REGULAR" : "", bigPrice: false)
                                        }
                                    }
                                } else {
                                    VStack {
                                        CustomInformationView(price: ((timeStampIndex ?? 0) < (timeStampCount ?? 0)) ? priceForIndex(timeStampIndex ?? 0) : /*self.chartQuote?.close?[(timeStampCount ?? 1) - 1]*/ 0, priceChange: self.currentMarketChange(timeStampIndex: timeStampIndex), priceChangePercent: self.currentMarketChangePercent(timeStampIndex: timeStampIndex), time: self.currentTimeStamp(timeStampIndex: self.timeStampIndex), timeZone: self.quote?.exchangeTimezoneShortName, marketStateText: "", subMarketStateText: "", bigPrice: true)
                                        
                                        Spacer().frame(height: 10)
                                        
                                        Divider()
                                        
                                        CustomInformationView(price: nil, priceChange: nil, priceChangePercent: nil, time: nil, timeZone: nil, marketStateText: "CURRENT PRICE", subMarketStateText: "", bigPrice: false)
                                    }
                                }
                            }
                            
                            Spacer().frame(height: 10)
                            Divider()
                            
                        }
                        .padding()
                        
                    }
                        .background(Color(.systemBackground))
                        
//MARK: - quote, marketState, currency
                        /*
                        VStack(spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                Text("Currency: ")
                                .foregroundColor(Color(.systemGray))

                                Text(self.quote?.currency ?? "")
                                    .padding(.horizontal, 5)
                            }
                            .font(.footnote)
                            .padding(.horizontal)
                        }
                        */

                    
//MARK: - GraphViewUIKit, IndicatorView,
                    
                    VStack(alignment: .center, spacing: 0) {
                        
                        ZStack(alignment: .center) {
                            
                            if chartQuote != nil {
                                
                                if chartQuote?.close != nil {
                                    GraphViewUIKit(viewModel: self.viewModel)
                                    
                                    if indicatorViewIsVisible == false {
                                        PriceMarkersView(viewModel: viewModel)
                                    }
                                    
                                    IndicatorView(indicatorViewIsVisible: $indicatorViewIsVisible, timeStampIndex: $timeStampIndex, viewModel: self.viewModel)
                                    
                                    if self.viewModel.period.rawValue != self.chartMeta?.range {
                                        
                                        ActivityIndicator(shouldAnimate: .constant(true))
                                        
                                    }
                                } else {
                                    Text("Chart is not available")
                                }
                                
                            } else {
                                ActivityIndicator(shouldAnimate: .constant(true))
                            }
                            
                        }
                        .frame(height: 180, alignment: .center)
                        .padding(10)
                        .onReceive(viewModel.$chart) { chart in
                            withAnimation(.linear) {
                                
                            }
                        }
                        
//MARK: - TimeMarkersView
                        TimeMarkersView(viewModel: self.viewModel)
                            .frame(height: 20)
                            .padding([.leading, .trailing], 10)
                        
//MARK: - Picker
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
                    .background(Color(.systemBackground))
                    
//MARK: - KeyStatisticsView
                    KeyStatisticsView(viewModel: self.viewModel)
                        .background(Color(.systemBackground))
                    
                    Spacer()
                        .frame(height: 10)
                    
//MARK: -  RSS
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
                    
                    Spacer()
                    
                }
                .background(Color(UIColor.systemGray5.withAlphaComponent(0.5)))
                .navigationBarTitle(Text(verbatim: self.viewModel.fundamental?.optionChain?.result?.first?.underlyingSymbol ?? ""), displayMode: NavigationBarItem.TitleDisplayMode.inline)
            }
            
        }
        
        
    }
    
    
    //for IndicatorView
    private func currentMarketChange(timeStampIndex: Int?) -> Double? {
        guard let timeStampIndex = timeStampIndex else {return nil}
        
        if let chartPreviousClose = self.chartMeta?.chartPreviousClose {
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
    
    //for IndicatorView
    private func currentMarketChangePercent(timeStampIndex: Int?) -> Double? {
        guard let timeStampIndex = timeStampIndex else {return nil}
        
        if let chartPreviousClose = self.chartMeta?.chartPreviousClose {
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


    private func foregroundColor(for value: Double?) -> UIColor {
        return value == nil ? UIColor.clear : (value! == 0.0 ? UIColor.lightGray : (value! > 0.0 ? UIColor.systemGreen : UIColor.systemRed))
    }

////////////////////////
    private func priceForIndex(_ index: Int) -> Double {
        
        guard let quote = self.chartQuote,
            let meta = self.chartMeta else { return 0 }
        
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
        guard let symbol = self.viewModel.symbol else { return true }
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
        DetailChartView(viewModel: DetailChartViewModel(withJSON: "AAPL")/*, active: .constant(true)*/).environmentObject(MainViewModel(from: "AAPL"))
        //.environment(\.colorScheme, .dark)
    }
}
