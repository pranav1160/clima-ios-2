import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didGetError(error: Error)
}

class WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=12e4d1c38921edcd381ab580ea6147b8&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchData(cityName: String) {
        let completeUrl = "\(url)&q=\(cityName)"
        performRequest(with: completeUrl)
    }
    
    func fetchData(latitude:Float,longitude:Float){
        let completeUrl = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: completeUrl)
    }
    
    func performRequest(with urlString: String) {
        // Step 1 - Create URL
        if let url = URL(string: urlString) {
            // Step 2 - Create a URL session
            let session = URLSession(configuration: .default)
            
            // Step 3 - Give session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    // Networking error
                    self.delegate?.didGetError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // Step 4 - Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            
            let id: Int = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            return weather
        } catch {
            // Error in JSON format type
            self.delegate?.didGetError(error: error)
            return nil
        }
    }
}
