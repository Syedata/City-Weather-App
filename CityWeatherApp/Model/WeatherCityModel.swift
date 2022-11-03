//
//  WeatherResultsModel.swift
//  CityWeatherApp
//
//  Created by Wajeeha on 2022-10-17.
// http://openweathermap.org/img/wn/10d@2x.png
//
//

import Foundation
struct weatherResults : Codable {
    var weather : [Weather]?
    var main : Main
}
struct Main : Codable{
    var temp  : Float
}
struct Weather : Codable {
    var icon : String?
}
