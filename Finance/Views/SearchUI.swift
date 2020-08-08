//
//  SearchUI.swift
//  Finance
//
//  Created by Andrii Zuiok on 01.07.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit
import SwiftUI
import Combine


class CustomCell: UITableViewCell {
    
    lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        //label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        //label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var exchangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        //label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(symbolLabel)
        NSLayoutConstraint.activate([
            
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            symbolLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            symbolLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        self.contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        self.contentView.addSubview(exchangeLabel)
        NSLayoutConstraint.activate([
            exchangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            exchangeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
            exchangeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class SearchViewController: UIViewController {
   
    @ObservedObject var mainViewModel: MainViewModel
    
    @Binding var detailIsActive: Bool
    @Binding var isSearchMode: Bool
    
    var subscription: AnyCancellable?
    var forSomeReasonSubscription: AnyCancellable?
    var subject = PassthroughSubject<String, WebServiceError>()
    
    var searchedResults: [StockAttributes] = [] {
        didSet {
            UIView.transition(with: self.tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
        }
    }
//        StockAttributes(symbol: "AAPL", name: "Apple", exch: "", type: "", exchDisp: "", typeDisp: ""),
//        StockAttributes(symbol: "GOOG", name: "Alphabet", exch: "", type: "", exchDisp: "", typeDisp: "")
//    ]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 100, right: 0)
        tableView.rowHeight = 40
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        //searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    
    lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.setTitle("Cancel", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancel), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    
    @objc func cancel() {
        mainViewModel.chartViewModels.forEach{ viewModel in
            viewModel.start()
        }
        self.dismiss(animated: true) {}
    }

    init(mainViewModel: ObservedObject<MainViewModel>, detailIsActive: Binding<Bool>, isSearchMode: Binding<Bool>) {
        _mainViewModel = mainViewModel
        _detailIsActive = detailIsActive
        _isSearchMode = isSearchMode

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        setupUI()

            //print(view.window)
            
        
        self.tableView.reloadData()
        tableView.register(CustomCell.self, forCellReuseIdentifier: "SearchCell")
        setSubscription()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //if searchBar.window != nil, !searchBar.isFirstResponder {
            searchBar.becomeFirstResponder()
        //}

    }
    
    
    
    func setupUI() {
        
        self.view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)])
        
        self.view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)])
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)])

    }
    
    func setSubscription() {
        subscription =
            subject
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .flatMap { string -> Publishers.ReceiveOn<AnyPublisher<Search, WebServiceError>, DispatchQueue> in
                    let url = WebService.makeSearchURL(index: string)
                    return WebService.makeNetworkQuery(for: url, decodableType: Search.self).receive(on: DispatchQueue.main)
            }
            .sink(receiveCompletion: {_ in }) { search in
                //debugPrint(search)
                self.searchedResults = search.resultSet.result
        }
        
        forSomeReasonSubscription =
            subject
                .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
                .flatMap { string -> Publishers.ReceiveOn<AnyPublisher<Fundamental, WebServiceError>, DispatchQueue> in
                    let url = WebService.makeFundamentaltURL(symbol: string, date: Int(Date().timeIntervalSince1970))
                    return WebService.makeNetworkQuery(for: url, decodableType: Fundamental.self).receive(on: DispatchQueue.main)
            }
            .sink(receiveCompletion: {_ in }) { fundamental in
                guard let resultQuote = fundamental.optionChain?.result?.first?.quote else {return}
                self.searchedResults.insert(StockAttributes(symbol: resultQuote.symbol ?? "", name: resultQuote.shortName ?? "", exch: resultQuote.exchange ?? "", type: resultQuote.quoteType ?? "", exchDisp: resultQuote.exchange ?? "", typeDisp: resultQuote.quoteType ?? ""), at: 0)
        }
        
    }
    
    
}


// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailModel = ChartViewModel(withSymbol: searchedResults[indexPath.row].symbol, isDetailViewModel: true, internetChecker: self.mainViewModel.internetChecker)
        self.mainViewModel.detailViewModel = detailModel
        self.detailIsActive = true
        self.isSearchMode = false
        
        UINavigationBar.setAnimationsEnabled(false)

        dismiss(animated: true) {
            UINavigationBar.setAnimationsEnabled(true)
        }
        
        
    }
    
}


// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedResults.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! CustomCell
        //let cell = CustomCell()
        
        cell.symbolLabel.text = self.searchedResults[indexPath.row].symbol
        cell.nameLabel.text = self.searchedResults[indexPath.row].name
        cell.exchangeLabel.text = self.searchedResults[indexPath.row].exch
        
        return cell
        
    }
    
}




extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setSubscription()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //text = searchText
        
        if searchText.count > 1 {
            subject.send(searchText)
        } else {
            searchedResults = []
        }
    }
    
    
}


// MARK: - REPRESENTABLE
struct SearchViewUI: UIViewControllerRepresentable {
    
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var mainViewModel: MainViewModel
    @Binding var detailIsActive: Bool
    @Binding var isSearchMode: Bool
    
    func makeUIViewController(context: Context) -> SearchViewController {
        
        return SearchViewController(mainViewModel: _mainViewModel, detailIsActive: _detailIsActive, isSearchMode: _isSearchMode)
    }
    
    func updateUIViewController(_ contentViewController: SearchViewController, context: Context) {
        //print("updateUIViewController")
    }

}

struct SearchViewUI_Previews: PreviewProvider {
    static var previews: some View {
        SearchViewUI(mainViewModel: MainViewModel(from: "AAPL"), detailIsActive: .constant(false), isSearchMode: .constant(true))
    }
}
