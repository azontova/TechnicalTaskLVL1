//
//  Validator.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 29.11.24.
//

import Foundation

protocol ValidationRule {
    var isValid: Bool { get }
}

struct IsNameRule: ValidationRule {
    
    private let string: String
    
    var isValid: Bool {
        RegexRule(value: string, regex: "^[a-zA-Z'-]{2,30}$").isValid
    }
    
    init(string: String) {
        self.string = string
    }
}

struct IsEmailRule: ValidationRule {
    
    private let string: String
    
    var isValid: Bool {
        RegexRule(value: string, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}").isValid
    }
    
    init(string: String) {
        self.string = string
    }
}

struct IsCityRule: ValidationRule {
    
    private let string: String
    
    var isValid: Bool {
        guard !string.isEmpty else { return true }
        return RegexRule(value: string, regex: "^[a-zA-Z\\s-]{2,50}$").isValid
    }
    
    init(string: String) {
        self.string = string
    }
}

struct IsStreetRule: ValidationRule {
    
    private let string: String
    
    var isValid: Bool {
        guard !string.isEmpty else { return true }
        return RegexRule(value: string, regex: "^[a-zA-Z0-9\\s-]{2,100}$").isValid
    }
    
    init(string: String) {
        self.string = string
    }
}

struct RegexRule<T>: ValidationRule {
    
    private let value: T
    private let regex: String
    
    var isValid: Bool {
        NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: value)
    }
    
    init(value: T, regex: String) {
        self.value = value
        self.regex = regex
    }
}

enum ValidationError: Error {
    case invalidName
    case invalidEmail
    case invalidCity
    case alreadyExistEmail
    case invalidStreet
    
    var title: String {
        switch self {
        case .invalidName:
            return "Invalid name"
        case .invalidEmail:
            return "Invalid email"
        case .invalidCity:
            return "Invalid city"
        case .alreadyExistEmail:
            return "User with this email already exists"
        case .invalidStreet:
            return "Invalid street"
        }
    }
}
