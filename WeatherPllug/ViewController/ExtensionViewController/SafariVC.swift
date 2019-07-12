//
//  SafariVC.swift
//  WeatherPllug
//
//  Created by Nazar Kovalik on 7/12/19.
//  Copyright © 2019 Nazar Kovalik. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension ViewController{
    func showSafariVC(for url: String)   {
        guard let url = URL(string: url) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
   
}
