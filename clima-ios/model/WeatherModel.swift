import UIKit

struct WeatherModel{
    let conditionId:Int;
    let cityName:String;
    let temp:Double;
    
    var conditionName:String{
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"  // Thunderstorm
        case 300...321:
            return "cloud.drizzle"    // Drizzle
        case 500...531:
            return "cloud.rain"       // Rain
        case 600...622:
            return "cloud.snow"       // Snow
        case 701...781:
            return "cloud.fog"        // Atmosphere (mist, smoke, haze, etc.)
        case 800:
            return "sun.max"          // Clear sky
        case 801...804:
            return "cloud.bolt"            // Clouds
        default:
            return "cloud"     // Unknown condition
        }
    }
    
    
}

