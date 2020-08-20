//
//  XmlRssParcer.swift
//  Finance
//
//  Created by Andrii Zuiok on 03.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation

class XmlRssParser: NSObject, XMLParserDelegate {
    
    var rssItems: [RSSItem] = []
    
    var currentItem: RSSItem?
    
    private var currentElement = ""

    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parsedItemsFromData(_ data: Data?) ->  [RSSItem] {
        guard let data = data else { return [] }
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return rssItems
    }
    
    
// MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "item" {
            self.currentItem = RSSItem()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {

        switch currentElement {
        case "title":
            currentItem?.title += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "description" :
            currentItem?.description += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "pubDate":
            currentItem?.pubDate += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "guid":
            currentItem?.guid += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "link":
            currentItem?.link += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let currentItem = currentItem {
                rssItems.append(currentItem)
            }
        }
    }
    
//    func parserDidEndDocument(_ parser: XMLParser) {
//        parserCompletionHandler?(rssItems)
//    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        //debugPrint(parseError.localizedDescription)
    }
    
}
