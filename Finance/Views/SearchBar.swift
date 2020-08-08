//
//  SearchBar.swift
//  Finance
//
//  Created by Andrii Zuiok on 24.03.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

//import SwiftUI
//import Combine
//
//struct SearchBar: UIViewRepresentable {
//    
//    var placeholder: String
//    
//    @Binding var text: String
//    @Binding var searchResults: [StockAttributes]
//    
//// MARK: Coordinator
//    class Coordinator: NSObject, UISearchBarDelegate {
//        
//        @Binding var text: String
//        @Binding var searchResults: [StockAttributes]
//        
//        var subscription: AnyCancellable?
//        var forSomeReasonSubscription: AnyCancellable?
//        var subject = PassthroughSubject<String, WebServiceError>()
//        
//        init(text: Binding<String>, searchResults: Binding<[StockAttributes]>) {
//            _text = text
//            _searchResults = searchResults
//        }
//        
//        
//        func setSubscription() {
//            subscription =
//                subject
//                    .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
//                    .flatMap { string -> Publishers.ReceiveOn<AnyPublisher<Search, WebServiceError>, DispatchQueue> in
//                        let url = WebService.makeSearchURL(index: string)
//                        return WebService.makeNetworkQuery(for: url, decodableType: Search.self).receive(on: DispatchQueue.main)
//                }
//                .sink(receiveCompletion: {_ in }) { search in
//                    self.searchResults = search.resultSet.result
//            }
//            
//            forSomeReasonSubscription =
//                subject
//                    .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
//                    .flatMap { string -> Publishers.ReceiveOn<AnyPublisher<Fundamental, WebServiceError>, DispatchQueue> in
//                        let url = WebService.makeFundamentaltURL(symbol: string, date: Int(Date().timeIntervalSince1970))
//                        return WebService.makeNetworkQuery(for: url, decodableType: Fundamental.self).receive(on: DispatchQueue.main)
//                }
//                .sink(receiveCompletion: {_ in }) { fundamental in
//                    guard let resultQuote = fundamental.optionChain?.result?.first?.quote else {return}
//                    self.searchResults.insert(StockAttributes(symbol: resultQuote.symbol ?? "", name: resultQuote.shortName ?? "", exch: resultQuote.exchange ?? "", type: resultQuote.quoteType ?? "", exchDisp: resultQuote.exchange ?? "", typeDisp: resultQuote.quoteType ?? ""), at: 0)
//            }
//            
//        }
//        
//        
//// MARK: UISearchBarDelegate
//        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//            setSubscription()
//        }
//        
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            text = searchText
//            
//            if searchText.count > 1 {
//                subject.send(searchText)
//            } else {
//                searchResults = []
//            }
//        }
//        
//        
//    }
//    
//// MARK: UIViewRepresentable
//    func makeCoordinator() -> SearchBar.Coordinator {
//        return Coordinator(text: $text, searchResults: $searchResults)
//    }
//    
//    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
//        let searchBar = UISearchBar(frame: .zero)
//        searchBar.delegate = context.coordinator
//        searchBar.placeholder = placeholder
//        searchBar.searchBarStyle = .minimal
//        searchBar.autocapitalizationType = .none
//        return searchBar
//    }
//    
//    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
//        uiView.text = text
//        if uiView.window != nil, !uiView.isFirstResponder {
//            uiView.becomeFirstResponder()
//        }
//    }
//}
//
//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(placeholder: "", text: .constant(""), searchResults: .constant([StockAttributes(symbol: "", name: "", exch: "", type: "", exchDisp: "", typeDisp: "")]))
//    }
//}
//
