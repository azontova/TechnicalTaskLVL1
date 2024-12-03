//
//  CreateUserViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by User on 28/11/2024.
//

import Combine

final class CreateUserViewModel: ViewModelType {
    
    private let coordinator: CreateUserCoordinator
    private let coreDataManager = CoreDataManager.shared
    private let validator: Validator

    init(coordinator: CreateUserCoordinator, validator: Validator) {
        self.coordinator = coordinator
        self.validator = validator
    }
}

// MARK: ViewModelType

extension CreateUserViewModel {
    
    struct Input {
        let saveTapped: AnyPublisher<Void, Never>
        let inputName: AnyPublisher<String, Never>
        let inputEmail: AnyPublisher<String, Never>
        let inputCity: AnyPublisher<String, Never>
        let inputStreet: AnyPublisher<String, Never>
        let backTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let back: AnyPublisher<Void, Never>
        let createUser: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let userDetails = Publishers.CombineLatest4(
            input.inputName,
            input.inputEmail,
            input.inputCity,
            input.inputStreet
        )
                
        let createdUser = input.saveTapped
            .combineLatest(userDetails)
            .map { _, userDetails in
                User(name: userDetails.0,
                     email: userDetails.1,
                     address: .init(street: userDetails.3, suite: "", city: userDetails.2, zipcode: ""))
            }
            .handleEvents(receiveOutput: { user in
                self.coreDataManager.saveUsers([user])
                self.coordinator.back()
            })
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let back = input.backTapped
            .map { [weak self] in
                guard let self else { return }
                self.coordinator.back()
            }
            .eraseToAnyPublisher()
           
        return Output(back: back,
                      createUser: createdUser)
    }
}
