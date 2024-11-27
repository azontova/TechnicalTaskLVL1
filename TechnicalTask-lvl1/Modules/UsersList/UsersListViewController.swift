//
//  UsersListViewController.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 25.11.24.
//

import Combine
import UIKit

final class UsersListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: UsersListViewModel?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func configure(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: Private

private extension UsersListViewController {
    
    func setup() {
        navigationItem.title = "Users"
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "UserTableViewCell")
    }
}

