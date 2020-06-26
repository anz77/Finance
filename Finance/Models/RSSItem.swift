//
//  RSS.swift
//  Finance
//
//  Created by Andrii Zuiok on 08.05.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation

//MARK: RSSITEM
struct RSSItem:  Codable, CustomDebugStringConvertible {
    
    var id = UUID()
    var description = ""
    var title = ""
    var pubDate = ""
    var guid = ""
    var link = ""
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case guid = "guid"
        case link = "link"
        case title = "title"
        case pubDate = "pubDate"
    }
    
    var debugDescription: String { "description = \(description), title = \(title), pubDate = \(pubDate), guid = \(guid), link = \(link)" }
}
