//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
//UITextFieldDelgate är den som tar emot input från iPhone keyboard
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    
}//end class WeatherViewController


// MARK: - UITextViewDelegate
//Before those methods and calling one class in one class. Now we made it in extension instead.

extension WeatherViewController: UITextFieldDelegate {
    //Till search-iconen button
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) //dölj keyboard efter när user har enter
        // print(searchTextField.text!)
    }
    
    //Till keyboard den user pressed Go/Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) //dölj keyboard efter när user har enter
        return true
    }
    
    //You want to alert user to write something text before pressing enter
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            //du kan kalla ALLA textField, men vill du kalla EN så kallar du searchTextField
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
    //rensa gamla text efter user har enter
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Use searchTextField.text to get the weather for that city
        //för att texten är String? Så måste city vara optional med ? : null eller String
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}//end extension WeatherViewController: UITextViewDelegate

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel){
        //fom chapter 156. It says that it can crash and you need to call this to controll the network and some other data.
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            print(weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }//end didUpdateWeather
    
    func didFailWithError(error: Error) {
        print(error)
    }
}//end extension WeatherViewController:WeatherManagerDelegate



