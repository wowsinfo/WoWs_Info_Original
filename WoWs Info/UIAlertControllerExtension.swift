//
//  UIAlertController+QuickMessage.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/6/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func QuickMessage(title: String, message: String, cancel: String) -> UIAlertController {
        let msg = UIAlertController(title: title, message: message, preferredStyle: .alert)
        msg.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        return msg
    }
    
}
