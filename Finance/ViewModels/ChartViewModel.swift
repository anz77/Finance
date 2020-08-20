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


enum Mode {
    case active
    case passive
    case waiting
    case hidden
    case remove
}

//MARK: - CHARTVIEWMODEL
class ChartViewModel: ChartViewProtocol {
    
//MARK: - VARIABLES
    
    var mode: Mode = .passive {
        didSet {
            switch mode {
            case .active:
                if oldValue == .passive {
                    setSubscriptions()
                    start()
                } else {
                    start()
                }
                //debugPrint("set ACTIVE")
            case .passive:
                if oldValue == .active || oldValue == .hidden || oldValue == .waiting {
                    cancelSubscriptions()
                }
                //debugPrint("set PASSIVE")
            case .waiting:
                if oldValue == .active {
                    stopTimers()
                } else {
                    setSubscriptions()
                }
                //debugPrint("set WAITING")
            case .hidden:
                if oldValue == .active {
                    stopTimers()
                } else if oldValue == .passive {
                    setSubscriptions()
                }
                //debugPrint("set HIDDEN")
            case .remove:
                stopTimers()
                cancelSubscriptions()
                //debugPrint("set REMOVE")
            }
        }
    }
    
    var internetChecker: Bool {
        didSet {
            if internetChecker {
                if mode == .passive || mode == .waiting {
                    mode = .active
                }
            } else {
                if mode == .active {
                    mode = .passive
                }
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
            //debugPrint(fundamental)
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
    init(withSymbol symbol: String?, internetChecker: Bool = true) {
        self.symbol = symbol
        self.internetChecker = internetChecker
        fetchFundamentalFromDisc()
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
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
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
                
            }) { [weak self] historicalChart in
                self?.chart = historicalChart }
    }
    
    func setSubscriptions() {
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
        session?.invalidateAndCancel()
        stopTimers()
        fundamentalSubscription?.cancel()
        historicalChartSubscription?.cancel()
    }

// MARK: - STORING (VANILLA API)
    func storeFundamentalToDisc() {
        guard let url = self.fundamentalStorageURL else {return}
        do {
            try StorageService.storeData(self.fundamental, url: url)
        } catch { }
    }
    
    func storeHistoricalChartToDisc() {
        guard let url = self.historicalChartStorageURL else {return}
        do {
            try StorageService.storeData(self.chart, url: url)
        } catch { }
    }
    
    func fetchFundamentalFromDisc()  {
        guard let url = self.fundamentalStorageURL else {return}
        do {
            try StorageService.readData(from: url, decodableType: Fundamental.self) { fundamental in
                self.fundamental = fundamental
            }
        } catch /*let error*/ {
//            switch error {
//            case let error as StorageError:
//                debugPrint(error.errorDescription!)
//            default:
//                debugPrint(error.localizedDescription)
//            }
        }
    }
    
    func fetchHistoricalChartFromDisc()  {
        guard let url = self.historicalChartStorageURL else {return}
        do {
            try StorageService.readData(from: url, decodableType: HistoricalChart.self) { historicalChart in
                //debugPrint("SUCCESS READING FROM DISC...")
            }
        } catch /*let error*/ {
//            switch error {
//            case let error as StorageError:
//                debugPrint(error.errorDescription!)
//            default:
//                debugPrint(error.localizedDescription)
//            }
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
