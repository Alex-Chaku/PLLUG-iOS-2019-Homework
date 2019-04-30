//
//  Human.swift
//  hw1
//
//  Created by Markiyan Prysiazhniuk on 4/11/19.
//  Copyright © 2019 Markiyan Prysiazhniuk. All rights reserved.
//

import Foundation

class Human: Hashable, Codable {
    
    let name: String
    let surname: String
    let passport: String
    
    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
        self.passport = NSUUID().uuidString.lowercased()
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case surname
        case passport
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(passport, forKey: .passport)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        passport = try container.decode(String.self, forKey: .passport)
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
