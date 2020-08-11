//
//  ChartView.swift
//  Finance
//
//  Created by Andrii Zuiok on 25.03.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI
import Combine

struct ChartView: View {
    
    @ObservedObject var viewModel: ChartViewModel
    
    @State var indicatorViewIsVisible: Bool = false
    @State var changedColorForRegularMarketPrice: UIColor = .clear
    
    var quote: FundamentalQuote? {
         viewModel.fundamental?.optionChain?.result?.first?.quote ?? nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                //Spacer()
                HStack(alignment: .center, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        Text(verbatim: self.viewModel.symbol /*self.viewModel.fundamental?.optionChain?.result?.first?.underlyingSymbol*/ ?? "").font(.headline).fontWeight(.bold)
                        //Text(self.quote?.quoteType ?? "").font(.footnote)
                        Spacer()
                        Text(verbatim: self.viewModel.fundamental?.optionChain?.result?.first?.quote?.shortName ?? "").font(.subheadline).fontWeight(.light).foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.leading, 4)
                    .frame(width: geometry.size.width * 0.35, alignment: Alignment(horizontal: .leading, vertical: .center))
                    
                    GraphViewUIKit(viewModel: self.viewModel).frame(width: geometry.size.width * 0.40, alignment: Alignment(horizontal: .center, vertical: .center))
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        //Spacer()
                        Text(self.formattedTextFor(value: self.quote?.regularMarketPrice, signed: false)).font(.headline).fontWeight(.bold)
                            .padding(.init(top: 1, leading: 10, bottom: 1, trailing: 2))
                            .scaledToFill()
                            .layoutPriority(1)
                            .background(Color(self.changedColorForRegularMarketPrice)).cornerRadius(3)
                        
                        Spacer().frame(height: 1)
                        
                        if self.quote?.regularMarketChangePercent != nil {
                            Text(self.formattedTextFor(value: self.quote?.regularMarketChangePercent, signed: true) + "%")
                            .font(.subheadline).fontWeight(.semibold)
                            .foregroundColor(Color(.white))
                            .padding(.init(top: 1, leading: 7, bottom: 1, trailing: 5))
                            .background(Color(self.changedColor(for: self.quote?.regularMarketChangePercent))).cornerRadius(3)
                        }
                        
                        if self.quote?.preMarketChangePercent != nil {
                            HStack(alignment: .center, spacing: 0) {
                                Text("Pre: ").font(.caption)
                                Text(self.formattedTextFor(value: self.quote?.preMarketChangePercent, signed: true) + "%").foregroundColor(Color(self.changedColor(for: self.quote?.preMarketChangePercent))).font(.caption)
                            }
                        } else if self.quote?.postMarketChangePercent != nil{
                            HStack(alignment: .center, spacing: 0) {
                                Text("Post: ").font(.caption)
                                Text(self.formattedTextFor(value: self.quote?.postMarketChangePercent, signed: true) + "%").foregroundColor(Color(self.changedColor(for: self.quote?.postMarketChangePercent))).font(.caption)
                            }
                        } else {
                            Spacer()
                        }
                    }.frame(width: geometry.size.width * 0.25, alignment: Alignment(horizontal: .trailing, vertical: .center))

                }
                
                Spacer()
            }
            
        }.onReceive(self.viewModel.$fundamental, perform: { fundamental in
            if let regularPrice = self.quote?.regularMarketPrice, let regularPriceNewValue = self.viewModel.regularPriceNewValue {
                //debugPrint("         regularPrice = \(regularPrice), regularPriceNewValue = \(regularPriceNewValue)")
                if regularPrice < regularPriceNewValue {
                    self.changedColorForRegularMarketPrice = UIColor.systemGreen.withAlphaComponent(0.4)
                    withAnimation(.easeInOut(duration: 2)) {
                        self.changedColorForRegularMarketPrice = .clear
                    }
                } else if regularPrice > regularPriceNewValue {
                    self.changedColorForRegularMarketPrice = UIColor.systemRed.withAlphaComponent(0.4)
                    withAnimation(.easeInOut(duration: 2)) {
                        self.changedColorForRegularMarketPrice = .clear
                    }
                }
            }
        })
        
    }
    
    func formattedTextFor(value : Double?, signed: Bool) -> String {
        guard let value = value else {return ""}
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = .some(" ")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        guard let string = formatter.string(for: value.magnitude) else {return ""}
        
        if signed {
            if value == 0.0 {
                return "0.00"
            } else if value > 0.0 {
                return "+" + string
            } else if value < 0.0 {
                return "-" + string
            }
        }
        return string
    }
    
    private func changedColor(for value: Double?) -> UIColor {
        value == nil ? UIColor.clear : (value! == 0.0 ? UIColor.lightGray.withAlphaComponent(0.3) : (value! > 0.0 ? UIColor.systemGreen.withAlphaComponent(0.7) : UIColor.systemRed.withAlphaComponent(0.7)))
    }
    
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: ChartViewModel(withJSON: "BTCUSD")).frame(height: 60)//.environment(\.colorScheme, .dark).background(Color.black)
    }
}
