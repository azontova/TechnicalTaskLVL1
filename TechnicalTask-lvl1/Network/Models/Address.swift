//
//  Address.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 27.11.24.
//

import Foundation

struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    
    var fullAddress: String {
        return "\(city), \(street), \(suite), \(zipcode)"
    }
}
