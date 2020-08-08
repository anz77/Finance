//
//  SearchBar.swift
//  Finance
//
//  Created by Andrii Zuiok on 19.03.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct MainView: View {
    
    //@Environment(\.sizeCategory) var sizeCategory
    
    @State private var searchText : String = ""
    @State var searchedResults: [StockAttributes] = []
    
    @ObservedObject var mainViewModel: MainViewModel
    
    @State var isSearchMode: Bool = false
    @State var isEditMode: Bool = false
    
    @State var isSettingsMode: Bool = false

    @State var rssIsActive: Bool = false
    @State var detailIsActive: Bool = false
    
    var body: some View {
        
        
        
        NavigationView {
            
            VStack(alignment: .center, spacing: 0) {
                
                // internet checker view
                if !self.mainViewModel.internetChecker {
                    HStack {
                        Spacer()
                        Text("Internet isn't availabled")
                            .font(.headline)
                            .foregroundColor(Color(.systemYellow))
                            
                        
                        Spacer()
                        
                    }
                    .background(Color(.systemRed))
                    .padding([.horizontal], 40)
                    .cornerRadius(5)
                } // internet checker view end
                
                
                
                
                
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    
                    
                    
                    HStack(spacing: 0) {
                        Text("Lists:").font(.title).fontWeight(.bold).foregroundColor(Color(.systemGray2))
                        Spacer()
                        Button(action: {
                            self.isEditMode = true
                        }) {
                            HStack {
                                Spacer().frame(width: 10)
                                Image(systemName: "pencil").foregroundColor(Color(.systemGray))
                                Text("Edit lists")
                                    .frame(width: 70, height: 30, alignment: .leading)
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                        .background(Color(.systemGray5))
                        .cornerRadius(5)
                        .sheet(isPresented: $isEditMode, content: {
                            EditView(mainViewModel: self.mainViewModel)
                                .background(Color(UIColor.systemGray5.withAlphaComponent(0.5)))
                                .onAppear {
                                    self.mainViewModel.chartViewModels.forEach{ $0.stopTimers()}
                                   // debugPrint("EditView Appeared")
                            }
                            .onDisappear {
                                //debugPrint("EditView Disappeared")
                                self.isEditMode = false
                            }
                        }) // sheet
                    }
                    .padding()
                    
                    
                    ZStack {
                        
                        NavigationLink("D E T A I L", destination: {
                            VStack{
                                if self.detailIsActive == true {
                                    if self.mainViewModel.detailViewModel != nil {
                                        DetailChartView(viewModel: self.mainViewModel.detailViewModel ?? ChartViewModel(withSymbol: nil, isDetailViewModel: true, internetChecker: self.mainViewModel.internetChecker))
                                            .onAppear {
                                                if self.mainViewModel.internetChecker {
                                                    self.mainViewModel.chartViewModels.forEach{ //$0.stopTimers()
                                                        $0.cancelSubscriptions()
                                                    }
                                                }
                                        }
                                        .onDisappear {
                                            self.mainViewModel.detailViewModel?.cancelSubscriptions()
                                            self.mainViewModel.detailViewModel = nil
                                            self.detailIsActive = false
                                            
                                            if self.mainViewModel.internetChecker {
                                                self.mainViewModel.chartViewModels.forEach{  viewModel in
                                                    viewModel.setSubscriptions()
                                                    viewModel.start()
                                                }
                                            }
                                        }
                                    } else {
                                        EmptyView()
                                    }
                                } else {
                                    EmptyView()
                                }
                            }
                        //.padding(0)
                        }(), isActive: self.$detailIsActive) // NavigationLink
                            .opacity(0)
                        
                        
                        VStack(spacing: 10) {
                            
                            ForEach(mainViewModel.symbolsLists, id: \.id) { list in
                                ListView(list: list, mainViewModel: self.mainViewModel, detailIsActive: self.$detailIsActive, isActive: list.isActive)
                            }
                            .id(UUID())
                            
                        }
                    
                    } // ZStack (ForEach & NavigationLink)
                        .padding([.top], -20)
                    
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack(spacing: 0) {
                        Text("News").font(.title).fontWeight(.bold).foregroundColor(Color(.systemGray2))
                        Spacer()
                    }
                    .padding()
                    
                    
                    //MARK: - RSS
                    ZStack {
                        
                        NavigationLink("RSS", destination: {
                            VStack{
                                if self.rssIsActive == true {
                                    if mainViewModel.currentRssUrl != nil {
                                        WebView(url: mainViewModel.currentRssUrl!)
                                            .onAppear {
                                                self.mainViewModel.chartViewModels.forEach{ $0.stopTimers()}}
                                            .onDisappear {
                                                self.rssIsActive = false
                                                self.mainViewModel.currentRssUrl = nil
                                                self.mainViewModel.chartViewModels.forEach{ $0.start()}
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
                            ForEach(mainViewModel.rss, id: \.id) {  item in
                                Button(action: {
                                    self.rssIsActive = true
                                    self.mainViewModel.currentRssUrl = URL(string: item.link)
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
                    
                    
                }) // ScrollView
                    
                    .onAppear(perform: { })
                    .onDisappear(perform: {
                        //debugPrint("MainView Disappeared")
                        self.isSearchMode = false
                    })
                    .background(Color(UIColor.systemGray5.withAlphaComponent(0.5)))
                    
                    
                    .navigationBarTitle("", displayMode: NavigationBarItem.TitleDisplayMode.inline)
                    .navigationBarItems(
                        leading: Button(action: { self.isSettingsMode = true }, label: {
                            Image(systemName: "person").foregroundColor(Color(.systemGray))
                        })
                            .sheet(isPresented: self.$isSettingsMode, content: {
                                SettingsView()
                            })
                        ,
                        
                        trailing: Button(action: { self.isSearchMode.toggle() }, label: {
                            
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass").foregroundColor(Color(.systemGray))
                                Text("Quote lookup")
                                    .frame(width: 250, height: 30, alignment: .leading)
                                    .foregroundColor(Color(.systemGray))
                            }
                            .background(Color(.systemGray5)).cornerRadius(5)
                            
                        })
                            .sheet(isPresented: $isSearchMode, content: {
                                //SearchView(mainViewModel: self.mainViewModel, detailIsActive: self.$detailIsActive,  isSearchMode: self.$isSearchMode)
                                SearchViewUI(mainViewModel: self.mainViewModel, detailIsActive: self.$detailIsActive, isSearchMode: self.$isSearchMode)
                                    .onAppear {}
                                    .onDisappear {/*UINavigationBar.setAnimationsEnabled(true)*/}
                            }) // sheet
                ) // navigationBarItems
                
            }
        } // NavigationView
        
        
        
        
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mainViewModel: MainViewModel(from: "AAPL"))
    }
}
