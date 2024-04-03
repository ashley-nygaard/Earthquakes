//
//  QuakeClient.swift
//  Earthquakes-iOS
//
//  Created by Ashley Nygaard on 6/21/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

// actor protects the cache from simultaneous access from multiple threads
actor QuakeClient {
  // use the subscript to access the contents of the cache
  private let quakeCache: NSCache<NSString, CacheEntryObject> = NSCache()
  
  var quakes: [Quake] {
    get async throws {
      let data = try await downloader.httpData(from: feedURL)
      let allQuakes = try decoder.decode(GeoJSON.self, from: data)
      var updatedQuakes = allQuakes.quakes
        if let olderThanOneHour = updatedQuakes.firstIndex(where: { $0.time.timeIntervalSinceNow > 3600 }) {
            let indexRange = updatedQuakes.startIndex..<olderThanOneHour
            try await withThrowingTaskGroup(of: (Int, QuakeLocation).self) { group in
                for index in indexRange {
                    group.addTask {
                        let location = try await self.quakeLocation(from: allQuakes.quakes[index].detail)
                        return (index, location)
                    }
                }
                while let result = await group.nextResult() {
                    switch result {
                    case .failure(let error):
                        throw error
                    case .success(let (index, location)):
                        updatedQuakes[index].location = location
                    }
                }
            }
        }
      return allQuakes.quakes
    }
  }
  
  private lazy var decoder: JSONDecoder = {
    let aDecoder = JSONDecoder()
    aDecoder.dateDecodingStrategy = .millisecondsSince1970
    return aDecoder
  }()
  
  
  // URL string that is correct, force unwrap the url initializer
  private let feedURL = URL(string:  "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!
  
  private let downloader: any HTTPDataDownloader
  
  init(downloader: any HTTPDataDownloader = URLSession.shared){
    self.downloader = downloader
  }
    
    func quakeLocation(from url: URL) async throws -> QuakeLocation {
       // check for cached value, if task is in-progress avoid making second network request
        if let cached = quakeCache[url]{
            switch cached {
            case .ready(let location):
                return location
            case .inProgress(let task):
                return try await task.value
            }
    
        }
        // use task to store the task and check progress later
        // saving task in the cache make sure future fetches wait on in-progress instead of new network request
        let task = Task<QuakeLocation, Error> {
            let data = try await downloader.httpData(from: url)
            let location = try decoder.decode(QuakeLocation.self, from: data)
            return location
        }
     
        quakeCache[url] = .inProgress(task)
        do {
            let location = try await task.value
            quakeCache[url] = .ready(location)
            return location
        } catch {
            quakeCache[url] = nil
            throw error
        }
    
    }
}
