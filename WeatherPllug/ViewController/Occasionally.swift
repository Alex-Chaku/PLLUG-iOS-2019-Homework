//
//  Occasionally.swift
//  WeatherPllug
//
//  Created by Nazar Kovalik on 6/24/19.
//  Copyright © 2019 Nazar Kovalik. All rights reserved.
//

import Foundation
import UIKit

func convertUTC(dateToConvert: String) -> String {
    let format = DateFormatter()
    format.dateFormat =  "MMM d, yyyy 'at' HH:mm:ss 'AM'"
    let convertedDate = format.date(from: dateToConvert)
    format.timeZone = TimeZone.current
    format.dateFormat = "MMM d"
    let localDate = format.string(from: convertedDate!)
    return localDate
}
