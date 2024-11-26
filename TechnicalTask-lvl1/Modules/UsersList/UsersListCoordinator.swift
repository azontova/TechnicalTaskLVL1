//
//  UsersListCoordinator.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 26.11.24.
//

import UIKit

final class UsersListCoordinator {
    private weak var presenter: UINavigationController?
    private weak var window: UIWindow?
    
    init(window: UIWindow?, presenter: UINavigationController?) {
        self.window = window
        self.presenter = presenter
    }
    
    func start() {
        guard let viewController = makeViewController(), let window = window else { return }
        presenter?.isNavigationBarHidden = true
        presenter?.pushViewController(viewController, animated: true)
        window.rootViewController = presenter
    }
}

// MARK: Private

private extension UsersListCoordinator {
    
    func makeViewController() -> UIViewController? {
        guard let viewController = UIStoryboard(name: "UsersList", bundle: nil).instantiateInitialViewController() as? UsersListViewController else { return nil }
        let viewModel = UsersListViewModel(coordinator: self)
        viewController.configure(viewModel: viewModel)
        return viewController
    }
}
