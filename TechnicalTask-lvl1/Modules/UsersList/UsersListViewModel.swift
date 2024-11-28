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
    private let coreDataManager = CoreDataManager.shared

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
        let users = apiService.fetchUsers()
            .handleEvents(receiveOutput: { [unowned self] fetchedUsers in
                self.saveUsers(fetchedUsers)
            })
            .flatMap { _ in
                Just(self.coreDataManager.fetchUsers())
            }
            .catch { _ in
                Just(self.coreDataManager.fetchUsers())
            }
            .eraseToAnyPublisher()
        
        return Output(users: users,
                      navigateToCreateUser: input.addTapped)
    }
}

// MARK: Private

private extension UsersListViewModel {
    
    private func saveUsers(_ users: [User]) {
        coreDataManager.saveUsers(users)
    }
}
