//
//  WebClient.swift
//  CityWeatherApp
//
//  Created by Wajeeha on 2022-10-14.
//

import Foundation
enum NetworkError: Error {
    case badURL
    case badID
}

class WebClient {
    func getCities(searchText: String) async throws -> [String] {
        guard let url = URL(string: "http://gd.geobytes.com/AutoCompleteCity?%20q=\(searchText)") else {
            throw NetworkError.badURL
        }
        let (data,response) = try await URLSession.shared.data(from: url)
        let cityResponse = try? JSONDecoder().decode([String].self, from: data)
        return cityResponse ?? []
    }
}
