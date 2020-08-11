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
    
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var webView: WebView
//
//        init(webView: WebView) {
//            self.webView = webView
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
////            print(webView)
////
////            let elementID = "YDC-UH"
////            let removeElementIdScript = "var element = document.getElementById('\(elementID)'); element.parentElement.removeChild(element);"
////
////            webView.evaluateJavaScript(removeElementIdScript) { (response, error) in
////                //debugPrint(response)
////            debugPrint(error ?? "all is OK!")
////
////                debugPrint("Im here")
////            }
//
//        }
//    }
    
    let  url: URL?
    
    
    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(webView: self)
//    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
//        let elementID = "YDC-UH"
//
//        var scriptString: String {
//            return """
//            var element = document.getElementById('\(elementID)'); element.parentElement.removeChild(element);
//            """
//        }
//
//        let script = WKUserScript(source: scriptString, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
//        let config = webView.configuration
//        config.userContentController.addUserScript(script)
        
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
