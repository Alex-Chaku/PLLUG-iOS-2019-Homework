//
//  Human.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

class Human: Hashable {
    
    let name: String
    let surname: String
    let passport: String
    
    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
        self.passport = NSUUID().uuidString.lowercased()
    }
    
    static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.name == rhs.name && lhs.surname == rhs.surname && lhs.passport == rhs.passport
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(surname)
        hasher.combine(passport)
    }
}
