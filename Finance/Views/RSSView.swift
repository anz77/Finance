//
//  RssView.swift
//  Finance
//
//  Created by Andrii Zuiok on 04.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI

struct RSSView: View {
    var item: RSSItem
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text(self.item.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(3)
                .padding([.leading, .trailing, .top])
            
            Text(stringFromDateFromString(string: self.item.pubDate))
                .font(.headline)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .padding([.leading, .trailing])
            
            Divider()
            .padding(.horizontal)
            
        }
        
    }
    
    
    func stringFromDateFromString(string: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZZ"
        let time = dateFormatter.date(from: string)
        guard let flattime = time else { return "" }
        let delta = Int(Date().timeIntervalSince(flattime))
        switch delta {
        case 0..<60:
            return "\(delta) sec ago"
        case 60..<3600:
            let minutes = delta / 60
            return "\(minutes) min ago"
        case 3600..<86400:
            let hours = delta / 3600
            return "\(hours) hour ago"
        case 86400... :
            let days = delta / 86400
            return "\(days) day ago"
        default:
            return ""
        }
    }
    
    func textHeightFrom(text: String, width: CGFloat, fontName: String = "System Font", fontSize: CGFloat = UIFont.systemFontSize) -> CGFloat {
    
            let labelText: UILabel = .init()
            labelText.text = text
            labelText.numberOfLines = 0

            labelText.font = UIFont.init(name: fontName, size: fontSize)
            labelText.lineBreakMode = .byWordWrapping
            return labelText.sizeThatFits(CGSize.init(width: width, height: .infinity)).height
        }
    
}



struct RSSView_Previews: PreviewProvider {
    static var previews: some View {
        RSSView(item: RSSItem(id: UUID(), description: "European countries cautiously emerging from the onslaught of the coronavirus pandemic are looking to a second generation of contact tracing apps to help contain further outbreaks. The latest apps have big advantages over earlier ones as they work on Apple's iPhone, one of the most popular smartphones in Europe, and do not rely on centralized databases that could compromise privacy. Switzerland, Latvia and Italy have opted for Bluetooth short-range radio for their apps, based on technology from Apple and Google that securely logs exchanges on the smartphones of people who have been near each other.", title: "Europe pins hopes on smarter coronavirus contact tracing apps", pubDate: "Thu, 04 Jun 2020 11:11:18 +0000", guid: "54b3b6c8-81a2-36b7-8f95-d50b9c066716", link: "https://finance.yahoo.com/news/europe-pins-hopes-smarter-coronavirus-111118443.html?.tsrc=rss"))
    }
}
