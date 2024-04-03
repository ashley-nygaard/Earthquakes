//
//  QuakeDetailMap.swift
//  Earthquakes-iOS
//
//  Created by Ashley Nygaard on 4/2/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI
import MapKit

struct QuakeDetailMap: View {
    @State private var region = MKCoordinateRegion()
    let location: QuakeLocation
    let tintColor: Color
    private var place: QuakePlace
    
    init(location: QuakeLocation, tintColor: Color) {
        self.location = location
        self.tintColor = tintColor
        self.place = QuakePlace(location: location)
    }
    
    var body: some View {
        // coordinateRegion will be depecrated, need to use Map init MapContentBuilder
        // single market for quake location
        Map(coordinateRegion: $region, annotationItems: [place]) { place in
            MapMarker(coordinate: place.location, tint: tintColor)
        }
        .onAppear {
            withAnimation {
                region.center = place.location
                region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            }
        }
    }
}

// map requires lat/long to be in CLLocation.. format. Need to convert from doubles
struct QuakePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID = UUID(), location: QuakeLocation) {
        self.id = id
        self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}
