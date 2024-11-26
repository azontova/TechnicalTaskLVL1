//
//  UsersListViewController.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 25.11.24.
//

import UIKit

final class UsersListViewController: UIViewController {
    
    private var viewModel: UsersListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
    }
}
