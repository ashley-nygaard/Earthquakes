//
//  QuakesProvider.swift
//  Earthquakes-iOS
//
//  Created by Ashley Nygaard on 6/21/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

@MainActor
class QuakesProvider: ObservableObject {
  @Published var quakes: [Quake] = []
  
  let client: QuakeClient
  
  func fetchQuakes() async throws {
    let lastestQuakes = try await client.quakes
    self.quakes = lastestQuakes
  }
  
  func deleteQuakes(atOffsets offsets: IndexSet) {
    quakes.remove(atOffsets: offsets)
  }
  
  init(client: QuakeClient = QuakeClient()) {
    self.client = client
  }
  
  
}
