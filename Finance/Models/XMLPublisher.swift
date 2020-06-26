//
//  XMLPublisher.swift
//  Finance
//
//  Created by Andrii Zuiok on 15.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation
import Combine

// MARK: - SUBSCRIPTION FOR XMLPUBLISHER FOR RSS

class XMLSubscription<S: Subscriber>: NSObject, XMLParserDelegate, Subscription where S.Input == [RSSItem], S.Failure == Error {
    
    let data: Data?
    private var subscriber: S?
    
    var rssItems: [RSSItem] = []
    var currentItem: RSSItem?
    private var currentElement = ""
        
    init(data: Data?, subscriber: S) {
        self.data = data
        self.subscriber = subscriber
    }
    
    func request(_ demand: Subscribers.Demand) {
        self.parseItemsFromData()
    }
    
    func cancel() {
        subscriber = nil
    }
    
    func parseItemsFromData() {
        guard let subscriber = subscriber else { return }
        guard let data = data else { return }
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        _ = subscriber.receive(rssItems)
        _ = subscriber.receive(completion: Subscribers.Completion.finished)
    }
    
    
// MARK: - XMLPARSERDELEGATE METHODS
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            self.currentItem = RSSItem()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentItem?.title += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "description": currentItem?.description += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "pubDate": currentItem?.pubDate += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "guid": currentItem?.guid += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "link": currentItem?.link += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        guard let subscriber = subscriber else { return }
        _ = subscriber.receive(completion: Subscribers.Completion.failure(parseError))
    }
    
    //func parserDidEndDocument(_ parser: XMLParser) { }
}


//MARK: - CUSTOM XMLPARSER PUBLISHER FOR RSSITEMS
struct XMLPublisher: Publisher {
    typealias Output = [RSSItem]
    typealias Failure = Error
    
    private let data: Data?
    
    init(data: Data?) {
        self.data = data
    }
    
    func receive<S: Subscriber>(subscriber: S) where
        XMLPublisher.Failure == S.Failure, XMLPublisher.Output == S.Input {
            let subscription = XMLSubscription(data: data, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
    }
}
