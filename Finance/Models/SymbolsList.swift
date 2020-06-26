//
//  SymbolsList.swift
//  Finance
//
//  Created by Andrii Zuiok on 17.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation

struct SymbolsList: Codable, Equatable, Identifiable {
    var id = UUID()
    var name: String
    var symbolsArray: [String]
    var isActive: Bool
    
    init(name: String, symbolsArray: [String], isActive: Bool = true) {
        self.name = name
        self.symbolsArray = symbolsArray
        self.isActive = isActive
    }
    
}
