//
//  ApiService.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 27.11.24.
//

import Alamofire
import Combine

final class ApiService: ApiServiceProtocol {
   
    func fetchUsers() -> AnyPublisher<[User], Error> {
        AF.request(AppConstants.serviceURL)
                .validate()
                .publishDecodable(type: [User].self)
                .value()
                .mapError { $0 as Error } 
                .eraseToAnyPublisher()
    }
}
