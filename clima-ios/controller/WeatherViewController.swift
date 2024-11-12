import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var liveLocationBtn: UIButton!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up location manager and request location authorization
        locationManager.delegate = self
    
        locationManager.requestWhenInUseAuthorization()
        
     
            locationManager.requestLocation()
     
        
        // Set the delegate for the text field
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
 
    @IBAction func searchBtnPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func liveBtnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(weather.temp)
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didGetError(error: Error) {
        print("Error fetching weather data: \(error)")
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please enter a city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchData(cityName: city)
        } else {
            print("Invalid city name")
        }
        searchTextField.text = ""
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location received")
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = Float(location.coordinate.latitude)
            let lon = Float(location.coordinate.longitude)
            weatherManager.fetchData(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
}
