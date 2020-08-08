//
//  DetailChartViewModel.swift
//  Finance
//
//  Created by Andrii Zuiok on 01.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation
import Combine
import UIKit


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

//MARK: - DETAILMODULES
enum DetailModules: String {
    case assetProfile = "assetProfile"
    case incomeStatementHistory = "incomeStatementHistory"
    case incomeStatementHistoryQuarterly = "incomeStatementHistoryQuarterly"
    case balanceSheetHistory = "balanceSheetHistory"
    case balanceSheetHistoryQuarterly = "balanceSheetHistoryQuarterly"
    case cashflowStatementHistory = "cashflowStatementHistory"
    case cashflowStatementHistoryQuarterly = "cashflowStatementHistoryQuarterly"
    case defaultKeyStatistics = "defaultKeyStatistics"
    case financialData = "financialData"
    case calendarEvents = "calendarEvents"
    case secFilings = "secFilings"
    case recommendationTrend = "recommendationTrend"
    case upgradeDowngradeHistory = "upgradeDowngradeHistory"
    case institutionOwnership = "institutionOwnership"
    case fundOwnership = "fundOwnership"
    case majorDirectHolders = "majorDirectHolders"
    case majorHoldersBreakdown = "majorHoldersBreakdown"
    case insiderTransactions = "insiderTransactions"
    case insiderHolders = "insiderHolders"
    case netSharePurchaseActivity = "netSharePurchaseActivity"
    case earnings = "earnings"
    case earningsHistory = "earningsHistory"
    case earningsTrend = "earningsTrend"
    case industryTrend = "industryTrend"
    case indexTrend = "indexTrend"
    case sectorTrend = "sectorTrend"
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

//MARK: - CHARTVIEWMODEL
class ChartViewModel: ObservableObject, Identifiable {
    
//MARK: - VARIABLES
    
    var internetChecker: Bool {
        didSet {
            if internetChecker {
                //setAndConfigureSession()
                setSubscriptions()
                //debugPrint("internet IN")
                start()
            } else {
                //debugPrint("internet OUT")
                //stopTimers()
                cancelSubscriptions()
            }
        }
    }
    
    @Published var period: Period = Period.oneDay {
        didSet { self.historicalChartTimerSubject.send() }
        
        willSet {
            switch newValue {
            case .oneDay:
                self.timeInterval = .twoMinit
            case .fiveDays:
                self.timeInterval = .fiveMinit
            case .oneMonth:
                self.timeInterval = .thirtyMinit
            case .sixMonth:
                self.timeInterval = .oneDay
            case .ytd:
                self.timeInterval = .oneDay
            case .oneYear:
                self.timeInterval = .oneDay
            case .fiveYear:
                self.timeInterval = .oneWeak
            case .max:
                self.timeInterval = .threeMonth
            }
        }
    }
    
    @Published var chart: HistoricalChart? {
        didSet {
            self.getChartExtremumsFrom(chart)
            self.getTimeMarkerCount(from: chart)
            self.getElementsForTimeTicker(from: chart)
        }
    }
    
    @Published var fundamental: Fundamental?{
        willSet { if let newPrice = newValue?.optionChain?.result?.first?.quote?.regularMarketPrice { regularPriceNewValue = newPrice }}
        didSet {
            
        }
    }
    
    @Published var rss: [RSSItem] = []
    
    @Published var modules: Modules?
    
    var periods = [Period.oneDay, Period.fiveDays, Period.oneMonth, Period.sixMonth, Period.ytd, Period.oneYear, Period.fiveYear, Period.max]
   
    let symbol: String?
    
    var isDetailViewModel: Bool = false
    var timeInterval: TimeInterval?
    var chartExtremums: ChartExtremums?
    var timeMarkerCount: Int?
    var elementsForTimeTicker: [Int]?
    var regularPriceNewValue: Double? = 0.0
    var id: String { return symbol ?? "" }
    var fundamentalTimerInterval: Double = 5
    var historicalChartTimerInterval: Double = 60
    var currentRssUrl: URL?
    
// MARK: - COMBINE API VARIABLES
    var fundamentalTimerSubject = PassthroughSubject<Void, WebServiceError>()
    var historicalChartTimerSubject = PassthroughSubject<Void, WebServiceError>()
    var rssSubject = PassthroughSubject<Void, WebServiceError>()
    var modulesSubject = PassthroughSubject<Void, WebServiceError>()
    
