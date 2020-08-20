//
//  ListView.swift
//  Finance
//
//  Created by Andrii Zuiok on 04.08.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI

struct ListView: View {
    
    var list: SymbolsList
    
    @ObservedObject var mainViewModel: MainViewModel
    @Binding var detailIsActive: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            
            HStack {
                Spacer().frame(width: 15)
                
                Button(action: {
                    
                    if let index = self.mainViewModel.symbolsLists.firstIndex(where: { $0.id == self.list.id}) {
                        
                        withAnimation(.linear(duration: 0.3)) {
                            self.mainViewModel.symbolsLists[index].isActive.toggle()
                            
                            if self.mainViewModel.symbolsLists[index].isActive {
                                for symbol in self.mainViewModel.symbolsLists[index].symbolsArray {
                                    self.mainViewModel.modelWithId(symbol).mode = self.mainViewModel.internetChecker ? .active : .waiting
                                }
                            } else {
                                for symbol in self.mainViewModel.symbolsLists[index].symbolsArray {
                                    self.mainViewModel.modelWithId(symbol).mode = .hidden
                                }
                            }
                        }
                    }
                }) {
                    
                    HStack {
                        Text(list.name)
                            .font(.body)
                            .fontWeight(.heavy)
                            .foregroundColor( self.list.isActive ? Color(.systemGray4) : Color(.systemGray))
                            .padding(3)
                            .lineLimit(1)
                                                
                        Spacer()
                        
                        if !self.list.isActive {
                            Text("\(list.symbolsArray.count) \(list.symbolsArray.count == 1 ? "item" : "items")")
                                .font(.footnote)
                            .foregroundColor(Color(.systemGray))
                                .padding(.trailing, 10)
                        } else {
                            if list.symbolsArray.count == 0 {
                                Text("Empty")
                                    .font(.footnote)
                                .foregroundColor(Color(.systemGray4))
                                    .padding(.trailing, 10)
                            }
                        }
                        
                        
                        
                        Image(systemName: self.list.isActive ? "chevron.up": "chevron.down").foregroundColor(Color(.systemGray2))
                        .padding()
                    }
                    
                }
                
            }
            
            if self.list.isActive == true {
                
                VStack(alignment: .center, spacing: 0) {
                    
                    if list.symbolsArray.count != 0 {
                        Divider()
                    }
                                    
                    ForEach(list.symbolsArray, id: \.self) { symbol  in

                        Button(action: {

                            self.detailIsActive = true
                            let detailModel = DetailChartViewModel(withSymbol: symbol, internetChecker: self.mainViewModel.internetChecker)
                            detailModel.fundamental = self.mainViewModel.modelWithId(symbol).fundamental
                            self.mainViewModel.detailViewModel = detailModel
                        }) {
                            VStack {
                                ChartView(viewModel: self.mainViewModel.modelWithId(symbol))
                                    .foregroundColor(.primary)
                                    .padding([.leading, .trailing], 5)
                                    .frame(height: 70)

                                Divider()
                                    .padding(.horizontal)
                            }

                        } // Button
                    }
                    .id(UUID())
                    
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .padding([.leading, .trailing, .bottom], 10)
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list: SymbolsList(name: "EQUITY", symbolsArray: ["AAPL"], isActive: true), mainViewModel: MainViewModel(from: "AAPL"), detailIsActive: .constant(true))
    }
}
