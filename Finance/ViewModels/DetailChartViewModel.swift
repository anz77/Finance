//
//  DetailChartViewModel.swift
//  Finance
//
//  Created by Andrii Zuiok on 08.08.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation
import Combine
import UIKit

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
class DetailChartViewModel: ChartViewProtocol {
    
//MARK: - VARIABLES
    
    var internetChecker: Bool {
        didSet {
            if internetChecker {
                setSubscriptions()
                //debugPrint("internet IN")
                start()
            } else {
                //debugPrint("internet OUT")
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
    }
    
    @Published var rss: [RSSItem] = []
    
    @Published var modules: Modules?
    
    var periods = [Period.oneDay, Period.fiveDays, Period.oneMonth, Period.sixMonth, Period.ytd, Period.oneYear, Period.fiveYear, Period.max]
   
    let symbol: String?
    
    var timeInterval: TimeInterval? = .twoMinit
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
    init(withSymbol symbol: String?, internetChecker: Bool = true) {
        self.symbol = symbol
        self.internetChecker = internetChecker
        setSubscriptions()
        if self.internetChecker {
            start()
        } else {
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(sceneWillTDeactivate(notification:)), name: UIScene.willDeactivateNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(sceneDidActivate(notification:)), name: UIScene.didActivateNotification, object: nil)
        
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
        
    @objc func sceneWillTDeactivate(notification: Notification) {
        stopTimers()
    }
    
    @objc func sceneDidActivate(notification: Notification) {
        //debugPrint("sceneDidActivate")
            if self.internetChecker {
                start()
            }
    }
    
//MARK: - FETCHING (COMBINE API METHODS)
    
    func setFundamenatalSubscription() {
        guard let session = self.session else {return}
        fundamentalSubscription =
        fundamentalTimerSubject
        .flatMap { _ in
            WebService.makeNetworkQuery(for: self.fundamentalURL, decodableType: Fundamental.self, session: session).receive(on: DispatchQueue.main)
        }
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure/*(let error)*/:
                //debugPrint(error)
                self.setFundamenatalSubscription()
            case .finished:
                //debugPrint("finished")
                break
            }
        }) { [weak self] fundamental in
            self?.fundamental = fundamental
        }
    }
    
    
    
    
    func setHistoricalChartSubscription() {
        
        guard let session = self.session else {return}
        
        historicalChartSubscription =
        historicalChartTimerSubject
            .flatMap { _ in
                WebService.makeNetworkQuery(for: self.historicalChartURL, decodableType: HistoricalChart.self, session: session).receive(on: DispatchQueue.main)
        }
            .sink(receiveCompletion: {completion in
                switch completion {
                case .failure/*(let error)*/:
                    //debugPrint(error)
                    self.setHistoricalChartSubscription()
                case .finished:
                    //debugPrint("finished")
                    break
                }
            }) { [weak self] historicalChart in self?.chart = historicalChart }
    }
    
    func setRssSubscription() {
        
        guard let session = self.session else {return}
        
        rssSubscription = rssSubject
            .flatMap { _ in
                WebService.makeNetworkQueryForXML(for: self.rssURL, session: session).receive(on: DispatchQueue.main)
        }
            .sink(receiveCompletion: { completion in
            }) { [weak self] rss in self?.rss = rss }
    }
    
    func setModulesSubscription() {
        
        guard let session = self.session else {return}
        
        modulesSubscription =
        modulesSubject
            .flatMap { _ in
                WebService.makeNetworkQuery(for: self.modulesURL, decodableType: Modules.self, session: session).receive(on: DispatchQueue.main)
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
        setAndConfigureSession()
        setFundamenatalSubscription()
        setHistoricalChartSubscription()
        setModulesSubscription()
        setRssSubscription()
    }
    
    func start() {
        fundamentalTimerSubject.send()
        historicalChartTimerSubject.send()
        modulesSubject.send()
        rssSubject.send()
        
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
        session?.invalidateAndCancel()
        stopTimers()
        fundamentalSubscription?.cancel()
        historicalChartSubscription?.cancel()
        rssSubscription?.cancel()
        modulesSubscription?.cancel()
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
        
        for index in Array(0...timeStamp.count - 1) {
            let date = Date(timeIntervalSince1970: Double(timeStamp[index]))
            let period = calendar.dateComponents([timeComponent], from: date).value(for: timeComponent)
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
    
    
}


//    var validPeriods: [Period] {
//        guard let validRanges = viewModel.chart?.chart?.result?.first??.meta?.validRanges else {return self.periods}
//        for period in validRanges {
//            //if period ==
//        }
//        return []
//    }
     
