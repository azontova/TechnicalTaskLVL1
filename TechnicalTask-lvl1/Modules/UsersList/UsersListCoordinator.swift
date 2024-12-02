//
//  UsersListCoordinator.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 26.11.24.
//

import UIKit

final class UsersListCoordinator {
    private weak var presenterController: UINavigationController?
    private weak var window: UIWindow?
    
    init(window: UIWindow?, presenter: UINavigationController?) {
        self.window = window
        self.presenterController = presenter
    }
    
    func start() {
        guard let viewController = makeViewController(), let window = window else { return }
        presenterController?.pushViewController(viewController, animated: true)
        window.rootViewController = presenterController
    }
    
    func navigateToCreateUser() {
        let createUser = CreateUserCoordinator(presenter: presenterController)
        createUser.start()
    }
}

// MARK: Private

private extension UsersListCoordinator {
    
    func makeViewController() -> UIViewController? {
        guard let viewController = UIStoryboard(name: "UsersList", bundle: nil).instantiateInitialViewController() as? UsersListViewController else { return nil }
        let viewModel = UsersListViewModel(coordinator: self,
                                           apiService: .init())
        viewController.configure(viewModel: viewModel)
        return viewController
    }
}