    var timersSubscriptions: Set<AnyCancellable> = []
    var fundamentalSubscription: AnyCancellable?
    var historicalChartSubscription: AnyCancellable?
    var rssSubscription: AnyCancellable?
    var modulesSubscription: AnyCancellable?
    
//MARK: - CONVENIENCE VARIABLES (URL MAKERS)
    private var fundamentalURL: URL { WebService.makeFundamentaltURL(symbol: self.symbol ?? "", date: Int(Date().timeIntervalSince1970)) }
    private var historicalChartURL: URL { WebService.makeHistoricalChartURL(symbol: self.symbol ?? "", period: period, interval: timeInterval) }
    private var rssURL: URL { WebService.makeRSSURL(symbol: self.symbol ?? "") }
    private var modulesURL: URL { WebService.makeModulesURL(symbol: self.symbol ?? "", modules: [/*.assetProfile, .balanceSheetHistory, .balanceSheetHistoryQuarterly, .calendarEvents, .cashflowStatementHistory, .cashflowStatementHistoryQuarterly,*/ .defaultKeyStatistics, /*.earnings, .earningsHistory, .earningsTrend, .financialData, .fundOwnership, .incomeStatementHistory, .incomeStatementHistoryQuarterly, .indexTrend, .industryTrend, .insiderHolders, .insiderTransactions, .institutionOwnership, .majorDirectHolders, .majorHoldersBreakdown, .netSharePurchaseActivity, .recommendationTrend, .secFilings, .sectorTrend, .upgradeDowngradeHistory*/]) }
    private var fundamentalStorageURL: URL? { StorageService.makeDocumentDirectoryURL(forFileNamed: (self.symbol ?? "") + "_FUNDAMENTAL") }
    private var historicalChartStorageURL: URL? { StorageService.makeDocumentDirectoryURL(forFileNamed: (self.symbol ?? "") + "_HISTORICAL") }
    
    var session: URLSession?
    
    
//MARK: - INIT
    init(withSymbol symbol: String?, isDetailViewModel: Bool, internetChecker: Bool = true) {
        
        self.symbol = symbol
        self.isDetailViewModel = isDetailViewModel
        self.internetChecker = internetChecker

        if self.isDetailViewModel == true {
            self.timeInterval = .twoMinit
            self.fundamentalTimerInterval = 5.0
        } else {
            self.timeInterval = .fiveMinit
            self.fundamentalTimerInterval = 15.0
        }
        
        //self.setAndConfigureSession()
        setSubscriptions()
        
        if self.internetChecker {
            start()
        } else {
            fetchFundamentalFromDisc()
        }
        
    }
    
    // only for preview
    init(withJSON JSON: String, internetChecker: Bool = true) {
        self.symbol = JSON
        self.internetChecker = internetChecker
        getFundamentalFrom(JSON: JSON)
        getChartFrom(JSON: JSON)
        getRssFrom(XML: JSON)
    }
    
    deinit {
        //debugPrint("               deinit DetailChartViewModel")
    }
    
    func setAndConfigureSession() {
        
        let configuration = URLSessionConfiguration.default
        //configuration.waitsForConnectivity = true
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }
    
    
//MARK: - FETCHING (COMBINE API METHODS)
    
