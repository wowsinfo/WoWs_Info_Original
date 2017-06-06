//
//  DataUpdater.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/6/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import Kanna

class DataUpdater {
    
    static func update() -> Bool {
        // Get path for ExpectedValue.json
        if let data = HTML(url: URL(string: "http://wows-numbers.com/personal/rating/expected/json/")!, encoding: .utf8) {
            do {
                // Try to update data
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
                if let pathUrl = path.appendingPathComponent("ExpectedValue.json") {
                    print(pathUrl.path)
                    // Write to document
                    try data.text?.write(to: pathUrl, atomically: false, encoding: .utf8)
                    // Success
                    return true
                }
            } catch let error as NSError {
                // Error
                print("Error: \(error)")
            }
        }
        return false
    }
    
    static func hasData() -> Bool {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        if let pathUrl = path.appendingPathComponent("ExpectedValue.json") {
            return FileManager().fileExists(atPath: pathUrl.path)
        }
        return false
    }

}
