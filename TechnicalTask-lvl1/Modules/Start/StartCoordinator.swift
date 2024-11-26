//
//  StartCoordinator.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 26.11.24.
//

import UIKit

final class StartCoordinator {
    
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        guard let window = window else { return }
        let navigationController = UINavigationController()
        UsersListCoordinator(window: window, presenter: navigationController).start()
    }
}
