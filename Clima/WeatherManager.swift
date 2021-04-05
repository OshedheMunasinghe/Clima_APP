//
//  WeatherManager.swift
//  Clima
//
//  Created by Oshedhe Munasinghe on 2021-04-04.
//  Copyright © 2021 App Brewery. All rights reserved.
//
//struct där classsen kan kopiera en object
import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=aae2c16845518c7813b55edbd4954ebf&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }//end func
    
    func performRequest(with urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString){
            //2. Create a URLSecssion
            let session = URLSession(configuration: .default) //det har med webb browser att göra...
            //3. Give the sesion a task
            let task = session.dataTask(with: url) { (data, respons, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if  let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            //4. Start the task
            task.resume()
        }//end if statement
        
    }//end performRequest
    
    //this method convert to nice text JSON
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            // print(decoderData.main.temp)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            // WeatherModel är struct
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
          //  print(weather.temperatureString)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }//end try catch
    }//end parseJSON
    
}//end Class
