//
//  InitialTableViewCell.swift
//  CityWeatherApp
//
//  Created by Wajeeha on 2022-10-17.
// http://openweathermap.org/img/wn/10d@2x.png

import UIKit

class InitialTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(item : City)  {
        textLabel?.text = item.cityName
        detailTextLabel?.text = "Temperature..."
        imageView?.image = UIImage(systemName: "photo")
        
        
        if let cityName = item.cityName{
            let query = [ "q" : cityName , "appid" : api_key_Value]
            let url = "https://api.openweathermap.org/data/2.5/weather?&"
            WeatherCityService.shared.getData(url: url,query: query) { (result) in
                switch result {
                case .failure(let error ):
                    print("\(error)")
                case .success(let data):
                    if let weather = try? JSONDecoder().decode(weatherResults.self, from: data) {
                        let url = "http://openweathermap.org/img/wn/\(weather.weather?[0].icon ?? "")@2x.png"
                        WeatherCityService.shared.getData(url: url, query: nil) { result in
                            switch result {
                            case .success(let imgdata):
                                let img = UIImage(data: imgdata)
                                DispatchQueue.main.async {
                                    self.imageView?.image = img
                                }
                            case .failure(let error):
                                print("\(error)")
                            }
                        }
                        DispatchQueue.main.async {
                            self.detailTextLabel?.text = weather.main.temp.description
                        }
                        
                        //  detailTextLabel?.text = weather.main.temp
                        //  weather.weather?[0].icon
                    }
                    print("\(data)")
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
