//
//  JSON+merge.swift
//  WoWs Info
//
//  Created by Yiheng Quan on 12/8/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import SwiftyJSON

extension JSON {
    mutating func merge(other: JSON) {
        if self.type == other.type {
            switch self.type {
            case .dictionary:
                for (key, _) in other {
                    self[key].merge(other: other[key])
                }
            case .array:
                self = JSON(self.arrayValue + other.arrayValue)
            default:
                self = other
            }
        } else {
            self = other
        }
    }
    
    func merged(other: JSON) -> JSON {
        var merged = self
        merged.merge(other: other)
        return merged
    }
}
