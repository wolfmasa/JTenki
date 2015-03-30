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


    @IBOutlet weak var myLabel: UILabel!

    override func viewDidLoad() {
        myLabel.text = label
    }
}
