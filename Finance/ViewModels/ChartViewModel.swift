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

//MARK: - CHARTVIEWMODEL
class ChartViewModel: ChartViewProtocol {
    
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
    
    @Published var period: Period = Period.oneDay
    
    @Published var chart: HistoricalChart? {
        didSet {
            self.getChartExtremumsFrom(chart)
            self.getTimeMarkerCount(from: chart)
        }
    }
    
    @Published var fundamental: Fundamental?{
        willSet { if let newPrice = newValue?.optionChain?.result?.first?.quote?.regularMarketPrice { regularPriceNewValue = newPrice }}
        didSet {
            
        }
    }
   
    let symbol: String?
    
    var timeInterval: TimeInterval? = .fiveMinit
    var chartExtremums: ChartExtremums?
    var timeMarkerCount: Int?
    var regularPriceNewValue: Double? = 0.0
    var id: String { return symbol ?? "" }
    var fundamentalTimerInterval: Double = 15
    var historicalChartTimerInterval: Double = 60
    
// MARK: - COMBINE API VARIABLES
    var fundamentalTimerSubject = PassthroughSubject<Void, WebServiceError>()
    var historicalChartTimerSubject = PassthroughSubject<Void, WebServiceError>()
   
    var timersSubscriptions: Set<AnyCancellable> = []
    var fundamentalSubscription: AnyCancellable?
    var historicalChartSubscription: AnyCancellable?
    
//MARK: - CONVENIENCE VARIABLES (URL MAKERS)
    private var fundamentalURL: URL { WebService.makeFundamentaltURL(symbol: self.symbol ?? "", date: Int(Date().timeIntervalSince1970)) }
    private var historicalChartURL: URL { WebService.makeHistoricalChartURL(symbol: self.symbol ?? "", period: period, interval: timeInterval) }
    
    private var fundamentalStorageURL: URL? { StorageService.makeDocumentDirectoryURL(forFileNamed: (self.symbol ?? "") + "_FUNDAMENTAL") }
    private var historicalChartStorageURL: URL? { StorageService.makeDocumentDirectoryURL(forFileNamed: (self.symbol ?? "") + "_HISTORICAL") }
    
    var session: URLSession?
    
    
//MARK: - INIT
    init(withSymbol symbol: String?, isDetailViewModel: Bool, internetChecker: Bool = true) {
        
        self.symbol = symbol
        self.internetChecker = internetChecker
        
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
    
    func setSubscriptions() {
        //debugPrint("SET SUBSCRIPTIONS")
        setAndConfigureSession()

        setFundamenatalSubscription()
        setHistoricalChartSubscription()
    }
    
    func start() {
        fundamentalTimerSubject.send()
        historicalChartTimerSubject.send()
        
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
