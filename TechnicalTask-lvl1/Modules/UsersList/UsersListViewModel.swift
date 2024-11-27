//
//  UsersListViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 25.11.24.
//

import Combine

final class UsersListViewModel: ViewModelType {
    
    private let coordinator: UsersListCoordinator
    private let apiService: ApiService

    init(coordinator: UsersListCoordinator, apiService: ApiService) {
        self.coordinator = coordinator
        self.apiService = apiService
    }
}

// MARK: ViewModelType

extension UsersListViewModel {
    struct Input {
        let addTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let users: AnyPublisher<[User], Never>
        let navigateToCreateUser: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let users = apiService.fetchUsers().catch { _ in Just([]) }.eraseToAnyPublisher()
        return Output(users: users,
                      navigateToCreateUser: input.addTapped)
    }
}
