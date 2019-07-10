//
//  DetailCollectionViewCell.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/17/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

//----------------------------------------
// MARK: - DetailCollectionViewCell
//----------------------------------------
class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
}
