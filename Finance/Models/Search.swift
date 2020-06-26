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

// MARK: - Search
public struct Search: Codable {
    public let resultSet: ResultSet

    enum CodingKeys: String, CodingKey {
        case resultSet = "ResultSet"
    }

    public init(resultSet: ResultSet) {
        self.resultSet = resultSet
    }
}

// MARK: - ResultSet
public struct ResultSet: Codable {
    public let query: String
    public let result: [StockAttributes]

    enum CodingKeys: String, CodingKey {
        case query = "Query"
        case result = "Result"
    }

    public init(query: String, result: [StockAttributes]) {
        self.query = query
        self.result = result
    }
}

// MARK: - Result
public struct StockAttributes: Codable, Identifiable {
    public var id: String {return self.symbol}
    
    public let symbol: String
    public let name: String
    public let exch: String
    public let type: String
    public let exchDisp: String
    public let typeDisp: String

    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case name = "name"
        case exch = "exch"
        case type = "type"
        case exchDisp = "exchDisp"
        case typeDisp = "typeDisp"
    }

    public init(symbol: String, name: String, exch: String, type: String, exchDisp: String, typeDisp: String) {
        self.symbol = symbol
        self.name = name
        self.exch = exch
        self.type = type
        self.exchDisp = exchDisp
        self.typeDisp = typeDisp
    }
}
