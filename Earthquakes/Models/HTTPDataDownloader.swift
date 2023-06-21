//
//  HTTPDataDownloader.swift
//  EarthquakesTests
//
//  Created by Ashley Nygaard on 6/21/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

let validStatus = 200...299

// abstracts the network transport from the rest of the client code
protocol HTTPDataDownloader {
  func httpData(from: URL) async throws -> Data
}

extension URLSession: HTTPDataDownloader {
  func httpData(from url: URL) async throws -> Data {
    // simplifies call to URLSession by throwing network error
    guard let (data,response) = try await self.data(from:url, delegate:nil) as? (Data, HTTPURLResponse), validStatus.contains(response.statusCode) else {
      throw QuakeError.networkError
    }
    return data
  }
}
