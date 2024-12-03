//
//  UsersListCoordinator.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 26.11.24.
//

import UIKit

final class UsersListCoordinator {
    private weak var navigationController: UINavigationController?
    private weak var window: UIWindow?
    
    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        guard let viewController = makeViewController(), let window = window else { return }
        navigationController?.pushViewController(viewController, animated: true)
        window.rootViewController = navigationController
    }
    
    func navigateToCreateUser() {
        let createUser = CreateUserCoordinator(navigationController: navigationController)
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
