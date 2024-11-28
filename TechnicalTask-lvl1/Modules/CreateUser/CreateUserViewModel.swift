//
//  CreateUserViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by User on 28/11/2024.
//

import Combine

final class CreateUserViewModel: ViewModelType {
    
    private let coordinator: CreateUserCoordinator

    init(coordinator: CreateUserCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: ViewModelType

extension CreateUserViewModel {
    
    struct Input {
        let saveTapped: AnyPublisher<Void, Never>
        let backTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let back: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let back = input.backTapped
            .map { [weak self] _ in
                guard let self else { return }
                coordinator.back()
            }
            .eraseToAnyPublisher()
        
        return Output(back: back)
    }
}
