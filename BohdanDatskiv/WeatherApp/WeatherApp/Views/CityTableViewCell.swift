//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/10/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

//----------------------------------------
// MARK: - CityTableViewCell
//----------------------------------------
class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityTemparetureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
