//
//  FileManagerExtension.swift
//  WoWs Info
//
//  Created by Yiheng Quan on 14/8/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

extension FileManager {
    // MARK: Save DATA Locally
    static func Save(Data: JSON, Name: String) {
        do {
            // Try to save data
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
            if let pathUrl = path.appendingPathComponent(Name) {
                print(pathUrl.path)
                // Write to document
                try Data.rawString()?.write(toFile: pathUrl.path, atomically: false, encoding: .utf8)
            }
        } catch let error as NSError {
            // Error
            print("Error: \(error)")
        }
    }
    
    // MARK: Load local DATA
    static func Load(Name: String) -> JSON {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let pathUrl = path.appendingPathComponent(Name)!
        print("This file is here\n\(pathUrl.path)\n")
        if FileManager.default.fileExists(atPath: pathUrl.path) {
            return JSON(NSData(contentsOfFile: pathUrl.path)!)
        }
        return JSON.null
    }

}
