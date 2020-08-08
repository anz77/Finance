//
//  ListView.swift
//  Finance
//
//  Created by Andrii Zuiok on 04.08.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI

struct ListView: View {
    
    let list: SymbolsList
    
    @ObservedObject var mainViewModel: MainViewModel
    @Binding var detailIsActive: Bool
    @State var isActive: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            
            //Spacer().frame(height: 2)

            HStack {
                Spacer().frame(width: 15)
                
                Button(action: {
                    
                    for index in 0..<self.mainViewModel.symbolsLists.count {
                        if self.mainViewModel.symbolsLists[index].id == self.list.id {
                            
                            withAnimation {
                                self.isActive.toggle()
                                self.mainViewModel.symbolsLists[index].isActive.toggle()
                            }
                            
                           
                        }
                    }
                    
                }) {
                    
                    HStack {
                        Text(list.name)
                            .font(.body)
                            .fontWeight(.heavy)
                            .foregroundColor(Color(.systemGray2))
                            .padding(3)
                        Spacer()
                        Image(systemName: isActive ? "chevron.up": "chevron.down").foregroundColor(Color(.systemGray2))
                        .padding()
                        //Spacer()
                    }
                    
                }
                
            }
            //Spacer().frame(height: 2)

            
            if isActive == true {
                
                Divider()
                
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
        .background(Color(.systemBackground))
        .cornerRadius(5)
        .padding([.leading, .trailing, .bottom], 10)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list: SymbolsList(name: "EQUITY", symbolsArray: ["AAPL"], isActive: true), mainViewModel: MainViewModel(from: "AAPL"), detailIsActive: .constant(true), isActive: true)
    }
}
