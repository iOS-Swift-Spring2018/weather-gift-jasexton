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
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    
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
                     print("could not return temp")
                }
            case let .failure(error):
                print("error: \(error)")
            }
            completed()
        }
    }
    
}
 
