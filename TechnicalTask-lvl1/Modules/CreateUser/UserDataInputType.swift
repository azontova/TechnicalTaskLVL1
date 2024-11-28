//
//  UserDataInputType.swift
//  TechnicalTask-lvl1
//
//  Created by User on 28/11/2024.
//

import Foundation

enum UserDataInputType {
    case name
    case email
    case city
    case street
    
    var title: String {
        switch self {
        case .name:
            return "User name"
        case .email:
            return "User email"
        case .city:
            return "City name"
        case .street:
            return "Street name"
        }
    }
    
    var placeholder: String {
        switch self {
        case .name:
            return "Enter user name"
        case .email:
            return "Enter email"
        case .city:
            return "Enter city"
        case .street:
            return "Enter street"
        }
    }
}
