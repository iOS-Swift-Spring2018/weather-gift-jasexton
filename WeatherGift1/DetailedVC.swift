//
//  DetailedVC.swift
//  WeatherGift1
//
//  Created by Jack Sexton on 3/26/18.
//  Copyright © 2018 Jack Sexton. All rights reserved.
//

import UIKit
import CoreLocation

class DetailedVC: UIViewController
{
   
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempuratureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        tempuratureLabel.text = locationsArray[currentPage].currentTemp
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
        dateLabel.text = currentCoordinates
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