    func setFundamenatalSubscription() {
        
        guard let session = self.session else {return}
        
        fundamentalSubscription =
        fundamentalTimerSubject
        .flatMap { _ in
            
            WebService.makeNetworkQuery(for: self.fundamentalURL, decodableType: Fundamental.self, session: session).receive(on: DispatchQueue.main)
            
            //WebService.makeNetworkQuery(for: self.fundamentalURL, decodableType: Fundamental.self).receive(on: DispatchQueue.main)
            
        }
        .sink(receiveCompletion: { completion in
//            switch completion {
//            case .failure(let error):
//                debugPrint(error)
//            case .finished:
//                debugPrint("finished")
//            }
        }) { [weak self] fundamental in
            //debugPrint((self?.isDetailViewModel ?? false ? "               DetailVM " : "ChartVM ") + "get value")
            self?.fundamental = fundamental
        }
    }
    
    func setHistoricalChartSubscription() {
        
        guard let session = self.session else {return}
        
        historicalChartSubscription =
        historicalChartTimerSubject
            .flatMap { _ in
                
                WebService.makeNetworkQuery(for: self.historicalChartURL, decodableType: HistoricalChart.self, session: session).receive(on: DispatchQueue.main)
                //WebService.makeNetworkQuery(for: self.historicalChartURL, decodableType: HistoricalChart.self).receive(on: DispatchQueue.main)
                
        }
            .sink(receiveCompletion: {completion in
//                switch completion {
//                case .failure(let error):
//                    debugPrint(error)
//                case .finished:
//                    debugPrint("finished")
//                }
            }) { [weak self] historicalChart in self?.chart = historicalChart }
    }
    
    func setRssSubscription() {
        
        //guard let session = self.session else {return}

        
        rssSubscription = rssSubject
            .flatMap { _ in
                
                //WebService.makeNetworkQueryForXML(for: self.rssURL).receive(on: DispatchQueue.main)
                
                WebService.makeNetworkQueryForXML(for: self.rssURL).receive(on: DispatchQueue.main)
                
                
        }
            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    debugPrint(error)
//                case .finished:
//                   debugPrint("finished")
//                }
            }) { [weak self] rss in self?.rss = rss }
    }
    
    func setModulesSubscription() {
        
        guard let session = self.session else {return}
        
        modulesSubscription =
        modulesSubject
            .flatMap { _ in
                
                WebService.makeNetworkQuery(for: self.modulesURL, decodableType: Modules.self, session: session).receive(on: DispatchQueue.main)
                
                //WebService.makeNetworkQuery(for: self.modulesURL, decodableType: Modules.self).receive(on: DispatchQueue.main)
                
        }
            .sink(receiveCompletion: {completion in
//                switch completion {
//                case .failure(let error):
//                    debugPrint(error)
//                case .finished:
//                    debugPrint("finished")
//                }
            }) { [weak self] modules in self?.modules = modules }
    }
    
    
    func setSubscriptions() {
        
        //debugPrint("SET SUBSCRIPTIONS")
        
        setAndConfigureSession()

        setFundamenatalSubscription()
        setHistoricalChartSubscription()
        
        if isDetailViewModel {
            setModulesSubscription()
            setRssSubscription()
        }
        setRssSubscription()

        
    }
    
    func start() {
        fundamentalTimerSubject.send()
        historicalChartTimerSubject.send()
                
        if isDetailViewModel {
            modulesSubject.send()
            rssSubject.send()
        }
                
        Timer.publish(every: fundamentalTimerInterval, tolerance: .none, on: RunLoop.main, in: RunLoop.Mode.common, options: nil)
            .autoconnect()
            .sink(receiveCompletion: { _ in }) { [weak self] _ in self?.fundamentalTimerSubject.send() }
            .store(in: &timersSubscriptions)
        
        Timer.publish(every: historicalChartTimerInterval, tolerance: .none, on: RunLoop.main, in: RunLoop.Mode.common, options: nil)
            .autoconnect()
            .sink(receiveCompletion: { _ in }) { [weak self] _ in self?.historicalChartTimerSubject.send() }
            .store(in: &timersSubscriptions)
    }
    
    func stopTimers() {
        timersSubscriptions.forEach { $0.cancel() }
    }
    
   
    func cancelSubscriptions() {
        //debugPrint("CANCEL SUBSCRIPTIONS")
        
        session?.invalidateAndCancel()
        //session?.finishTasksAndInvalidate()
        stopTimers()
        fundamentalSubscription?.cancel()
        historicalChartSubscription?.cancel()
        
        
        if isDetailViewModel {
            rssSubscription?.cancel()
            modulesSubscription?.cancel()
        }
        
        
    }

