//
//  Language.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class Language {
    
    static func getLanguageString() -> String {
        
        var language = NSLocale.preferredLanguages[0].lowercased()
        
        // Wargaming has different chinese string
        switch language {
            case "cs", "de", "en", "es", "fr", "ja", "pl", "ru", "th", "tr", "pt-br", "es-mx", "ko":
                // All valid
                break
            case "zh-hans":
                language = "zh-cn"
            case "zh-hant":
                language = "zh-tw"
            default:
                // Otherwise, set it to English
                language = "en"
        }
        
        return "&language=\(language)"
        
    }
    
}
