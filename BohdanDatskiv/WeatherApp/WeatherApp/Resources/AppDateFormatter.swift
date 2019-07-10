//
//  AppDateFormatter.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/15/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

// --------------------------------------
// MARK: - AppDateFormatter
// --------------------------------------
struct AppDateFormatter {
    
    ///Private
    private static let hourAndMinutesDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    private static let hourDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter
    }()
    
    private static let dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    /// Format
    enum Format {
        case hourAndMinutes
        case hour
        case day
    }
    
    ///Public
    static func string(from date: Date?, timeZone: TimeZone, format: Format) -> String {
        guard let date = date else { return "" }
        switch format {
        case .hourAndMinutes:
            hourAndMinutesDateFormatter.timeZone = timeZone
            return hourAndMinutesDateFormatter.string(from: date)
        case .hour:
            hourDateFormatter.timeZone = timeZone
            return hourDateFormatter.string(from: date)
        case .day:
            dayDateFormatter.timeZone = timeZone
            return dayDateFormatter.string(from: date)
        }
    }
}
