//
//  Person.swift
//  pllugHW
//
//  Created by Богдан Дацьків on 3/27/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

class Person: Codable {
    let uuid = UUID().uuidString
    let name: String
    let surname: String
    
    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
    }
}
