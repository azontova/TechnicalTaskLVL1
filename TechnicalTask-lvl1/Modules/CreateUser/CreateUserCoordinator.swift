//
//  CreateUserCoordinator.swift
//  TechnicalTask-lvl1
//
//  Created by User on 28/11/2024.
//

import UIKit

final class CreateUserCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let viewController = makeViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Private
private extension CreateUserCoordinator {
    
    func makeViewController() -> UIViewController? {
        guard let viewController = UIStoryboard(
            name: AppConstants.StoryboardScene.createUserStoryboard,
            bundle: nil
        ).instantiateInitialViewController() as? CreateUserViewController else { return nil }
        let viewModel = CreateUserViewModel(coordinator: self,
                                            validator: DefaultValidator())
        viewController.configure(viewModel: viewModel)
        return viewController
    }
}
