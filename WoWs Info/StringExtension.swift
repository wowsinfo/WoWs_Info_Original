//
//  String+Localised.swift
//  WoWs Info
//
//  Created by Henry Quan on 6/6/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

extension String {
    // MARK: Localisation
    func localised() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    // MARK: Current Language String
    static func getCurrLanguageString() -> String {
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
        
        return "&language=\(language)"
    }
}
