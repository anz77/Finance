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
    
    
    @ObservedObject var mainViewModel: MainViewModel
    
    @State var isSearchMode: Bool = false
    @State var isEditMode: Bool = false

    @State var rssIsActive: Bool = false
    @State var detailIsActive: Bool = false

    
    var body: some View {
        
        NavigationView {
                        
            ScrollView(.vertical, showsIndicators: true, content: {
                
                if !self.mainViewModel.internetChecker {
                    HStack {
                        Spacer()
                        Text("Internet not available")
                            .font(.headline)
                            .foregroundColor(Color(.systemYellow))
                        Spacer()
                        
                    }
                    .background(Color(.systemRed))
                }
                
                HStack(spacing: 0) {
                    Text("Lists").font(.title).fontWeight(.bold).foregroundColor(Color(.systemGray2))
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
                                print("EditView Appeared")
                        }
                        .onDisappear {
                            print("EditView Disappeared")
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
                                                self.mainViewModel.chartViewModels.forEach{ $0.stopTimers()
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
                    }(), isActive: self.$detailIsActive) // NavigationLink
                        .opacity(0)
                    
                                        
                    VStack(spacing: 10) {
                        
                        ForEach(mainViewModel.symbolsLists, id: \.id) { list in
                            
                            VStack(spacing: 5) {
                                Spacer().frame(height: 10)
                                HStack {
                                    Text(list.name)
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemGray6))
                                        .padding(.horizontal, 5)
                                        .background(Color(.systemGray3))
                                        .cornerRadius(5)
                                        .padding(.horizontal, 5)
                                    Spacer()
                                }
                                
                                Divider().padding(.horizontal)
                                
                                
                                ForEach(list.symbolsArray, id: \.self) { symbol  in
                                    
                                    Button(action: {
                                        self.detailIsActive = true
                                        let detailModel = ChartViewModel(withSymbol: symbol, isDetailViewModel: true, internetChecker: self.mainViewModel.internetChecker)
                                        detailModel.fundamental = self.mainViewModel.modelWithId(symbol).fundamental
                                        self.mainViewModel.detailViewModel = detailModel
                                    }) {
                                        VStack {
                                            ChartView(viewModel: self.mainViewModel.modelWithId(symbol))
                                                .foregroundColor(.primary)
                                                .padding([.leading, .trailing, .bottom], 5)
                                                .frame(height: 65)
                                            Divider()
                                                .padding(.horizontal)
                                        }
                                    } // Button
                                    
                                }
                                .id(UUID())
                            }
                            .background(Color(.systemBackground))
                            .cornerRadius(5)
                            .padding([.leading, .trailing, .bottom], 10)
                            
                        }
                        .id(UUID())
                        
                    }
                    
                } // ZStack (ForEach & NavigationLink)
               
                
                
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
                                            self.mainViewModel.chartViewModels.forEach{ $0.stopTimers()}
                                    }
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
                
                
                .onAppear(perform: {
                    //debugPrint("MainView Appeared")
                })
                .onDisappear(perform: {
                    //debugPrint("MainView Disappeared")
                    self.isSearchMode = false
                })
                .background(Color(UIColor.systemGray5.withAlphaComponent(0.5)))

                
                .sheet(isPresented: $isSearchMode, content: {
                    SearchView(mainViewModel: self.mainViewModel, detailIsActive: self.$detailIsActive,  isSearchMode: self.$isSearchMode)
                }) // sheet
                .onAppear {
                    //debugPrint("Search Aappeared")
                }
                .onDisappear { UINavigationBar.setAnimationsEnabled(true)
                    //debugPrint("Search Disappeared")
                }
                
                .navigationBarTitle("", displayMode: NavigationBarItem.TitleDisplayMode.inline)
                .navigationBarItems(
                    leading: Image(systemName: "person").foregroundColor(Color(.systemGray)),
                    trailing: Button(action: { self.isSearchMode.toggle() }, label: {
                        
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass").foregroundColor(Color(.systemGray))
                                Text("Quote lookup")
                                    .frame(width: 250, height: 30, alignment: .leading)
                                    .foregroundColor(Color(.systemGray))
                            }
                            .background(Color(.systemGray5)).cornerRadius(5)})
                    .onDisappear(perform: {
                        //debugPrint("SEARCH button DISAPPEARED")
                    })
                    

                ) // navigationBarItems
                            
        } // NavigationView
        .onDisappear {
            //debugPrint("MainView Disappeared")
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        //items.remove(atOffsets: offsets)
    }

    private func onMove(source: IndexSet, destination: Int) {
        //items.move(fromOffsets: source, toOffset: destination)
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mainViewModel: MainViewModel(from: "AAPL"))
    }
}
