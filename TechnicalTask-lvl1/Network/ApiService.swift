//
//  ApiService.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 27.11.24.
//

import Alamofire
import Combine

final class ApiService {
    private let serviceURL = "https://jsonplaceholder.typicode.com/users"

    func fetchUsers() -> AnyPublisher<[User], Error> {
        return Future<[User], Error> { promise in
            AF.request(self.serviceURL)
                .validate()
                .responseDecodable(of: [User].self) { response in
                    switch response.result {
                    case .success(let users):
                        promise(.success(users))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}

