//
//  WebView.swift
//  Finance
//
//  Created by Andrii Zuiok on 06.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
 
    let  url: URL?
   
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        webView.load(URLRequest(url: url!))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
    }
    
    
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: URL(string: "https://finance.yahoo.com/news/europe-pins-hopes-smarter-coronavirus-111118443.html?.tsrc=rss"))
    }
}
