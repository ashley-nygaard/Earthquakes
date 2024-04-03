//
//  QuakeLocation.swift
//  EarthquakesTests
//
//  Created by Ashley Nygaard on 6/21/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct QuakeLocation: Decodable {

  var latitude: Double { properties.products.origin.first!.properties.latitude }
  var longitude: Double { properties.products.origin.first!.properties.longitude }
  private var properties: RootProperties

  struct RootProperties: Decodable {
    var products: Products
  }

  struct Products: Decodable {
    var origin: [Origin]
  }

  struct Origin: Decodable {
    var properties: OriginProperties
  }

  struct OriginProperties {
    var latitude: Double
    var longitude: Double
  }
    // need to assign the lat/long values deep in the property hierarchy for location
    init(latitude: Double, longitude: Double) {
        self.properties =
            RootProperties(products: Products(origin: [
                Origin(properties:
                  OriginProperties(latitude: latitude, longitude: longitude))
        ]))
    }
}

extension QuakeLocation.OriginProperties: Decodable {
  private enum OriginPropertiesCodingKeys: String,  CodingKey {
    case latitude
    case longitude
  }

  // takes the original lat/long as strings and converts them into Doubles
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: OriginPropertiesCodingKeys.self)
    let latitude = try container.decode(String.self, forKey: .latitude)
    let longitude = try container.decode(String.self, forKey: .longitude)
    guard let latitude = Double(latitude),
          let longitude = Double(longitude)
    else {
      throw QuakeError.missingData
    }
    self.latitude = latitude
    self.longitude = longitude
  }
}
