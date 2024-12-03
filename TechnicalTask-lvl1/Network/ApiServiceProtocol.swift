//
//  ApiServiceProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by User on 03/12/2024.
//

import Combine
import Foundation

protocol ApiServiceProtocol {
    func fetchUsers() -> AnyPublisher<[User], Error>
}
