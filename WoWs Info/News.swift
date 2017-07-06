//
//  News.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/3/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import Kanna

class News {

    let server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
    var url: String!
    static var news: [[String]]!
    var serverUrl: String!
    
    struct dataIndex {
        static let title = 0
        static let link = 1
        static let time = 2
    }
    
    init() {
        serverUrl = "https://worldofwarships." + ServerUrl.Server[server]
    }
    
    func getRequestUrl() -> String {
        
        var url = "https://worldofwarships." + ServerUrl.Server[server]
        if server == DataManagement.ServerIndex.Asia {
            url += "/set_language/" + getCurrLang()
        }
        
        return url
        
    }
    
    func getCurrLang() -> String {
        var language = Language.getLanguageString(Mode: Language.Index.News).replacingOccurrences(of: "&language=", with: "")
        if language == "zh-cn" {
            language = "zh-tw"
        }
        
        switch language {
            case "cs", "de", "en", "es", "fr", "pl", "ru", "th", "tr", "pt-br", "es-mx":
                language = "en"
            default:
                break
        }
        
        return language
    }
    
    func getNews(success: @escaping ([[String]]) -> ()){
    
        let urlRequest = URLRequest(url: URL(string: getRequestUrl())!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, responce, error) in
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                var newsInfo = [[String]]()
                if let news = HTML(html: data!, encoding: .utf8) {
                    
                    for link in news.css(".tile__title") {
                        newsInfo.append([link.text!, "", ""])
                    }
                    
                    var index = 0
                    for link in news.css(".fit-link") {
                        newsInfo[index][1] = self.serverUrl + link["href"]!
                        index += 1
                    }
                    
                    index = 0
                    for link in news.css("._date") {
                        newsInfo[index][2] = link.text!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
                        index += 1
                    }
                }
                success(newsInfo)
            }
        }
        task.resume()
    }
    
}