// MARK: - STORING (VANILLA API)
    func storeFundamentalToDisc() {
        guard let url = self.fundamentalStorageURL else {return}
        //debugPrint(url)
        do {
            try StorageService.storeData(self.fundamental, url: url)
            
        } catch {
            debugPrint("SOME STORING ERROR OCCURED!")
        }
    }
    
    func storeHistoricalChartToDisc() {
        guard let url = self.historicalChartStorageURL else {return}
        do {
            try StorageService.storeData(self.chart, url: url)
            
        } catch {
            debugPrint("SOME STORING ERROR OCCURED!")
        }
    }
    
    func fetchFundamentalFromDisc()  {
        guard let url = self.fundamentalStorageURL else {return}
        do {
            try StorageService.readData(from: url, decodableType: Fundamental.self) { fundamental in
                //debugPrint("SUCCESS READING FROM DISC...")
                self.fundamental = fundamental
            }
        } catch let error {
            switch error {
            case let error as StorageError:
                debugPrint(error.errorDescription!)
            default:
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func fetchHistoricalChartFromDisc()  {
        guard let url = self.historicalChartStorageURL else {return}
        do {
            try StorageService.readData(from: url, decodableType: HistoricalChart.self) { historicalChart in
                //debugPrint("SUCCESS READING FROM DISC...")
            }
        } catch let error {
            switch error {
            case let error as StorageError:
                debugPrint(error.errorDescription!)
            default:
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    
//MARK: - FETCHING (VANILLA API)
    
    func getChartFrom(JSON: String) {
        self.timeInterval = .oneMinit
        if let url = StorageService.makeBandleURL(forJSONNamed: JSON + "_chart") {
            
            try! StorageService.readData(from: url, decodableType: HistoricalChart.self) { chart in
                self.chart = chart
            }
        }
    }
    
    func getFundamentalFrom(JSON: String) {
        self.timeInterval = .oneMinit
        if let url = StorageService.makeBandleURL(forJSONNamed: JSON + "_fundamental") {
            
            try! StorageService.readData(from: url, decodableType: Fundamental.self) { chart in
                self.fundamental = chart
            }
        }
    }
   
    func getRssFrom(XML: String) {
        if let url = StorageService.makeBandleURL(forXMLNamed: XML) {
            StorageService.readXML(url: url) { rss in
                self.rss = rss
            }
        }
    }
    
    func getRss(for XML: String) {
        StorageService.makeStoreQuery(XML: XML) { data in
            let parser = XmlRssParser()
            let rssItems = parser.parsedItemsFromData(data)
            self.rss = rssItems
        }
    }
    
//MARK: - PRIVATE METHODS
    private func getElementsForTimeTicker(from historicalChart: HistoricalChart?) {
        switch self.period {
        case .oneDay:
            self.elementsForTimeTicker = compressedArrayFor(timeComponent: Calendar.Component.hour)
        case .fiveDays:
            self.elementsForTimeTicker = compressedArrayFor(timeComponent: Calendar.Component.day)
        case .oneMonth:
            self.elementsForTimeTicker = compressedArrayFor(timeComponent: Calendar.Component.day)
        case .sixMonth:
            self.elementsForTimeTicker = compressedArrayFor(timeComponent: Calendar.Component.month)
        case .ytd:
            self.elementsForTimeTicker = compressedArrayFor(timeComponent: Calendar.Component.month)
        case .oneYear:
            self.elementsForTimeTicker = compressedArrayFor(timeComponent: Calendar.Component.month)
        case .fiveYear:
            self.elementsForTimeTicker = compressedArrayFor(timeComponent: Calendar.Component.year)
        case .max:
            self.elementsForTimeTicker = compressedArrayFor(timeComponent: Calendar.Component.year)
        }
    }
    
    private func compressedArrayFor(timeComponent: Calendar.Component) -> [Int] {
        guard let timeStamp = self.chart?.chart?.result?.first??.timestamp, let timeZone = self.chart?.chart?.result?.first??.meta?.timezone else {return []}
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: timeZone) ?? TimeZone(abbreviation: "UTC")!
        
        var rowArray = [Int]()
        let currentMinIndex = 0
        rowArray.append(currentMinIndex)
        let currentDate = Date(timeIntervalSince1970: Double(timeStamp[currentMinIndex]))
        var currentPeriod = calendar.dateComponents([timeComponent], from: currentDate).value(for: timeComponent)
        //debugPrint("currentMinIndex = \(String(describing: currentMinIndex))")
        
        for index in Array(0...timeStamp.count - 1) {
            let date = Date(timeIntervalSince1970: Double(timeStamp[index]))
            let period = calendar.dateComponents([timeComponent], from: date).value(for: timeComponent)
            //debugPrint("month = \(month!), currentMonth = \(currentMonth!)")
            if period != currentPeriod {
                rowArray.append(index)
                currentPeriod = period
            }
        }
        
        switch self.period {
        case .oneDay, .oneYear:
            rowArray = Array(rowArray.dropFirst())
        case .oneMonth:
            rowArray = Array(rowArray.filter { index in
                    let date = Date(timeIntervalSince1970: Double(timeStamp[index]))
                    let dateComponentsWeekday = calendar.dateComponents([.weekday], from: date).weekday
                    return dateComponentsWeekday == 5 })
        case .max:
            rowArray = Array(rowArray.filter { index in
                    let date = Date(timeIntervalSince1970: Double(timeStamp[index]))
                    let dateComponentsYear = calendar.dateComponents([.year], from: date).year
                    return (dateComponentsYear! % 5) == 0
            }.dropLast())
        default: break
        }
        
        if rowArray.count > 6 {
            var newArray: [Int] = []
            for i in 0..<rowArray.count {
                if i % 2 != 0 {
                    newArray.append(rowArray[i])
                }
            }
            rowArray = newArray
        }
        return rowArray
    }
    
    func getChartExtremumsFrom(_ historicalChart: HistoricalChart?) {
        if let quote = historicalChart?.chart?.result?.first??.indicators?.quote?.first {
             
            if let lowMin = quote.low?.compactMap({$0}).min(), let lowMax = quote.low?.compactMap({$0}).max(), let highMin = quote.high?.compactMap({$0}).min(), let highMax = quote.high?.compactMap({$0}).max(), let openMin = quote.open?.compactMap({$0}).min(), let openMax = quote.open?.compactMap({$0}).max(), let closeMin = quote.close?.compactMap({$0}).min(), let closeMax = quote.close?.compactMap({$0}).max() {
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
                let dayTimeMarkerCount = ((tp??.end ?? 0) - (tp??.start ?? 0)) / dataGranularity ///////////////////////////////// РАЗОБРАТЬСЯ
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
        
        if let close = quote.close?[index] {
            return close
        } else {
            var nonNullIndex = index
            while quote.close?[nonNullIndex] == nil || quote.open?[nonNullIndex] == nil || quote.low?[nonNullIndex] == nil || quote.high?[nonNullIndex] == nil {
                nonNullIndex = nonNullIndex - 1
            }
            return quote.close?[nonNullIndex] ?? chartPreviousClose
        }
    }
    
}


//    var validPeriods: [Period] {
//        guard let validRanges = viewModel.chart?.chart?.result?.first??.meta?.validRanges else {return self.periods}
//        for period in validRanges {
//            //if period ==
//        }
//        return []
//    }
     
/*
func fundamentalSubscriptionFunc() {
    fundamentalTimerSubject
        .flatMap { _ in
            API.WebService.fetch(for: self.fundamentaltURL, decodableType: Fundamental.self)
    }
    .sink(receiveCompletion: { (completion) in
        print(completion)
    }) { (value) in
        self.fundamental = value
    }
.store(in: &subscriptions)
}
*/
