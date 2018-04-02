//
//  WeatherLocation.swift
//  WeatherGift1
//
//  Created by Jack Sexton on 3/28/18.
//  Copyright © 2018 Jack Sexton. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation
{
    struct DailyForecast
    {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailyDate: Double
        var dailySummary: String
        var dailyIcon: String
        
    }
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var dailyForecastArray = [DailyForecast]()
    
    func getWeather(completed: @escaping () -> ())
    {
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON
        {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value) // convert network data to json
                if let tempurature = json["currently"]["temperature"].double
                {
                    let roundedTemp = String(format: "%3.f", tempurature)
                    self.currentTemp = roundedTemp + "°"
                }
                else
                {
                     print("could not return temperature")
                }
                if let summary = json["daily"]["summary"].string
                {
                    self.currentSummary = summary
                }
                else
                {
                    print("could not return summary")
                }
                if let icon = json["currently"]["icon"].string
                {
                    self.currentIcon = icon
                }
                else
                {
                    print("could not return an icon")
                }
                if let timeZone = json["timezone"].string
                {
                    self.timeZone = timeZone
                }
                else
                {
                    print("could not return a time zone")
                }
                if let time = json["currently"]["time"].double
                {
                    self.currentTime = time
                }
                else
                {
                    print("could not return a time")
                }
                
                let dailyDataArray = json["daily"]["data"]
                self.dailyForecastArray = []
                
                for day in 1...dailyDataArray.count-1
                {
                    let maxTemp = json["daily"]["data"][day]["temperatureHigh"].doubleValue
                    let minTemp = json["daily"]["data"][day]["temperatureLow"].doubleValue
                    let dateValue = json["daily"]["data"][day]["time"].doubleValue
                    let icon = json["daily"]["data"][day]["icon"].stringValue
                    let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                    
                     let newDailyForecast = DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailyDate: dateValue, dailySummary: dailySummary, dailyIcon: icon)
                    
                    self.dailyForecastArray.append(newDailyForecast)
                }
            case let .failure(error):
                print("error: \(error)") 
            }
            completed()
        }
    }
    
}
 
