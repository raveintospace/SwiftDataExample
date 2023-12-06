//
//  CityModel.swift
//  SwiftDataExample
//
//  Created by Uri on 6/12/23.
//

import Foundation
import SwiftData

@Model
class CityModel{
    var name: String
    var country: CountryModel?
    
    init(name: String, country: CountryModel? = nil) {
        self.name = name
        self.country = country
    }
    
    static func getRandomCity() -> CityModel{
        let cities = [
            CityModel(name: "Caracas"),
            CityModel(name: "Bogotá"),
            CityModel(name: "Tokyo"),
            CityModel(name: "Delhi"),
            CityModel(name: "Shanghai"),
            CityModel(name: "São Paulo"),
            CityModel(name: "Mumbai"),
            CityModel(name: "Beijing"),
            CityModel(name: "Dhaka"),
            CityModel(name: "Osaka"),
            CityModel(name: "Cairo"),
            CityModel(name: "Karachi"),
            CityModel(name: "Chongqing"),
            CityModel(name: "Istanbul"),
            CityModel(name: "Lahore"),
            CityModel(name: "Manila"),
            CityModel(name: "Rio de Janeiro"),
            CityModel(name: "Tianjin"),
            CityModel(name: "Kinshasa"),
            CityModel(name: "Guangzhou"),
            CityModel(name: "Lima"),
        ]
        return cities.randomElement()!
    }
}
