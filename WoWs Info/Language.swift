//
//  Language.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class Language {
    
    struct Index {
        static let auto = 0
        static let sChinese = 1
        static let tChinese = 2
        static let English = 3
        static let API = 0
        static let News = 1
    }
    
    static func getLanguageString(Mode: Int) -> String {
        var language = Locale.preferredLanguages[0].lowercased()
        language = language.components(separatedBy: "-").first!
        
        // Wargaming has different chinese string
        switch language {
            case "cs", "de", "en", "es", "fr", "ja", "pl", "ru", "th", "tr", "pt", "es", "ko":
                // All valid
                break
            case "zh":
                language = "zh-tw"
            default:
                // Otherwise, set it to English
                language = "en"
        }
        
        var user: Int
        if Mode == 0 {
            user = UserDefaults.standard.integer(forKey: DataManagement.DataName.APILanguage)
        } else {
            user = UserDefaults.standard.integer(forKey: DataManagement.DataName.NewsLanague)
        }
        
        switch user {
            case Language.Index.sChinese: return "&language=zh-cn"
            case Language.Index.tChinese: return "&language=zh-tw"
            case Language.Index.English: return "&language=en"
            default: return "&language=\(language)"
        }
    }
    
}
