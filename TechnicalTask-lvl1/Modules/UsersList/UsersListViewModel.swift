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
        let isConnectionAvailable: AnyPublisher<Bool, Never>
        let addTapped: AnyPublisher<Void, Never>
        let deleteTapped: AnyPublisher<User, Never>
    }
    
    struct Output {
        let users: AnyPublisher<[User], Never>
        let navigateToCreateUser: AnyPublisher<Void, Never>
        let showNoConnection: AnyPublisher<Bool, Never>
    }
    
    func transform(input: Input) -> Output {
        let fetchedUsers = apiService.fetchUsers()
            .handleEvents(receiveOutput: { [unowned self] users in
                self.coreDataManager.saveUsers(users)
            })
            .flatMap { _ in
                Just(self.coreDataManager.fetchUsers())
            }
            .catch { _ in
                Just(self.coreDataManager.fetchUsers())
            }
            .eraseToAnyPublisher()
        
        let updatedUsers = input.deleteTapped
            .handleEvents(receiveOutput: { [unowned self] user in
                self.coreDataManager.deleteUser(user: user)
            })
            .flatMap { _ in
                Just(self.coreDataManager.fetchUsers())
            }
            .eraseToAnyPublisher()
        
        let users = fetchedUsers.merge(with: updatedUsers).eraseToAnyPublisher()
        
        let showNoConnection = input.isConnectionAvailable
            .map { $0 }
            .eraseToAnyPublisher()
        
        return Output(users: users,
                      navigateToCreateUser: input.addTapped,
                      showNoConnection: showNoConnection)
    }
}
