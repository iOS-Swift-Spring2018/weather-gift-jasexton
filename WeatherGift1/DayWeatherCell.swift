//
//  DayWeatherCell.swift
//  WeatherGift1
//
//  Created by Jack Sexton on 4/2/18.
//  Copyright © 2018 Jack Sexton. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter =
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM dd, y"
    return dateFormatter
}()

class DayWeatherCell: UITableViewCell
{
    @IBOutlet weak var dayCellIIcon: UIImageView!
    @IBOutlet weak var dayCellWeekday: UILabel!
    @IBOutlet weak var dayCellMaxTemp: UILabel!
    @IBOutlet weak var dayCellMinTemp: UILabel!
    @IBOutlet weak var dayCellSummary: UITextView!
    
    

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
    func update(with dailyForecast: WeatherLocation.DailyForecast, timeZone: String)
    {
        dayCellIIcon.image = UIImage(named: dailyForecast.dailyIcon)
        dayCellSummary.text = dailyForecast.dailySummary
        dayCellMaxTemp.text = String(format: "%2.f", dailyForecast.dailyMaxTemp) + "°"
        dayCellMinTemp.text = String(format: "%2.f", dailyForecast.dailyMinTemp) + "° "
 
        let dateString = dailyForecast.dailyDate.format(timeZone: timeZone, dateFormatter: dateFormatter)
        
        dayCellWeekday.text = dateString
        
        
    }

}
