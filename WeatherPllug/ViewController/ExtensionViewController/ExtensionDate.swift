//
//  ExtensionDate.swift
//  WeatherPllug
//
//  Created by Nazar Kovalik on 6/27/19.
//  Copyright © 2019 Nazar Kovalik. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    func convertUTC(dateToConvert: String) -> String {
        let format = DateFormatter()
        format.dateFormat =  "MMM d, yyyy 'at' HH:mm:ss 'AM'"
        let convertedDate = format.date(from: dateToConvert)
        format.timeZone = TimeZone.current
        format.dateFormat = "MMM d"
        let localDate = format.string(from: convertedDate!)
        return localDate
    }
    func convertUTCDate(dateToConvert: String) -> String {
        let format = DateFormatter()
        format.dateFormat =  "yyyy-MM-dd HH:mm:ss "
        let convertedDate = format.date(from: dateToConvert)
        format.timeZone = TimeZone.current
        format.dateFormat = "HH"
        let localDateStr = format.string(from: convertedDate!)
        hour = localDateStr
        return localDateStr
    }
}
