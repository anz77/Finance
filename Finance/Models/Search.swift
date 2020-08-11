//
//  Search.swift
//  Finance
//
//  Created by Andrii Zuiok on 08.04.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let search = try? newJSONDecoder().decode(Search.self, from: jsonData)

import Foundation

// // MARK: - Search
//public struct Search: Codable {
//    public let resultSet: ResultSet
//
//    enum CodingKeys: String, CodingKey {
//        case resultSet = "ResultSet"
//    }
//
//    public init(resultSet: ResultSet) {
//        self.resultSet = resultSet
//    }
//}
//
//// MARK: - ResultSet
//public struct ResultSet: Codable {
//    public let query: String
//    public let result: [StockAttributes]
//
//    enum CodingKeys: String, CodingKey {
//        case query = "Query"
//        case result = "Result"
//    }
//
//    public init(query: String, result: [StockAttributes]) {
//        self.query = query
//        self.result = result
//    }
//}
//
//// MARK: - Result
//public struct StockAttributes: Codable, Identifiable {
//    public var id: String {return self.symbol}
//
//    public let symbol: String
//    public let name: String
//    public let exch: String
//    public let type: String
//    public let exchDisp: String
//    public let typeDisp: String
//
//    enum CodingKeys: String, CodingKey {
//        case symbol = "symbol"
//        case name = "name"
//        case exch = "exch"
//        case type = "type"
//        case exchDisp = "exchDisp"
//        case typeDisp = "typeDisp"
//    }
//
//    public init(symbol: String, name: String, exch: String, type: String, exchDisp: String, typeDisp: String) {
//        self.symbol = symbol
//        self.name = name
//        self.exch = exch
//        self.type = type
//        self.exchDisp = exchDisp
//        self.typeDisp = typeDisp
//    }
//}



// MARK: - Search
public struct Search: Codable {
    public var data: DataClass?
    public var meta: SearchMeta?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case meta = "meta"
    }

    public init(data: DataClass?, meta: SearchMeta?) {
        self.data = data
        self.meta = meta
    }
}

// MARK: - DataClass
public struct DataClass: Codable {
    public var suggestionTitleAccessor: String?
    public var suggestionMeta: [String]?
    public var hiConf: Bool?
    public var items: [StockAttributes]?
    
    
    enum CodingKeys: String, CodingKey {
        case suggestionTitleAccessor = "suggestionTitleAccessor"
        case suggestionMeta = "suggestionMeta"
        case hiConf = "hiConf"
        case items = "items"
    }

    public init(suggestionTitleAccessor: String?, suggestionMeta: [String]?, hiConf: Bool?, items: [StockAttributes]?) {
        self.suggestionTitleAccessor = suggestionTitleAccessor
        self.suggestionMeta = suggestionMeta
        self.hiConf = hiConf
        self.items = items
    }
}

// MARK: - Item
public struct StockAttributes: Codable, Identifiable {
    public var id: String {return self.symbol ?? ""}
    
    public var symbol: String?
    public var name: String?
    public var exch: String?
    public var type: String?
    public var exchDisp: String?
    public var typeDisp: String?
    
    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case name = "name"
        case exch = "exch"
        case type = "type"
        case exchDisp = "exchDisp"
        case typeDisp = "typeDisp"
    }

    public init(symbol: String?, name: String?, exch: String?, type: String?, exchDisp: String?, typeDisp: String?) {
        self.symbol = symbol
        self.name = name
        self.exch = exch
        self.type = type
        self.exchDisp = exchDisp
        self.typeDisp = typeDisp
    }
}

// MARK: - Meta
public struct SearchMeta: Codable {

    public init() {
    }
}
