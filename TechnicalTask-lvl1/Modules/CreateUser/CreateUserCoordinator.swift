//
//  CreateUserCoordinator.swift
//  TechnicalTask-lvl1
//
//  Created by User on 28/11/2024.
//

import UIKit

final class CreateUserCoordinator {
    
    private weak var presenterController: UINavigationController?
    
    init(presenter: UINavigationController?) {
        self.presenterController = presenter
    }
    
    func start() {
        guard let viewController = makeViewController() else { return }
        presenterController?.pushViewController(viewController, animated: true)
    }
    
    func back() {
        presenterController?.popViewController(animated: true)
    }
}

// MARK: Private
private extension CreateUserCoordinator {
    
    func makeViewController() -> UIViewController? {
        guard let viewController = UIStoryboard(name: "CreateUser", bundle: nil).instantiateInitialViewController() as? CreateUserViewController else { return nil }
        let viewModel = CreateUserViewModel(coordinator: self)
        viewController.configure(viewModel: viewModel)
        return viewController
    }
}
