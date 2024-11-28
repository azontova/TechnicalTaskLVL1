//
//  User.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 27.11.24.
//

import Foundation

struct User: Decodable {
    let name: String
    let email: String
    let address: Address
}
