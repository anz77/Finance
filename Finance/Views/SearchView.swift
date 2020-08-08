//
//  SearchView.swift
//  Finance
//
//  Created by Andrii Zuiok on 21.03.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

//import SwiftUI
//import Combine
//
//struct SearchView: View {
//
//    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    var mainViewModel: MainViewModel
//
//    @State private var searchText : String = ""
//    @State var searchedResults: [StockAttributes] = []
//
//    @Binding var detailIsActive: Bool
//    @Binding var isSearchMode: Bool
//
//    var body: some View {
//        VStack {
//            Spacer()
//            HStack {
//                SearchBar(placeholder: "Type name (> 2 letters)", text: $searchText, searchResults: $searchedResults)
//                Button(action: {
//                    //self.presentationMode.wrappedValue.dismiss()
//                    self.isSearchMode = false
//
//                }) {
//                    Text("Cancel")
//                }.padding(.trailing)
//            }
//            List(self.searchedResults) { index in
//                Button(action: {
//
//                    let detailModel = ChartViewModel(withSymbol: index.symbol, isDetailViewModel: true, internetChecker: self.mainViewModel.internetChecker)
//                    self.mainViewModel.detailViewModel = detailModel
//                    self.detailIsActive = true
//                    self.isSearchMode = false
//                    //UINavigationBar.setAnimationsEnabled(false)
//
//                }) {
//                    GeometryReader { geometry in
//                        HStack {
//                            Text(index.symbol).fontWeight(.bold)
//                                .frame(width: geometry.size.width * 0.25, alignment: Alignment.leading)
//                            //Spacer()
//                            Text(index.name).font(.subheadline)
//                                .frame(width: geometry.size.width * 0.6, alignment: Alignment.leading)
//                            //Spacer()
//                            Text(index.exch)
//                                .frame(width: geometry.size.width * 0.15, alignment: Alignment.leading)
//                        }
//                    }
//
//                }
//            }.navigationBarTitle(Text("Indexes"))
//        }
//    }
//
//}
//
//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView(mainViewModel: MainViewModel(), detailIsActive: .constant(false), isSearchMode: .constant(true))
//    }
//}
