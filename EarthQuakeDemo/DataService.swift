//
//  DataService.swift
//  EarthQuakeDemo
//
//  Created by Hồng Chinh on 5/22/19.
//  Copyright © 2019 gh. All rights reserved.
//

import Foundation
import UIKit
class DataService {
    static let shared: DataService = DataService()
    func requestApi(compleHandle: @escaping([ExEntityEarthQuake.Event]) -> ()) {
        guard let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson") else { return}
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let aData = data else {return}
            do {
                let service = try JSONDecoder().decode(EntityEarthQuake.self, from: aData)
                let earthQuake = (ExEntityEarthQuake(service: service))
                DispatchQueue.main.async {
                    compleHandle(earthQuake.event)
                }
            }
            catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}
