//
//  QuakeError.swift
//  Earthquakes-iOS
//
//  Created by Ashley Nygaard on 6/21/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

enum QuakeError: Error {
  case missingData
  case networkError
}

extension QuakeError: LocalizedError {
  var description: String? {
    switch self {
    case .missingData: return NSLocalizedString("Found and will discard a quake missing a valid code, magnitude, place or time", comment: "")
    case .networkError: return NSLocalizedString("Could not get quakes from network", comment: "")
    }
  }
}
