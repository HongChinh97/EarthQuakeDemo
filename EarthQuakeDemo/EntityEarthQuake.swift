//
//  EntityEarthQuake.swift
//  EarthQuakeDemo
//
//  Created by Hồng Chinh on 5/22/19.
//  Copyright © 2019 gh. All rights reserved.
//

import Foundation
import UIKit
struct EntityEarthQuake: Decodable {
    let features: [Feature]
    struct Feature: Decodable {
        let properties: Properties
        class Properties: Decodable {
            var mag: Double
            var time: TimeInterval
            var place: String
            var url : String
        }
    }
}
struct ExEntityEarthQuake: Decodable {
    var event: [Event]
    struct Event: Decodable {
        var dateString: String
        var timeString: String
        var mag: Double
        var distanceString: String?
        var locationName: String?
        var url: String
    }
    init(service: EntityEarthQuake) {
        self.event = service.features.map({(feature) -> Event in
            let dateString = feature.properties.time.toMediumDate()
            let timeString = feature.properties.time.toShortTime()
            let mag = feature.properties.mag
            let url = feature.properties.url
            var locationName = feature.properties.place
            
            let placeStrings = feature.properties.place.components(separatedBy: "of")
            var distanceStrings = ""
            if placeStrings.count > 1 {
                distanceStrings = placeStrings.first!
                if let index = (locationName.range(of: "of")?.upperBound) {
                    locationName = String(locationName.suffix(from: index))
                }
            }
            return Event(dateString: dateString, timeString: timeString, mag: mag, distanceString: distanceStrings, locationName: locationName, url: url)
        })
    }
}
extension TimeInterval {
    func toShortTime() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .none
        dateFormater.timeStyle = .short
        return dateFormater.string(from: Date(timeIntervalSince1970: self/1000))
    }
    func toMediumDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        dateFormater.timeStyle = .short
        return dateFormater.string(from: Date(timeIntervalSince1970: self/1000))
    }
}
