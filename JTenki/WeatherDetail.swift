//
//  WeatherDetail.swift
//  JTenki
//
//  Created by ICP223G on 2015/03/30.
//  Copyright (c) 2015年 ProjectJ. All rights reserved.
//

import UIKit

class WeatherDetail : UIViewController {
    var label: String = ""
    var image: UIImage? = nil


    @IBOutlet weak var myLabel: UILabel!

    @IBOutlet weak var weatherImage: UIImageView!
    override func viewDidLoad() {
        myLabel.text = label

        if let img = image {
            weatherImage.image = img
        }
    }
}
