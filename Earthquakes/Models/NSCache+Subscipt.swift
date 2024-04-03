//
//  NSCache+Subscipt.swift
//  Earthquakes-iOS
//
//  Created by Ashley Nygaard on 4/2/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {
    // define subscript to read/write to cache
    subscript(_ url: URL) -> CacheEntry? {
        // generic constraint, method object (forKey) takes a string and returns optional CacheEntryObject
        get {
            let key = url.absoluteString as NSString
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = url.absoluteString as NSString
            if let entry = newValue {
                let value = CacheEntryObject(entry: entry)
                setObject(value, forKey: key)
            } else {
                // if object is nil remove it. This mirrors behavior of Dictionary
                removeObject(forKey: key)
            }
        }
    }
}
