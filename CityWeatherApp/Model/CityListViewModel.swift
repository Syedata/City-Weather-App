//
//  CityListViewModel.swift
//  CityWeatherApp
//
//  Created by Wajeeha on 2022-10-14.
//

import Foundation
class CityListViewModel : ObservableObject {
    @Published var cities: [String] = []
    func search(name: String) async {
        do {
            let cities = try await WebClient().getCities(searchText: name)
            self.cities = cities
        } catch {
            print(error)
        }
    }
}
