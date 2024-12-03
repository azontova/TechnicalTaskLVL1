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
    
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()

    init(coordinator: UsersListCoordinator, apiService: ApiService) {
        self.coordinator = coordinator
        self.apiService = apiService
    }
}

// MARK: ViewModelType

extension UsersListViewModel {
    
    struct Input {
        let isConnectionAvailable: AnyPublisher<Bool, Never>
        let refreshData: AnyPublisher<Void, Never>
        let addTapped: AnyPublisher<Void, Never>
        let deleteTapped: AnyPublisher<User, Never>
    }
    
    struct Output {
        let users: AnyPublisher<[User], Never>
        let navigateToCreateUser: AnyPublisher<Void, Never>
        let showNoConnection: AnyPublisher<Bool, Never>
        let isLoading: AnyPublisher<Bool, Never>
    }
    
    func transform(input: Input) -> Output {
        let fetchedUsers = fetchUsers()
        
        let updatedUsers = input.deleteTapped
            .handleEvents(receiveOutput: { [weak self] user in
                guard let self else { return }
                self.coreDataManager.deleteUser(user: user)
            })
            .flatMap { [weak self] _ -> AnyPublisher<[User], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                return Just(self.coreDataManager.fetchUsers()).eraseToAnyPublisher()
            }
        
        let restoredUsers = input.isConnectionAvailable
            .dropFirst()
            .removeDuplicates()
            .filter { $0 }
            .flatMap { [weak self] _ -> AnyPublisher<[User], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                return self.fetchUsers()
            }
        
        let refreshedUsers = input.refreshData
            .flatMap { [weak self] _ -> AnyPublisher<[User], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                return self.fetchUsers()
            }
        
        let users = Publishers.Merge4(fetchedUsers,
                                      updatedUsers,
                                      refreshedUsers,
                                      restoredUsers).eraseToAnyPublisher()
        
        let showNoConnection = input.isConnectionAvailable
            .map { $0 }
            .eraseToAnyPublisher()
        
        let navigateToCreateUser = input.addTapped
            .map { [weak self] _ in
                guard let self else { return }
                coordinator.navigateToCreateUser()
            }
            .eraseToAnyPublisher()
        
        return Output(users: users,
                      navigateToCreateUser: navigateToCreateUser,
                      showNoConnection: showNoConnection,
                      isLoading: isLoadingSubject.eraseToAnyPublisher())
    }
}

private extension UsersListViewModel {
    
    func fetchUsers() -> AnyPublisher<[User], Never> {
        apiService.fetchUsers()
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    guard let self else { return }
                    self.isLoadingSubject.send(true)
                },
                receiveOutput: { [weak self] users in
                    guard let self else { return }
                    self.coreDataManager.saveUsers(users)
                },
                receiveCompletion: { [weak self] _ in
                    guard let self else { return }
                    self.isLoadingSubject.send(false)
                }
            )
            .flatMap { [weak self] _ -> AnyPublisher<[User], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                return Just(self.coreDataManager.fetchUsers()).eraseToAnyPublisher()
            }
            .catch { _ -> AnyPublisher<[User], Never> in
                Just([]).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
