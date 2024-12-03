//
//  Validator.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 29.11.24.
//

import Foundation

protocol Validator {
    func validate(value: String, inputType: DataInputType) -> Bool
}

struct DefaultValidator: Validator {
    
    func validate(value: String, inputType: DataInputType) -> Bool {
        let regexRule: String
        switch inputType {
        case .name:
            regexRule = AppConstants.nameRegex
        case .email:
            regexRule = AppConstants.emailRegex
        case .city:
            regexRule = AppConstants.cityRegex
        case .street:
            regexRule = AppConstants.streetRegex
        }
        
        return value.containsRegexMatch(regexRule)
    }
}

enum ValidationError {
    case invalidName
    case invalidEmail
    case invalidCity
    case invalidStreet
}

enum AppError {
    case unknowned
    case validation(Set<ValidationError>)
    case alreadyExistEmail
}
