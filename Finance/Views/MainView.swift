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
        
    @State private var searchText : String = ""
    @State var searchedResults: [StockAttributes] = []
    
    @ObservedObject var mainViewModel: MainViewModel
    
    @State var isSearchMode: Bool = false
    @State var isEditMode: Bool = false
    
    @State var isSettingsMode: Bool = false

    @State var rssIsActive: Bool = false
    
    @State var detailIsActive: Bool = false
    
    @State var RSSIsVisible: Bool = false
    
    var body: some View {
                
        NavigationView {
            
            VStack(alignment: .center, spacing: 0) {
                
                // internet checker view
                if !self.mainViewModel.internetChecker {
                    HStack {
                        Spacer()
                        Text("Internet is not available")
                            .font(.headline)
                            .foregroundColor(Color(.systemYellow))
                            
                        Spacer()
                        
                    }
                    .background(Color(.systemRed))
                    .padding([.horizontal], 40)
                    .cornerRadius(10)
                } // internet checker view end
          
                
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    
                    HStack(spacing: 0) {
                        Text("Lists:")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemGray2))
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
                                .onAppear {}
                                .onDisappear { self.isEditMode = false }
                        }) // sheet
                    }
                    .padding()
                    
                    
                    ZStack {
                        
                        NavigationLink("D E T A I L", destination: {
                            VStack{
                                if self.detailIsActive == true {
                                    if self.mainViewModel.detailViewModel != nil {
                                        DetailChartView(viewModel: self.mainViewModel.detailViewModel ?? DetailChartViewModel(withSymbol: nil, internetChecker: self.mainViewModel.internetChecker))
                                            .onAppear {
                                                if self.mainViewModel.internetChecker {
                                                    self.mainViewModel.chartViewModels.forEach{
                                                        if $0.mode != .hidden {
                                                            $0.mode = .waiting
                                                        }
                                                    }
                                                }
                                        }
                                        .onDisappear {
                                            self.mainViewModel.detailViewModel?.cancelSubscriptions()
                                            self.mainViewModel.detailViewModel = nil
                                            self.detailIsActive = false
                                            
                                            //debugPrint("onDisappear")
                                            
                                            if self.mainViewModel.internetChecker {
                                                self.mainViewModel.chartViewModels.forEach{
                                                    if $0.mode != .hidden {
                                                        $0.mode = .active
                                                    }
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
                                ListView(list: list, mainViewModel: self.mainViewModel, detailIsActive: self.$detailIsActive)
                                //.animation(.default)
                            }
                            .id(UUID())
                        }
                    } // ZStack (ForEach & NavigationLink)
                    .padding([.top], -10)
                    
                    
                    Spacer()
                        .frame(height: 30)
                    
                    
//MARK: - RSS button
                    Button(action: {
                        self.mainViewModel.rssSubject.send()
                        withAnimation(.linear(duration: 0.3)) {
                            self.RSSIsVisible.toggle()
                        }
                    }) {
                        HStack(spacing: 0) {

                            Text(self.RSSIsVisible ? "News" : "News list")
                                .font(self.RSSIsVisible ? .title : .body)
                                .fontWeight(.bold)
                                .foregroundColor(self.RSSIsVisible ? Color(.systemGray2) : Color(.systemGray))
                                .animation(.none)
                                .padding(.leading)

                            Text(":")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(self.RSSIsVisible ? Color(.systemGray2) : Color(.clear))
                                .animation(.none)

                            Spacer()

                            Image(systemName: self.RSSIsVisible ? "chevron.up": "chevron.down").foregroundColor(Color(.systemGray2))
                            .padding()
                        }


                    }
                    .background(self.RSSIsVisible ? Color(.clear) : Color(.quaternarySystemFill))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    .animation(.none)

                    
//MARK: - RSS list
                    ZStack {
                        
                        NavigationLink("RSS", destination: {
                            VStack{
                                if self.rssIsActive == true {
                                    if mainViewModel.currentRssUrl != nil {
                                        WebView(url: mainViewModel.currentRssUrl!)
                                            .onAppear {
                                                self.mainViewModel.chartViewModels.forEach{
                                                    if $0.mode != .hidden {
                                                        $0.mode = .waiting
                                                    }
                                                }}
                                            .onDisappear {
                                                self.rssIsActive = false
                                                self.mainViewModel.currentRssUrl = nil
                                                self.mainViewModel.chartViewModels.forEach{
                                                    if $0.mode != .hidden {
                                                        $0.mode = .active
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
                        }(), isActive: self.$rssIsActive) // NavigationLink
                            .opacity(0)
                        
                        
                        if self.RSSIsVisible == true {
                            
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(mainViewModel.rss, id: \.id) {  item in
                                    Button(action: {
                                        self.rssIsActive = true
                                        self.mainViewModel.currentRssUrl = URL(string: item.link)
                                    }) {
                                        VStack {
                                            RSSView(item: item)
                                        }
                                    } // Button
                                   
                                }
                                .background(Color(.systemBackground))
                            .cornerRadius(10)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                            }
                            
                        }
                        
                        
                    }
                    .padding([.top], -20)
                    
                    
                }) // ScrollView
                    
                    .onAppear(perform: { })
                    .onDisappear(perform: {
                        self.isSearchMode = false
                    })
                    .background(Color(UIColor.systemGray5.withAlphaComponent(0.5)))
                    
                    
                    .navigationBarTitle("", displayMode: NavigationBarItem.TitleDisplayMode.inline)
                    .navigationBarItems(
                        leading: Button(action: { self.isSettingsMode = true }, label: {
                            Image(systemName: "person").foregroundColor(Color(.systemGray))
                        })
                        .padding()
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
                                SearchViewUI(mainViewModel: self.mainViewModel, detailIsActive: self.$detailIsActive, isSearchMode: self.$isSearchMode)
                                    .onAppear {}
                                    .onDisappear {}
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
