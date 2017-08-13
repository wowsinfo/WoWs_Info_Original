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
    
}
