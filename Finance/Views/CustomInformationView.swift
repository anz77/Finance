//
//  CustomInformationView.swift
//  Finance
//
//  Created by Andrii Zuiok on 21.05.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI

struct CustomInformationView: View {
    
    var price: Double?
    var priceChange: Double?
    var priceChangePercent: Double?
    var time: Int?
    var timeZone: String?
    var marketStateText: String?
    var subMarketStateText: String?
    
    let bigPrice: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Text(marketStateText ?? "")
                    .lineLimit(1)
                
                Spacer()
                
                Text(subMarketStateText ?? "")
                    .fontWeight(.bold)
                    .foregroundColor(Color(.systemGray2))
                .lineLimit(1)
                
                
            }
            
            HStack(alignment: .center, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        
                        if price != nil {
                            Text(formattedTextFor(value: price, signed: false))
                            .font(bigPrice ? .largeTitle : .body)
                            .fontWeight(.heavy)
                            .lineLimit(1)
                            .layoutPriority(1)
                        } else {
                            Text("EMPTY")
                                .foregroundColor(Color(.clear))
                            .font(bigPrice ? .largeTitle : .body)
                            .fontWeight(.heavy)
                            .lineLimit(1)
                            .layoutPriority(1)
                        }
                            
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        if priceChange != nil {
                            Text(" " + formattedTextFor(value: priceChange, signed: true))
                            .lineLimit(1)
                            .foregroundColor(Color(foregroundColor(for: priceChange)))
                        } else {
                            Text("EMPTY")
                            .foregroundColor(Color(.clear))
                            .lineLimit(1)
                        }
                        
                        if priceChangePercent != nil {
                            Text(" (" + formattedTextFor(value: priceChangePercent, signed: true) + "%)")
                            .lineLimit(1)
                            .foregroundColor(Color(foregroundColor(for: priceChangePercent)))
                        } else {
                            Text("EMPTY")
                            .foregroundColor(Color(.clear))
                            .lineLimit(1)
                        }
                    }
                }
                
                Spacer()

                self.viewForDate(time, timeZone: timeZone)
                
            }
        }
        
        .font(.subheadline)
    }
    
    
    private func formattedTextFor(value : Double?, signed: Bool) -> String {
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
    
    func viewForDate(_ date: Int?, timeZone: String?) -> some View {
        
        return VStack(alignment: .leading, spacing: 0) {
            
            if date == nil {
                Text("EMPTY")
                .foregroundColor(Color(.clear))
                .lineLimit(1)
                Text("EMPTY")
                .foregroundColor(Color(.clear))
                .lineLimit(1)
            } else {
                Text(self.stringFromDateInSeconds(date: date ?? Int(Date().timeIntervalSince1970), timeZone: timeZone ?? "UTC"))
                    .lineLimit(1)
                                
                Text(self.stringFromDateInDays(date: date ?? Int(Date().timeIntervalSince1970), timeZone: timeZone ?? "UTC"))
                    .lineLimit(1)
            }
        }
    }
    
    private func stringFromDateInSeconds(date: Int, timeZone: String) -> String {
        let dateFormatter = DateFormatter()
        let time = Date(timeIntervalSince1970: Double(date))
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.dateFormat = "HH:mm:ss zzz"
        return dateFormatter.string(from: time)
    }
    
    private func stringFromDateInDays(date: Int, timeZone: String) -> String {
        let dateFormatter = DateFormatter()
        let time = Date(timeIntervalSince1970: Double(date))
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.dateFormat = "E, d MMM yyyy"
        return dateFormatter.string(from: time)
    }
    
    private func foregroundColor(for value: Double?) -> UIColor {
        return value == nil ? UIColor.clear : (value! == 0.0 ? UIColor.lightGray : (value! > 0.0 ? UIColor.systemGreen : UIColor.systemRed))
    }
}

struct CustomInformationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomInformationView(price: 311.12345, priceChange: -10.98765, priceChangePercent: -0.754, time: 150000000, timeZone: "UTC", marketStateText: "Market CLOSED", subMarketStateText: "POST-MARKET", bigPrice: false)
    }
}
