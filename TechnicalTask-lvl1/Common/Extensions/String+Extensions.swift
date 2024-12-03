//
//  String+Extensions.swift
//  TechnicalTask-lvl1
//
//  Created by User on 03/12/2024.
//

import Foundation

extension String {
    func containsRegexMatch(_ regex: String) -> Bool {
         return self.range(of: regex, options: .regularExpression) != nil
     }
}
