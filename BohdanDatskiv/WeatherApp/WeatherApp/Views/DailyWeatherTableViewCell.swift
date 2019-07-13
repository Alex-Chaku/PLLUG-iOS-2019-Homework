//
//  DailyWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 7/1/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

//----------------------------------------
// MARK: - DailyWeatherTableViewCell
//----------------------------------------
class DailyWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
}
