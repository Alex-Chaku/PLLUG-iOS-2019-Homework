//
//  AddCityTableViewCell.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/9/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

//----------------------------------------
// MARK: - AddCityTableViewCell
//----------------------------------------
class AddCityTableViewCell: UITableViewCell {
    
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
