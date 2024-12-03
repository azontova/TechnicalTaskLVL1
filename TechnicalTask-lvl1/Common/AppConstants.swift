//
//  AppConstants.swift
//  TechnicalTask-lvl1
//
//  Created by User on 03/12/2024.
//

import UIKit

enum AppConstants {
    enum StoryboardScene {
        static let createUserStoryboard = "CreateUser"
        static let usersListStoryboard = "UsersList"
    }
    
    enum Colors {
        static let nightBlue = UIColor.init(rgb: 0x1C1D38)
        static let yellow = UIColor.init(rgb: 0xEABE41)
        static let lightRed = UIColor.init(rgb: 0xE46868)
    }
    
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    static let nameRegex = "^[a-zA-Z'-]{2,30}$"
    static let cityRegex = "^[a-zA-Z\\s-]{2,50}$"
    static let streetRegex = "^[a-zA-Z0-9\\s-]{2,100}$"
    
    static let serviceURL = "https://jsonplaceholder.typicode.com/users"
}
