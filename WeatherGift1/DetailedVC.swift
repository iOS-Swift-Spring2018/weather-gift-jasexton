//
//  DetailedVC.swift
//  WeatherGift1
//
//  Created by Jack Sexton on 3/26/18.
//  Copyright © 2018 Jack Sexton. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter =
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM dd, y"
    return dateFormatter
}()

class DetailedVC: UIViewController
{
   
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempuratureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        if currentPage != 0
        {
            self.locationsArray[currentPage].getWeather
            {
                self.updateUserInterface()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if currentPage == 0
        {
            getLocation()
        }
    }
    
    func updateUserInterface()
    {
        let location = locationsArray[currentPage]
        locationLabel.text = location.name
        
        let dateString = location.currentTime.format(timeZone: location.timeZone, dateFormatter: dateFormatter)
        dateLabel.text = dateString
        tempuratureLabel.text = location.currentTemp
        summaryLabel.text = location.currentSummary
        currentImage.image = UIImage(named: locationsArray[currentPage].currentIcon)
        tableView.reloadData()
    }
    

}

extension DetailedVC: CLLocationManagerDelegate
{
    
    func getLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
    }
    
    func handleLocationAutorizationStatus(status: CLAuthorizationStatus)
    {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            print("I'm Sorry - user did not authorize")
        case .restricted:
            print("Access denied, likely parent controls")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        handleLocationAutorizationStatus(status: status)
        
    }
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager)
    {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let geoCoder = CLGeocoder()
        var place = ""
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler:
        {
            placemarks, error in
            if placemarks != nil
            {
                let placemark = placemarks?.last
                place = (placemark?.name)!
            }
            else
            {
                print("Error retrieving place: \(error)")
                place = "unknown weather location"
            }
            self.locationsArray[self.currentPage].name = place
            self.locationsArray[self.currentPage].coordinates = currentCoordinates
            self.locationsArray[self.currentPage].getWeather
            {
                self.updateUserInterface()
            }
            
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Failed to get Location")
    }
}

extension DetailedVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locationsArray[currentPage].dailyForecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath) as! DayWeatherCell
        let dailyForecast = locationsArray[currentPage].dailyForecastArray[indexPath.row]
        let timeZone = locationsArray[currentPage].timeZone
        cell.update(with: dailyForecast, timeZone: timeZone)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}
extension DetailedVC: UICollectionViewDataSource, UICollectionViewDelegate
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath)
        return hourlyCell
    }
}



