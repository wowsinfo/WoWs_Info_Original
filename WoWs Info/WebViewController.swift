//
//  WebViewController.swift
//  WoWs Info
//
//  Created by Henry Quan on 4/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController : UIViewController, WKUIDelegate {
    
    var url = ""
    var webView: WKWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Loading..."
        
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        // Load url into webview
        let myRequest = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        webView.load(myRequest)
        
        perform(#selector(loadingDone), with: nil, afterDelay: 5)
        
    }
    
    func loadingDone() {
        self.title = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(true)
        
        // Clear cache and memory
        print("Cleaning!")
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        // Clear Cookies
        print("Cookies!")
        _ = HTTPCookie.self
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            print(cookie.name+"="+cookie.value)
            cookieJar.deleteCookie(cookie)
        }
        
        print("WKWebView!")
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies])
        let date = NSDate(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        
        webView.evaluateJavaScript("localStorage.clear();", completionHandler: nil)
        
    }

    @IBAction func openInSafari(_ sender: UIBarButtonItem) {
        // Open in safari
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
}
