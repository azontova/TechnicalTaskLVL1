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

    init(coordinator: CreateUserCoordinator) {
        self.coordinator = coordinator
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
        let validationError: AnyPublisher<[ValidationError], Never>
        let createUser: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let userDetails = Publishers.CombineLatest4(
            input.inputName,
            input.inputEmail,
            input.inputCity,
            input.inputStreet
        )
        
        let validationError = input.saveTapped
            .combineLatest(userDetails)
            .map { [weak self] _, userDetails -> [ValidationError] in
                guard let self else { return [] }
                var errors: [ValidationError] = [
                    self.validateName(userDetails.0),
                    self.validateEmail(userDetails.1),
                    self.validateCity(userDetails.2),
                    self.validateStreet(userDetails.3)
                ]
                
                return errors
            }
            .eraseToAnyPublisher()
                
        let createdUser = validationError
            .filter { $0.filter { $0 != .none }.isEmpty }
            .combineLatest(userDetails)
            .map { _, userDetails in
                User(name: userDetails.0,
                     email: userDetails.1,
                     address: .init(street: userDetails.3, suite: "", city: userDetails.2, zipcode: ""))
            }
            .handleEvents(receiveOutput: { [weak self] user in
                guard let self else { return }
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
                      validationError: validationError,
                      createUser: createdUser)
    }
}

// MARK: Private

private extension CreateUserViewModel {
    
    func validateName(_ name: String) -> ValidationError {
        IsNameRule(string: name).isValid ? .none : .invalidName
    }

    func validateCity(_ city: String) -> ValidationError {
        IsCityRule(string: city).isValid ? .none : .invalidCity
    }

    func validateStreet(_ street: String) -> ValidationError {
        IsStreetRule(string: street).isValid ? .none : .invalidStreet
    }

    func validateEmail(_ email: String) -> ValidationError {
        if !IsEmailRule(string: email).isValid {
            return .invalidEmail
        }
        if coreDataManager.userExists(with: email) {
            return .alreadyExistEmail
        }
        return .none
    }
}
