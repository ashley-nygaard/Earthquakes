//
//  CacheEntryObject.swift
//  Earthquakes-iOS
//
//  Created by Ashley Nygaard on 4/2/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

// NSCache only holds reference types. Class will hold enum values
// make each instance immutable using final and let
final class CacheEntryObject {
    let entry: CacheEntry
    init(entry: CacheEntry) {self.entry = entry}
}
enum CacheEntry {
    // ensures multiple calls cannot access till location was loaded
    case inProgress(Task<QuakeLocation, Error>)
    case ready(QuakeLocation)
}

