//
//  DetailedVC.swift
//  WeatherGift1
//
//  Created by Jack Sexton on 3/26/18.
//  Copyright © 2018 Jack Sexton. All rights reserved.
//

import UIKit

class DetailedVC: UIViewController
{
   
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempuratureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var currentPage = 0
    var locationsArray = [String]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationLabel.text = locationsArray[currentPage]
        

    }


}
