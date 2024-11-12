import UIKit

struct WeatherData:Codable{
    let name:String
    let main:Main
    let weather:[Weather]
}

struct Main:Codable{
    let temp:Double
    let feels_like:Double
}

struct Weather:Codable{
    let main:String;
    let description:String;
    let id : Int;
}
