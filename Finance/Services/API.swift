//
//  YahooFinance.swift
//  Finance
//
//  Created by Andrii Zuiok on 01.04.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation
import Combine

enum API {
    
    static func decode<T>(_ t: T.Type, _ jsonData: Data) -> T? where T: Codable {
        do {
            let decodedObject = try JSONDecoder().decode(t, from: jsonData)
            return decodedObject
        } catch {
            //debugPrint("DECODING ERROR!!!\n")
            return nil
        }
    }

}

func storeDefaultsFromSymbolLists(_ list: [SymbolsList]) {
    let defaults = UserDefaults.standard
    let listEncoder = JSONEncoder()
    
    do {
        let encodedLists = try listEncoder.encode(list)
        defaults.set(encodedLists, forKey: "DefaultLists")
        
    }
    catch {
        //debugPrint("error writing to defaults")
    }
}



func getDefaultLists() -> [SymbolsList] {
    let defaults = UserDefaults.standard
    if let savedStockAttributes = defaults.object(forKey: "DefaultLists") as? Data {
        let decoder = JSONDecoder()
        if let array = try? decoder.decode([SymbolsList].self, from: savedStockAttributes) {
            return array
        }
    }
    return [SymbolsList]()
}
