//
//  GeoJSON.swift
//  EarthquakesTests
//
//  Created by Ashley Nygaard on 6/21/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct GeoJSON: Decodable {
  
    // tell the decoder which keys of the root object to decode
  private enum RootCodingKeys: String, CodingKey {
    case features
  }
  
  private enum FeatureCodingKeys: String, CodingKey {
    case properties
  }
  
  // private(set) means code within stuct can modify quakes property but outside is read only
  private(set) var quakes: [Quake] = []
  
  init(from decoder: Decoder) throws {
    let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
    var featuresContainer = try rootContainer.nestedUnkeyedContainer(forKey: .features)
    
    while !featuresContainer.isAtEnd {
      let propertiesContainer = try featuresContainer.nestedContainer(keyedBy: FeatureCodingKeys.self)
      
      // try? ignores quakes with missing data
      if let properties = try? propertiesContainer.decode(Quake.self, forKey: .properties) {
        quakes.append(properties)
      }
    }
  }
  
}
