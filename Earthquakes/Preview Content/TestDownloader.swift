//
//  TestDownloader.swift
//  Earthquakes-iOS
//
//  Created by Ashley Nygaard on 6/21/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

class TestDownloader: HTTPDataDownloader {
  func httpData(from url: URL) async throws -> Data {
    // simulates network delays
    try await Task.sleep(nanoseconds: UInt64.random(in: 100_000_000...500_000_000))
    return testQuakesData
  }
}
