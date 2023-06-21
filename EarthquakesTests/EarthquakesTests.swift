//
//  EarthquakesTests.swift
//  EarthquakesTests
//
//  Created by Ashley Nygaard on 6/21/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import XCTest

@testable import Earthquakes

class EarthquakesTests: XCTestCase {
  
  func testGeoJSONDecoderDecodesQuake() throws {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    let quake = try decoder.decode(Quake.self, from: testFeature_nc73649170)
    
    XCTAssertEqual(quake.code, "73649170")
    
    let expectedSeconds = TimeInterval(1636129710550) / 1000
    let decodedSeconds = quake.time.timeIntervalSince1970
    
    XCTAssertEqual(expectedSeconds, decodedSeconds, accuracy: 0.00001)
    
    let tsunamiWarning = quake.tsunami
    
    XCTAssertEqual(tsunamiWarning, 0)
  }
  
  func testGeoJSONDecoderDecodesGeoJSON() throws {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    let decoded = try decoder.decode(GeoJSON.self, from: testQuakesData)
    
    XCTAssertEqual(decoded.quakes.count, 6)
    XCTAssertEqual(decoded.quakes[0].code,  "73649170")
    
    let expectedSeconds = TimeInterval(1636129710550) / 1000
    let decodedSeconds = decoded.quakes[0].time.timeIntervalSince1970

    XCTAssertEqual(expectedSeconds, decodedSeconds, accuracy: 0.00001)

  }
}
