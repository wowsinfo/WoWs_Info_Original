//
//  CacheCleaner.swift
//  WoWs Info
//
//  Created by Henry Quan on 27/5/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class CacheCleaner {

    static func cleanCache() {
        let fileManager = FileManager.default
        let cacheUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let cache = cacheUrl.path
        
        do {
            if let cachePath = cache {
                let folders = try fileManager.contentsOfDirectory(atPath: "\(cachePath)")
                for folder in folders {
                    if folder.contains("Snapshots") || folder.contains("YihengQuan.Handbook") {
                        continue
                    } else {
                        // Remove everything
                        let enumerator = fileManager.enumerator(atPath: "\(cachePath)/\(folder)")
                        while let file = enumerator?.nextObject() as? String {
                            try fileManager.removeItem(atPath: "\(cachePath)/\(folder)/\(file)")
                            print("\(file) is removed")
                        }
                    }
                }
            }
        } catch {
            print("Could not clean cache: \(error)")
        }
    }
    
}
